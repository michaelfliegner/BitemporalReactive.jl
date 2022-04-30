module ContractSection
using Stipple, StippleUI

@reactive mutable struct Model <: ReactiveModel
    process::R{Bool} = false
    csect::R{Dict{Symbol,Any}} = Dict{Symbol,Any}(:dummy => 1)
end

function ui(model)
    page(
        model,
        class="container",
        list(
            bordered=true,
            separator=true,
            template([
                item(
                    [
                        itemsection(
                            itemlabel("""
                            val key {{key}}
                            """
                            )
                        )
                    ]
                ),
                item(
                    clickable=true,
                    [
                        itemsection(
                            list(
                                bordered=true,
                                separator=true,
                                template(
                                    item(
                                        clickable=true,
                                        [
                                            itemsection(
                                                p("""
                                                val key {{key}} = {{val}} 
                                                """
                                                )
                                            )
                                        ], @click("process=true")
                                    ),
                                    @recur(:"(val,key) in csect[key]")
                                )
                            ))
                    ], @click("process=true")
                )],
                @recur(:"(val,key) in csect"),
                """v-if ="key=='contract_revision'"
                """
            )
        )
    )
end

function handlers(model)
    on(model.process) do _
        if (model.process[])
            println("huhuhuhu")
            println(model.csection[:ref_history])
            model.process[] = false
        end
    end
    on(model.isready) do _
        println("pushing")
        println(model.csect)
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

