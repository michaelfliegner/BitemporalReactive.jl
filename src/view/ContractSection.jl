module ContractSection
using InsuranceContractsController, JSON, Stipple, StippleUI

@reactive mutable struct Model <: ReactiveModel
    modContractRevision::R{Bool} = false
    modProductitemRevision::R{Bool} = false
    addProductItem::R{Bool} = false
    csect::R{Dict{String,Any}} = Dict{String,Any}("contract_revision" => 1)
end

function ui(model)
    page(
        model,
        class="container",
        """
            <div class="q-pa-md bg-grey-10 text-white">
                <q-list dark bordered separator style="max-width: 318px">
                  <q-item v-ripple>
                    <q-item-section>
                      <q-item-label overline>Contract</q-item-label>
                      <q-item-label>Description</q-item-label>
                      <input v-model="csect['contract_revision']['description']" v-on:keyup.enter="modContractRevision=true"/>
                    </q-item-section>
                  </q-item>
                </q-list>
                <p><q-btn bg-grey-5 icon="add" label="add item" @click="addProductItem=true" /></p>
                <div v-for="(item,index) in csect['product_items']">
                    <q-list dark bordered separator style="max-width: 318px">
                        <q-item v-ripple>
                            <q-item-section>
                                <q-item-label overline>Product item {{index}} </q-item-label>
                                <q-item-label>Description</q-item-label>
                                <input v-model="csect['product_items'][index]['productitem_revision']['description']" v-on:keyup.enter="modProductitemRevision=true"/>
                                <q-item-label>Tariff</q-item-label>
                                <input v-model="csect['product_items'][index]['productitem_tariffref_revision']['ref_tariff']['value']" v-on:keyup.enter="modProductitemRevision=true"/>
                                <q-item-label>Partner</q-item-label>
                                <input v-model="csect['product_items'][index]['productitem_partnerref_revision']['ref_partner']['value']" v-on:keyup.enter="modProductitemRevision=true"/>
                          </q-item-section>
                    </q-list>
                <div>
            </div>
            """
    )

end

function handlers(model)
    on(model.modContractRevision) do _
        if (model.modContractRevision[])
            println("mod contract")
            println(model.csect["contract_revision"])
            model.modContractRevision[] = false
        end
    end
    on(model.modProductitemRevision) do _
        if (model.modProductitemRevision[])
            println("mod Productitem")
            model.modProductitemRevision[] = false
        end
    end
    on(model.addProductItem) do _
        if (model.addProductItem[])
            println("add pi2")
            newItem = JSON.parse(JSON.json(ProductItemSection()), dicttype=Dict{String,Any})
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
        println(model.csect["contract_revision"])
        push!(model)
    end
    model
end

function routeContractSection(model)
    route("/csection") do
        html(ui(model), context=@__MODULE__)
    end
end

end #module

