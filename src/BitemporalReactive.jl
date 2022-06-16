module BitemporalReactive
using BitemporalPostgres, SearchLight, Stipple, StippleUI, TimeZones
include("model/InsuranceContractsController.jl")
using .InsuranceContractsController
include("view/ContractSection.jl")
using .ContractSection

# TreeDict = Dict{String,Any}[Dict("label" => "7", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 4, "id" => 7, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 6), "time_committed" => "2022-05-21T17:49:58.742+00:00", "time_valid_asof" => "2015-05-30T20:00:01.001+00:00", "children" => Dict{String,Any}[Dict("label" => "5", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2016, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 506, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "ref_history" => 4, "id" => 5, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 5), "time_committed" => "2022-05-21T17:49:58.506+00:00", "time_valid_asof" => "2016-05-30T20:00:01.001+00:00", "children" => Any[])]), Dict("label" => "8", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2014, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 4, "id" => 8, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "is_committed" => 1, "ref_version" => 4), "time_committed" => "2022-05-21T17:49:58.742+00:00", "time_valid_asof" => "2014-05-30T20:00:01.001+00:00", "children" => Any[])]
newItem = Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "ref_role" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => nothing), "position" => 0, "description" => ""), "productitem_tariffref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => "", "ref_tariff" => Dict{String,Any}("value" => nothing)), "productitem_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => nothing), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => ""))

function handlers(model::ContractSection.Model)
    on(model.process) do
        println("process event")
        model.process[] = false
    end
    on(model.selected_contract) do _
        model.selected_history[] = model.selected_contract["ref_history"]["value"]
    end

    on(model.selected_history) do _
        println("huhuhuhu")
        println(model.selected_history[])
        println("seleected h")
        model.history = map(convert, InsuranceContractsController.history_forest(model.selected_history[]).shadowed)
        println("history read")
        model.tab = "history"
        println(model.history)
        println("vor push")
        push!(model)
        println("nach push")
    end

    on(model.tab) do _
        println("tab = " * model.tab[])
        if (model.tab[] == "history")
            println("History=" * string(model.history))
        end
    end
    on(model.selected_version) do _
        if (model.selected_version[] != "")
            println("selected_version= " * model.selected_version[])
            model.current_version[] = parse(Int, model.selected_version[])
            println("current=" * string(model.current_version[]))
            model.selected_version[] = ""
            try
                println("vor csect")
                model.csect = InsuranceContractsController.csection_dict(model.selected_history[], model.current_version[])
            catch e
                println("csect schiefgegangen " * string(e))
            end
            println("nach csect")
            model.tab = "csection"
            push!(model)
        end
    end

    on(model.leftDrawerOpen) do _
        if (model.leftDrawerOpen[])
            println("Drawer is open ")
        else
            println("Drawer is closed ")
        end
    end
    on(model.modContractRevision) do _
        if (model.modContractRevision[])
            println("mod contract")
            println(model.csect["contract_revision"])
            model.modContractRevision[] = false
        end
    end
    on(model.modContractPartnerRefRevision) do _
        if (model.modContractPartnerRefRevision[])
            println("mod contractpartnerref")
            println(model.csect["contract_partnerref_revision"])
            model.modContractPartnerRefRevision[] = false
        end
    end

    on(model.modProductitemRevision) do _
        if (model.modProductitemRevision[])
            println("mod Productitem")
            model.modProductitemRevision[] = false
        end
    end
    on(model.addProductItem) do _
        println("on add pi2")
        if (model.addProductItem[])
            println("add pi2")
            println("newItem ")
            println(newItem)
            currentItems = model.csect["product_items"]
            println("curritems")
            println(currentItems)
            newItems = [currentItems; newItem]
            println("newItems")
            println(newItems)
            model.csect["product_items"] = newItems
            println("f'ddich")
            model.addProductItem[] = false
            push!(model)
        end
    end

    on(model.isready) do _
        println("pushing")
        push!(model)

        println("pushed")
    end
    model
end

function convert(node::BitemporalPostgres.Node)::Dict{String,Any}
    i = Dict(string(fn) => getfield(getfield(node, :interval), fn) for fn ∈ fieldnames(ValidityInterval))
    shdw = length(node.shadowed) == 0 ? [] : map(node.shadowed) do child
        convert(child)
    end
    Dict("label" => string(i["ref_version"]), "interval" => i, "children" => shdw,
        "time_committed" => string(i["tsdb_validfrom"]), "time_valid_asof" => string(i["tsworld_validfrom"]))
end

function convert(ContractSection::cs)::Dict{String,Any}
    cs = Dict(string(fn) => getfield(getfield(cs, :interval), fn) for fn ∈ fieldnames(typeog(cs)))
end

function run()
    println("init1")
    model = handlers(Stipple.init(ContractSection.Model))
    println("von contracts init")
    model.contracts = InsuranceContractsController.get_contract_history_ids()
    # model.history = map(convert, InsuranceContractsController.history_forest(selected_history[]).shadowed)
    # println("init2" * string(model.history[1]["label"]))
    println(model.contracts)
    println(model)
    ContractSection.startup(model)
end

end