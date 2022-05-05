module BitemporalReactive
b
println(LOAD_PATH)
using JSON, SearchLight, Stipple
include("model/InsuranceContracts.jl")
include("model/InsuranceContractsController.jl")
include("view/ContractSection.jl")
include("view/Listing.jl")

SearchLight.Configuration.load() |> SearchLight.connect


function initContractSection()
    model::ContractSection.Model = ContractSection.handlers(Stipple.init(ContractSection.Model))
    csectDict = JSON.parse(JSON.json(InsuranceContractsController.csection(4, 4)), dicttype=Dict{String,Any})
    model.csect = csectDict
    println("init")
    println(model)
    ContractSection.routeContractSection(model)
end

function initListing()
    contracts = find(InsuranceContracts.Contract)
    model = Listing.handlers(Stipple.init(Listing.Model))
    for c in contracts
        push!(model.contracts[], c.id.value)
    end

    model.contracts = (map(c -> c.id.value, contracts))

    Listing.routeListing(model)
end

initContractSection()
# initListing()

Stipple.up()

end