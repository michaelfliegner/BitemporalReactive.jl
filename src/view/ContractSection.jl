module ContractSection
using InsuranceContractsController, JSON, Stipple, StippleUI

@reactive mutable struct Model <: ReactiveModel
    modContractRevision::R{Bool} = false
    modContractPartnerRefRevision::R{Bool} = false
    modProductitemRevision::R{Bool} = false
    addProductItem::R{Bool} = false
    csect::R{Dict{String,Any}} = Dict{String,Any}("contract_revision" => 1)
end

function ui(model)
    page(
        model,
        class="container",
        Genie.Renderer.Html.div(class="q-pa-md bg-grey-10 text-white",
            list(dark=true, bordered=true, separator=true, style="max-width: 318px",
                [item(vripple=true,
                        item_section([
                            item_label(overline=true, "Contract"),
                            item_label(overline=true, "Description"),
                            """ <input v-model="csect['contract_revision']['description']" v-on:keyup.enter="modContractRevision=true"/> """,
                            item_label(overline=true, "Policy Holder description"),
                            """ <input v-model="csect['contract_partnerref_revision']['description']" v-on:keyup.enter="modContractPartnerRefRevision=true"/> """,
                            item_label(overline=true, "Policy Holder id"),
                            """ <input v-model="csect['contract_partnerref_revision']['partner_ref']" v-on:keyup.enter="modContractPartnerRefRevision=true"/> """,
                        ])),
                    p(btn("add item", class="bg-grey-5", icon="add", @click("addProductItem=true"))),
                    list(template(
                        item(
                            clickable=true,
                            vripple=true, itemsection([
                                itemlabel("Product item {{index}}", overline=true),
                                itemlabel("Description"),
                                """
                                <input v-model="csect['product_items'][index]['productitem_revision']['description']" v-on:keyup.enter="modProductitemRevision=true"/>      
                                """,
                                itemlabel("Tariff"),
                                """
                                <input v-model="csect['product_items'][index]['productitem_revision']['ref_tariff']" v-on:keyup.enter="modProductitemRevision=true"/>      
                                """,
                                itemlabel("Insured Person id"),
                                """
                                <input v-model="csect['product_items'][index]['productitem_revision']['ref_partner']" v-on:keyup.enter="modProductitemRevision=true"/>      
                                """],
                            )),
                        """
                        v-for="(item,index) in csect['product_items']"
                        """)
                    ),
                ])
        )
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

