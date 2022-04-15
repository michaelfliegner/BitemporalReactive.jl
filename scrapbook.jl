ENV["GENIE_ENV"] = "dev"
push!(LOAD_PATH, "src")
using Pkg
Pkg.add("Revise")
using Revise
run(```sudo -u postgres psql -f sqlsnippets/droptables.sql```)
include("test/testsCreateContract.jl")
