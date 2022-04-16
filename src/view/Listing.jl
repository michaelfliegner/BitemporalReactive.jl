module Listing

push!(LOAD_PATH, "src")
using Stipple, StippleUI
using SearchLight, InsuranceContracts

@reactive mutable struct Model <: ReactiveModel
    process::R{Bool} = false
    contracts::R{Vector{Integer}} = []
end

function ui(model)
    page(
        model,
        class="container",
        list(
            bordered=true,
            separator=true,
            template(
                item(
                    clickable=true,
                    vripple=true,
                    [
                        itemsection([
                            itemlabel("Item with caption ({{index}}) id={{id}}"),
                            itemlabel("Caption", caption=true),
                        ]),
                    ], @click("process=true")
                ), @recur(:"(id,index) in contracts")
            ),
        )
    )
end

function handlers(model)
    on(model.process) do _
        if (model.process[])
            println("huhuhuhu")
            println(model.contracts)
            model.contracts[] = [ model.contracts[]; [77]]

            model.process[] = false
        end
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


end

