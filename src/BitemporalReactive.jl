module BitemporalReactive
import SearchLight
using JSON, Stipple, StippleUI
push!(LOAD_PATH, "src/model")
push!(LOAD_PATH, "src/view")
import InsuranceContractsController
using InsuranceContractsController
import ContractSection
using ContractSection

modelData = Dict{String,Any}("tsdb_validfrom" => "2022-05-08T17:43:49.077+00:00", "ref_history" => Dict{String,Any}("value" => 4), "ref_entities" => Dict{String,Any}(), "contract_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 5), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "blue"), "contract_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue"), "ref_version" => Dict{String,Any}("value" => 4), "tsw_validfrom" => "2022-05-08T17:43:49.077+00:00", "product_items" => Any[Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "position" => 1, "description" => "blue"), "productitem_tariffref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue", "ref_tariff" => Dict{String,Any}("value" => 1)), "productitem_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue")), Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "position" => 2, "description" => "pink"), "productitem_tariffref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 2), "description" => "pink", "ref_tariff" => Dict{String,Any}("value" => 2)), "productitem_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 1), "description" => "pink"))])
newItem = Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "ref_role" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => nothing), "position" => 0, "description" => ""), "productitem_tariffref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => "", "ref_tariff" => Dict{String,Any}("value" => nothing)), "productitem_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => nothing), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => ""))

function handlers(model::ContractSection.Model)
    on(model.tab) do _
        println("tab = " * model.tab[])
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
        println(model.csect["contract_partnerref_revision"]["ref_role"])
        push!(model)
    end
    model
end

model = handlers(Stipple.init(ContractSection.Model))
SearchLight.Configuration.load() |> SearchLight.connect
csectDict = JSON.parse(JSON.json(InsuranceContractsController.csection(4, 4)), dicttype=Dict{String,Any})
model.csect = csectDict
println("init")
println(model)

ContractSection.startup(model)

end