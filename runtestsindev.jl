ENV["GENIE_ENV"] = "dev"
using Pkg
Pkg.add("Revise")
using Revise
run(```sudo service postgresql start```)
run(```sudo -u postgres psql -f sqlsnippets/droptables.sql```)
include("testsCreateContract.jl")