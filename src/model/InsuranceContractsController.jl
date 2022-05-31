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
export convert,
    Contract,
    ContractRevision,
    ContractPartnerRole,
    ContractPartnerRef,
    ContractPartnerRefRevision,
    csection_dict,
    history_dict,
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

function csection_dict(history_id::Integer, version_id::Integer)::Dict{String,Any}
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

function history_forest(history_id::Int)
    connect()
    BitemporalPostgres.Node(ValidityInterval(), mkforest(DbId(history_id),
        MaxDate,
        ZonedDateTime(1900, 1, 1, 0, 0, 0, 0, tz"UTC"),
        MaxDate,
    ))
end

function convert(node::BitemporalPostgres.Node)::Dict{String,Any}
    i = Dict(string(fn) => getfield(getfield(node, :interval), fn) for fn ∈ fieldnames(ValidityInterval))
    shdw = length(node.shadowed) == 0 ? [] : map(node.shadowed) do child
        convert(child)
    end
    Dict("label" => string(i["id"]), "interval" => i, "children" => shdw,
        "time_committed" => string(i["tsdb_validfrom"]), "time_valid_asof" => string(i["tsworld_validfrom"]))
end

function history_dict(history_id::Int)::Dict{String,Any}
    convert(history_forest(history_id))
end

function mkhdict(
    hid::DbId,
    tsdb_invalidfrom::ZonedDateTime,
    tsworld_validfrom::ZonedDateTime,
    tsworld_invalidfrom::ZonedDateTime,
)
    map(
        i::ValidityInterval -> Dict{String,Any}(
            "interval" => i,
            "shadowed" => Vector{Dict{String,Any}}(mkforest(hid, i.tsdb_validfrom, i.tsworld_validfrom, i.tsworld_invalidfrom),)
        ),
        find(
            ValidityInterval,
            SQLWhereExpression(
                "ref_history=? AND  upper(tsrdb)=? AND tstzrange(?,?) * tsrworld = tsrworld",
                hid,
                tsdb_invalidfrom,
                tsworld_validfrom,
                tsworld_invalidfrom,
            ),
        ),
    )
end

function renderhistory(history_id::Int)
    renderhforest(BitemporalPostgres.Node(Nothing,
            mkforest(
                DbId(history_id),
                MaxDate,
                ZonedDateTime(1900, 1, 1, 0, 0, 0, 0, tz"UTC"),
                MaxDate,
            )),
        0,
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