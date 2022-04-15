module Bubu

using Stipple, StippleUI

@reactive mutable struct Model <: ReactiveModel
    process::R{Bool} = false
end

function ui(model)
    page(
        model,
        class = "container",
        list(
            bordered = true,
            separator = true,
            [
                item(clickable = true, vripple = true, [itemsection("Single line item")]),
                item(
                    clickable = true,
                    vripple = true,
                    [
                        itemsection([
                            itemlabel("Item with caption"),
                            itemlabel("Caption", caption = true),
                        ]),
                    ],
                ),
                item(
                    clickable = true,
                    vripple = true,
                    [
                        itemsection([
                            itemlabel("OVERLINE", overline = true),
                            itemlabel("Item with caption"),
                        ]),
                    ],
                ),
            ],
        ),
    )
end

function handlers(model)
    on(model.process) do _
        if (model.process[])
            println("huhuhuhu")
            model.process[] = false
        end
    end
    on(model.isready) do _
        push!(model)
    end
    model
end


model = handlers(Stipple.init(Model))

route("/list") do
    html(ui(model), context = @__MODULE__)
end

isrunning(:webserver) || up
end
