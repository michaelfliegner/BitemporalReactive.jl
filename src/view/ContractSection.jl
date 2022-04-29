module ContractSection
using Stipple, StippleUI

@reactive mutable struct Model <: ReactiveModel
    process:: R{Bool} = false
    csect :: R{Dict{Symbol,Any}} = Dict{Symbol,Any}(:dummy => 1)
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
                        itemsection(
                            p("""
                            key {{index}} = {{sym}} {{index =='contract_revision'}}
                            """
                            )                             
                        )

                        list(
                            bordered=true,
                            separator=true,
                            template(
                                item(
                                    clickable=true,
                                    vripple=true,
                                    [
                                        itemsection(
                                            p("""
                                            key {{index}} = {{sym}} 
                                            """
                                            )                             
                                        )
                                    ], @click("process=true")
                                ),
                                @recur(:"(sym,index) in csect[index]")
                            )
                        )
                    ], @click("process=true")
                ),
                @recur(:"(sym,index) in csect"),
                """v-if ="index=='contract_revision'"
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

