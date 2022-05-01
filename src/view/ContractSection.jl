module ContractSection
using Stipple, StippleUI

@reactive mutable struct Model <: ReactiveModel
    process::R{Bool} = false
    csect::R{Dict{Symbol,Any}} = Dict{Symbol,Any}(:contract_revision => 1)
end

function ui(model)
    page(
        model,
        class="container",
        list(
            bordered=true,
            separator=true,
            template([
                    item(itemsection(
                        itemlabel("Contract {{csect['contract_revision']['description']}}"
                        )
                    )),
                    item(itemsection(
                        list(
                            bordered=true,
                            separator=true,
                            template(
                                item(itemsection(
                                    """
                                    <p>
                                        Description
                                        <input v-model="csect['contract_revision']['description']" v-on:keyup.enter="process=true"/>
                                    </p>
                                    """))
                            )
                        )))],
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
            bubu=model.csect[:contract_revision]
            println(bubu)
            model.process[] = false
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

