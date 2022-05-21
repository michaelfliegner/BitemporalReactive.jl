push!(LOAD_PATH, "src")
push!(LOAD_PATH, "src/model")
import Base: @kwdef
using Test
include("src/model/InsuranceContractsController.jl")
using .InsuranceContractsController
using BitemporalPostgres
using SearchLight
using SearchLightPostgreSQL
using TimeZones
using ToStruct
using JSON
using HTTP

if (haskey(ENV, "GENIE_ENV") && ENV["GENIE_ENV"] == "dev")
    run(```sudo -u postgres psql -f ../sqlsnippets/droptables.sql```)
end

@testset "CreateContract" begin

    SearchLight.Configuration.load() |> SearchLight.connect
    SearchLight.Migrations.create_migrations_table()
    SearchLight.Migrations.up()

    contractpartnerroles = map(["Policy Holder" "Premium Payer"]) do val
        save!(ContractPartnerRole(value=val))
    end
    productitempartnerroles = map(["Insured Person" "2nd Insured Person"]) do val
        save!(ProductItemPartnerRole(value=val))
    end
    productitemtariffroles = map(["Main Coverage - Life" "Supplementary Coverage - Occupational Disablity"]) do val
        save!(ProductItemTariffRole(value=val))
    end

    cpRole = Dict{String,Int64}()
    map(find(InsuranceContractsController.ContractPartnerRole)) do entry
        cpRole[entry.value] = entry.id.value
    end
    piprRole = Dict{String,Int64}()
    map(find(InsuranceContractsController.ProductItemPartnerRole)) do entry
        piprRole[entry.value] = entry.id.value
    end
    pitrRole = Dict{String,Int64}()
    map(find(InsuranceContractsController.ProductItemTariffRole)) do entry
        pitrRole[entry.value] = entry.id.value
    end

    # create Partner
    p = InsuranceContractsController.Partner()
    pr = InsuranceContractsController.PartnerRevision(description="blue")
    w = Workflow(
        tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"Africa/Porto-Novo"),
    )
    create_entity!(w)
    create_component!(p, pr, w)
    commit_workflow!(w)

    # create Tariffs
    t = InsuranceContractsController.Tariff()
    tr = InsuranceContractsController.TariffRevision(description="blue")
    w0 = Workflow(
        tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"Africa/Porto-Novo"),
    )
    create_entity!(w0)
    create_component!(t, tr, w0)
    commit_workflow!(w0)

    t2 = Tariff()
    tr = TariffRevision(description="blue")
    w0 = Workflow(
        tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"Africa/Porto-Novo"),
    )
    create_entity!(w0)
    create_component!(t2, tr, w0)
    commit_workflow!(w0)

    # create Contract
    c = Contract()
    cr = ContractRevision(description="blue")
    cpr = ContractPartnerRef(ref_super=c.id)
    cprr = ContractPartnerRefRevision(ref_partner=p.id, ref_role=cpRole["Policy Holder"], description="blue")

    cpi = ProductItem(ref_super=c.id)
    cpir = ProductItemRevision(position=1, description="blue")

    pitr = ProductItemTariffRef(ref_super=cpi.id)
    pitrr = ProductItemTariffRefRevision(ref_tariff=t.id, ref_role=pitrRole["Main Coverage - Life"], description="blue")
    pipr = ProductItemPartnerRef(ref_super=cpi.id)
    piprr = ProductItemPartnerRefRevision(ref_partner=p.id, ref_role=piprRole["Insured Person"], description="blue")

    cpi2 = ProductItem(ref_super=c.id)
    cpi2r = ProductItemRevision(position=2, description="pink")
    pi2tr = ProductItemTariffRef(ref_super=cpi2.id)
    pi2trr = ProductItemTariffRefRevision(ref_tariff=t2.id, ref_role=pitrRole["Supplementary Coverage - Occupational Disablity"], description="pink")
    pi2pr = ProductItemPartnerRef(ref_super=cpi.id)
    pi2prr = ProductItemPartnerRefRevision(ref_partner=p.id, ref_role=piprRole["Insured Person"], description="pink")

    w1 = Workflow(
        tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"Africa/Porto-Novo"),
    )
    create_entity!(w1)
    create_component!(c, cr, w1)
    create_subcomponent!(c, cpr, cprr, w1)

    create_subcomponent!(c, cpi, cpir, w1)
    create_subcomponent!(cpi, pitr, pitrr, w1)
    create_subcomponent!(cpi, pipr, piprr, w1)

    create_subcomponent!(c, cpi2, cpi2r, w1)
    create_subcomponent!(cpi2, pi2tr, pi2trr, w1)
    create_subcomponent!(cpi2, pi2pr, pi2prr, w1)
    commit_workflow!(w1)

    # end

    # update Contract yellow
    # @testset "UpdateContractYellow" begin

    cr1 = ContractRevision(ref_component=c.id, description="yellow")
    w2 = Workflow(
        ref_history=w1.ref_history,
        tsw_validfrom=ZonedDateTime(2016, 5, 30, 21, 0, 1, 1, tz"Africa/Porto-Novo"),
    )
    update_entity!(w2)
    update_component!(cr, cr1, w2)
    commit_workflow!(w2)
    @test w2.ref_history == w1.ref_history

    # nd

    # update Contract red
    # @testset "UpdateContractRed" begin
    cr2 = ContractRevision(ref_component=c.id, description="red")
    w3 = Workflow(
        ref_history=w2.ref_history,
        tsw_validfrom=ZonedDateTime(2015, 5, 30, 21, 0, 1, 1, tz"Africa/Porto-Novo"),
    )
    update_entity!(w3)
    update_component!(cr1, cr2, w3)
    commit_workflow!(w3)
    @test w3.ref_history == w2.ref_history

    # end of mutations
end

hforest = mkforest(DbId(3), MaxDate, ZonedDateTime(1900, 1, 1, 0, 0, 0, 0, tz"UTC"), MaxDate)
print_tree(hforest)

