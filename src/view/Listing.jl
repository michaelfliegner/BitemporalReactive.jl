module Listing
using InsuranceContractsController, Stipple, StippleUI
using SearchLight, InsuranceContracts

@reactive mutable struct Model <: ReactiveModel
    selected_history::R{Integer} = 0
    contracts::R{Vector{Integer}} = []
end


function ui(model)
    page(
        model,
        class="container", list(
            bordered=true,
            separator=true,
            template(
                item(
                    clickable=true,
                    vripple=true,
                    [
                        itemsection(
                            """<q-field outlined label="History ID" stack-label>
                                    <template v-slot:control>
                                        <div class="self-center no-outline" tabindex="0">{{id}}</div>
                                    </template>
                                </q-field>"""
                        )
                    ], @click("selected_history=id")
                ),
                @recur(:"(id,index) in contracts")
            )
        )
    )
end

function handlers(model)
    on(model.selected_history) do _
        println("huhuhuhu")
        println(model.selected_history[])
    end
    on(model.isready) do _
        push!(model)
    end
    model
end

function routeListing(model)

    route("/list") do
        html(ui(model), context=@__MODULE__)
    end

end

function run()
    model = handlers(Stipple.init(Model))
    model.contracts = InsuranceContractsController.get_contract_history_ids()
    routeListing(model)
    Stipple.up()
end

end #module

