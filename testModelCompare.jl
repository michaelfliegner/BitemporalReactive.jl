#loading packages
push!(LOAD_PATH, "src")
using BitemporalPostgres, BitemporalReactive, JSON, LifeInsuranceDataModel, SearchLight, Test, TimeZones, ToStruct

#run(```sudo -u postgres service postgresql stop```)
#run(```sudo -u postgres service postgresql start```)

model0 = JSON.parse(JSON.json(csection(1, now(tz"UTC"), now(tz"UTC"))))
model1 = JSON.parse(JSON.json(csection(1, now(tz"UTC"), now(tz"UTC"))))


model1["revision"]["id"]["value"] = nothing
model1["revision"]["description"] = "CR first mutation by GUI model"
model1["partner_refs"][1]["rev"]["description"] = "CPR first mutation by GUI model"
model1["product_items"][1]["revision"]["description"] = "PIR first mutation by GUI model"
model1["product_items"][1]["tariff_items"][1]["tariff_ref"]["rev"]["deferment"] = 9
model1["product_items"][1]["tariff_items"][1]["tariff_ref"]["rev"]["description"] = "TIR first mutation by GUI model"
model1["product_items"][1]["tariff_items"][1]["partner_refs"][1]["rev"]["description"] = "bubu|"

BitemporalReactive.compareModelStateContract(model0, model1)

changed = ToStruct.tostruct(ContractSection, model1)
@test(changed.revision.description == "CR first mutation by GUI model")
@test(changed.partner_refs[1].rev.description == "CPR first mutation by GUI model")
@test(changed.product_items[1].revision.description == "PIR first mutation by GUI model")
@test(changed.product_items[1].tariff_items[1].tariff_ref.rev.deferment == 9)
@test(changed.product_items[1].tariff_items[1].tariff_ref.rev.description == "TIR first mutation by GUI model")
@test(changed.product_items[1].tariff_items[1].partner_refs[1].rev.description == "bubu|")
