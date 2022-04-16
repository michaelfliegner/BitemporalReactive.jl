module BitemporalReactive
using SearchLight, Stipple

push!(LOAD_PATH,"src/model")
include("model/InsuranceContracts.jl")
using .InsuranceContracts

SearchLight.Configuration.load() |> SearchLight.connect
contracts=find(Contract)


include("view/Listing.jl")
using .Listing

model = Listing.handlers(Stipple.init(Listing.Model))
for c in contracts
    push!(model.contracts[], c.id.value)
end

model.contracts=(map(c->c.id.value, contracts))

Listing.routeListing(model)



Stipple.up()

end