module ContractSection
using Stipple, StippleUI

@reactive mutable struct Model <: ReactiveModel
    modContractRevision::R{Bool} = false
    modProductitemRevision::R{Bool} = false
    addProductItem::R{Bool} = false
    csect::R{Dict{Symbol,Any}} = Dict{Symbol,Any}(:contract_revision => 1)
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
                <p><q-btn color="primary" icon="mail" label="On Left" @click="addProductItem=true" /></p>
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
            println(model.csect[:contract_revision])
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
            newItem = Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 5), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "blue898")
            currentItems = model.csect[:productitem_revision]
            newItems = append!(currentItems, newItem)
            println(currentItems)
            println("newItems")
            println(newItems)
            model.csect[:productitem_revision] = newItems
            println("neue pis")
            println(model.csect[:productitem_revision])
            println("f'ddich")
            model.addProductItem[] = false
            push!(model)
        end
    end

    on(model.isready) do _
        println("pushing")
        println(model.csect[:contract_revision])
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

