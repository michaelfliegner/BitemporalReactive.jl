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
    ContractPartnerRef,
    ContractPartnerRefRevision,
    ProductItem,
    ProductItemRevision,
    ProductItemTariffRef,
    ProductItemTariffRefRevision,
    ProductItemPartnerRef,
    ProductItemPartnerRefRevision
include("InsurancePartners.jl")
using .InsurancePartners
export Partner, PartnerRevision
include("InsuranceTariffs.jl")
using .InsuranceTariffs
export Tariff, TariffRevision
export ContractSection, PartnerSection, TariffSection, csection, tsection, psection
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

@kwdef mutable struct ContractSection
    tsdb_validfrom::TimeZones.ZonedDateTime = now(tz"UTC")
    tsw_validfrom::TimeZones.ZonedDateTime = now(tz"UTC")
    ref_history::SearchLight.DbId = DbId(InfinityKey)
    ref_version::SearchLight.DbId = MaxVersion
    contract_revision::ContractRevision = ContractRevision()
    contract_partnerref_revision::ContractPartnerRefRevision = ContractPartnerRefRevision()
    productitem_revision::ProductItemRevision = ProductItemRevision(position = 0)
    productitem_tariffref_revision::ProductItemTariffRefRevision =
        ProductItemTariffRefRevision()
    productitem_partnerref_revision::ProductItemPartnerRefRevision =
        ProductItemPartnerRefRevision()
    ref_entities::Dict{DbId,Union{PartnerSection,ContractSection,TariffSection}} =
        Dict{DbId,Union{PartnerSection,ContractSection,TariffSection}}()
end


function csection()
    psection = PartnerSection()
    ContractSection(ref_entities = (Dict(DbId(1) => psection)))
end

function insurancecontracts_view()
    html(:insurancecontracts, :insurancecontracts, contracts = all(Contract))
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
            Html.span(class = "caret") * Html.ul(class = "nested") do
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
        hforest = renderhistory(history_id),
        hid = history_id,
        entitytype = "Contract",
    )
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

function csection(history_id::Integer, version_id::Integer)::ContractSection
    ContractSection(
        ref_history = DbId(history_id),
        ref_version = DbId(version_id),
        contract_revision = get_revision(
            Contract,
            ContractRevision,
            DbId(history_id),
            DbId(version_id),
        ),
        contract_partnerref_revision = get_revision(
            ContractPartnerRef,
            ContractPartnerRefRevision,
            DbId(history_id),
            DbId(version_id),
        ),
        productitem_revision = get_revision(
            ProductItem,
            ProductItemRevision,
            DbId(history_id),
            DbId(version_id),
        ),
        productitem_tariffref_revision = get_revision(
            ProductItemTariffRef,
            ProductItemTariffRefRevision,
            DbId(history_id),
            DbId(version_id),
        ),
        productitem_partnerref_revision = get_revision(
            ProductItemPartnerRef,
            ProductItemPartnerRefRevision,
            DbId(history_id),
            DbId(version_id),
        ),
        ref_entities = Dict{DbId,Union{PartnerSection,ContractSection,TariffSection}}(),
    )
end

function psection(history_id::Integer, version_id::Integer)::PartnerSection
    PartnerSection(
        partner_revision = get_revision(
            Partner,
            PartnerRevision,
            DbId(history_id),
            DbId(version_id),
        ),
    )
end

function tsection(history_id::Integer, version_id::Integer)::Tariffsection
    TariffSection(
        tariff_revision = get_revision(
            Tariff,
            TariffRevision,
            DbId(history_id),
            DbId(version_id),
        ),
    )
end

function csection_view(history_id::Int,version_id::Int)
    html(
        :insurancecontracts,
        :insurancecontract,
        csect = csection(history_id,version_id)
    )
end

end #module

