module InsuranceContractsController

import Base: @kwdef
import TimeZones
using TimeZones
import ToStruct
using ToStruct
import JSON
using JSON
import SearchLight
using SearchLight
import BitemporalPostgres
using BitemporalPostgres
include("InsuranceContracts.jl")
using .InsuranceContracts
export Contract,
    ContractRevision,
    ContractPartnerRole,
    ContractPartnerRef,
    ContractPartnerRefRevision,
    ProductItem,
    ProductItemRevision,
    ProductItemTariffRole,
    ProductItemTariffRef,
    ProductItemTariffRefRevision,
    ProductItemPartnerRole,
    ProductItemPartnerRef,
    ProductItemPartnerRefRevision
include("InsurancePartners.jl")
using .InsurancePartners

export Partner, PartnerRevision
include("InsuranceTariffs.jl")
using .InsuranceTariffs
export Tariff, TariffRevision
export ContractSection, ProductItemSection, PartnerSection, TariffSection, csection, pisection, tsection, psection
export insurancecontracts_view

@kwdef mutable struct PartnerSection
    tsdb_validfrom::TimeZones.ZonedDateTime = now(tz"UTC")
    tsw_validfrom::TimeZones.ZonedDateTime = now(tz"UTC")
    ref_history::SearchLight.DbId = DbId(InfinityKey)
    ref_version::SearchLight.DbId = MaxVersion
    partner_revision::PartnerRevision = PartnerRevision()
end


@kwdef mutable struct TariffSection
    tsdb_validfrom::TimeZones.ZonedDateTime = now(tz"UTC")
    tsw_validfrom::TimeZones.ZonedDateTime = now(tz"UTC")
    ref_history::SearchLight.DbId = DbId(InfinityKey)
    ref_version::SearchLight.DbId = MaxVersion
    tariff_revision::TariffRevision = TariffRevision()
end

@kwdef mutable struct ProductItemSection
    productitem_revision::ProductItemRevision = ProductItemRevision(position=0)
    productitem_tariffref_revision::ProductItemTariffRefRevision =
        ProductItemTariffRefRevision()
    productitem_partnerref_revision::ProductItemPartnerRefRevision =
        ProductItemPartnerRefRevision()
end

@kwdef mutable struct ContractSection
    tsdb_validfrom::TimeZones.ZonedDateTime = now(tz"UTC")
    tsw_validfrom::TimeZones.ZonedDateTime = now(tz"UTC")
    ref_history::SearchLight.DbId = DbId(InfinityKey)
    ref_version::SearchLight.DbId = MaxVersion
    contract_revision::ContractRevision = ContractRevision()
    contract_partnerref_revision::ContractPartnerRefRevision = ContractPartnerRefRevision()
    product_items::Vector{ProductItemSection} = []
    ref_entities::Dict{DbId,Union{PartnerSection,ContractSection,TariffSection}} =
        Dict{DbId,Union{PartnerSection,ContractSection,TariffSection}}()
end

function insurancecontracts_view()
    html(:insurancecontracts, :insurancecontracts, contracts=all(Contract))
end

function get_revision(
    ctype::Type{CT},
    rtype::Type{RT},
    hid::DbId,
    vid::DbId,
) where {CT<:Component,RT<:ComponentRevision}
    find(
        rtype,
        SQLWhereExpression(
            "ref_component=? and ref_valid  @> BIGINT ?",
            find(ctype, SQLWhereExpression("ref_history=?", hid))[1].id,
            vid,
        ),
    )[1]
end

function get_revisions(
    rtype::Type{RT},
    cid::DbId,
    vid::DbId,
) where {RT<:ComponentRevision}
    find(
        rtype,
        SQLWhereExpression(
            "ref_component=? and ref_valid  @> BIGINT ?",
            cid,
            vid
        ),
    )[1]
end


function pisection(history_id::Integer, version_id::Integer)::Vector{ProductItemSection}
    pis = find(ProductItem, SQLWhereExpression(
        "ref_history = BIGINT ? ", DbId(history_id)))

    map(pis) do pi
        pir = get_revisions(
            ProductItemRevision,
            pi.id,
            DbId(version_id),
        )
        pitr = get_revisions(
            ProductItemTariffRefRevision,
            pi.id,
            DbId(version_id),
        )
        pipr = get_revisions(
            ProductItemPartnerRefRevision,
            pi.id,
            DbId(version_id),
        )
        ProductItemSection(
            productitem_revision=pir,
            productitem_tariffref_revision=pitr,
            productitem_partnerref_revision=pipr
        )
    end

end

function csection(history_id::Integer, version_id::Integer)::ContractSection
    connect()
    ContractSection(
        ref_history=DbId(history_id),
        ref_version=DbId(version_id),
        contract_revision=get_revision(
            Contract,
            ContractRevision,
            DbId(history_id),
            DbId(version_id),
        ),
        contract_partnerref_revision=get_revision(
            ContractPartnerRef,
            ContractPartnerRefRevision,
            DbId(history_id),
            DbId(version_id),
        ),
        product_items=pisection(history_id, version_id),
        ref_entities=Dict{DbId,Union{PartnerSection,ContractSection,TariffSection}}(),
    )
end

function csectionDict(history_id::Integer, version_id::Integer)::Dict{String,Any}
    JSON.parse(JSON.json(csection(4, 4)), dicttype=Dict{String,Any})
end

function psection(history_id::Integer, version_id::Integer)::PartnerSection
    PartnerSection(
        partner_revision=get_revision(
            Partner,
            PartnerRevision,
            DbId(history_id),
            DbId(version_id),
        ),
    )
end

function tsection(history_id::Integer, version_id::Integer)::Tariffsection
    TariffSection(
        tariff_revision=get_revision(
            Tariff,
            TariffRevision,
            DbId(history_id),
            DbId(version_id),
        ),
    )
end

function csection_view(history_id::Int, version_id::Int)
    html(
        :insurancecontracts,
        :insurancecontract,
        csect=csection(history_id, version_id)
    )
end

function renderhistory(history_id::Int)
    renderhforest(
        mkforest(
            DbId(history_id),
            MaxDate,
            ZonedDateTime(1900, 1, 1, 0, 0, 0, 0, tz"UTC"),
            MaxDate,
        ),
        0,
    )
end

function renderhforest(f, i)
    Html.ul() do
        for_each(f) do node
            renderhnode(node, i + 1)
        end
    end
end

function renderhnode(node, i)
    Html.li() do
        """ Version $(string(node.interval.ref_version.value))
            <a href="csection?history_id=$(node.interval.ref_history.value)&version_id=$(node.interval.ref_version.value)">as of $(node.interval.tsworld_validfrom) created $(node.interval.tsdb_validfrom)</a>
        """ *
        if length(node.shadowed) > 0
            Html.span(class="caret") * Html.ul(class="nested") do
                renderhforest(node.shadowed, i + 1)
            end
        else
            ""
        end
    end

end

function historyforest_view(history_id::Int)
    html(
        :insurancecontracts,
        :historyforest,
        hforest=renderhistory(history_id),
        hid=history_id,
        entitytype="Contract",
    )
end

function get_contract_ids()
    connect()
    map(find(Contract)) do c
        c.id.value
    end
end

function connect()
    try
        SearchLight.connection()
    catch e
        SearchLight.Configuration.load() |> SearchLight.connect
    end
end

end #module