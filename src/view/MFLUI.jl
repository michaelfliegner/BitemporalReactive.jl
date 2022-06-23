module MFLUI
using SearchLight, Stipple, Stipple.Html, StippleUI

using InsuranceContractsController, JSON, TimeZones

@reactive mutable struct Model <: ReactiveModel
  cs::Dict{String,Any} = Dict{String,Any}()
  tab::R{String} = ""
  show_contract_partners::R{Bool} = false
  show_product_items::R{Bool} = false
  show_tariff_item_partners::R{Bool} = false
  show_tariff_items::R{Bool} = false
  rolesContractPartner::R{Dict{Integer,String}} = Dict{Integer,String}()
  rolesTariffItem::R{Dict{Integer,String}} = Dict{Integer,String}()
  rolesTariffItemPartner::R{Dict{Integer,String}} = Dict{Integer,String}()
end

function load_roles(model)
  map(find(InsuranceContractsController.ContractPartnerRole)) do entry
    model.rolesContractPartner[entry.id.value] = entry.value
  end
  println(model.rolesContractPartner)


  map(find(InsuranceContractsController.TariffItemRole)) do entry
    model.rolesTariffItem[entry.id.value] = entry.value
  end

  map(find(InsuranceContractsController.TariffItemPartnerRole)) do entry
    model.rolesTariffItemPartner[entry.id.value] = entry.value
  end

end

function tariff_item_partners()
  card(class="my-card bg-deep-purple-8 text-white",
    [card_section([
        Html.div(class="text-h3 text-white", "Tariff Item Partners"),
      ]),
      """,
              <q-markup-table dark class="bg-deep-purple-5 text-white">
                  <template>
                    <thead>
                      <tr>
                        <th class="text-left text-white">Item</th>
                        <th class="text-left text-white">Role</th>
                        <th class="text-left text-white">Partner Id</th>
                      </tr>
                    </thead>
                  </template>
                  <template>
                    <tbody>
                      <template v-for="(tpid,tpindex) in cs['product_items'][pindex]['tariff_items'][tindex]['partner_refs']">
                      <tr>
                        <td class="text-left text-white">{{pindex}},{{tindex}},{{tpindex}}</td>
                        <td class="text-left text-white">{{rolesTariffItemPartner[tpid['rev']['ref_role']['value']]}}</td>
                        <td class="text-left text-white">{{tpid['rev']['ref_partner']['value']}}</td>
                      </tr>
                    </template>
                    </tbody>
                  </template>
                </q-markup-table>
      """,], var"v-if"="show_tariff_item_partners")
end

function tariff_items()
  card(class="my-card bg-indigo-8 text-white",
    [card_section([Html.div(class="text-h3 text-white", "Tariff Items"), btn("Show Tariff Item Partners", @click("show_tariff_item_partners=!show_tariff_item_partners"))
      ]),
      """,
              <q-markup-table dark class="bg-indigo-5 text-white">
                  <template>
                    <thead>
                      <tr>
                        <th class="text-left text-white">Item</th>
                        <th class="text-left text-white">Role</th>
                        <th class="text-left text-white">Tariff Id</th>
                      </tr>
                    </thead>
                  </template>
                  <template>
                    <tbody>
                      <template v-for="(tid,tindex) in cs['product_items'][pindex]['tariff_items']">
                      <tr>
                         <td class="text-left text-white">{{pindex}},{{tindex}}</td>
                        <td class="text-left text-white"> {{rolesTariffItem[tid['tariff_ref']['rev']['ref_role']['value']]}}</td>
                        <td class="text-left text-white"> {{cs.product_items[pindex]['tariff_items'][tindex]['tariff_ref']['rev']['ref_tariff']['value']}}</td>
                      </tr>
      """,
      tariff_item_partners(),
      """
                </template>
                </tbody>
              </template>
            </q-markup-table>
  """,], var"v-if"="show_tariff_items")
end

function product_items()
  card(class="my-card bg-purple-8 text-white",
    [card_section([Html.div(class="text-h2 text-white", "Product Items"), btn("Show Tariff Items", @click("show_tariff_items=!show_tariff_items"))
      ]),
      """
        <q-markup-table class="dark bg-purple-5 text-white">
          <template>
            <thead>
              <tr>
                <th class="text-left text-white">Item</th>
                <th class="text-left text-white">Description</th>
              </tr>
            </thead>
          </template>
          <template>
            <tbody>
              <template v-for="(pid,pindex) in cs['product_items']">
            <tr>
              <td class="text-left text-white">{{pindex}}</td>
              <td class="text-left text-white">{{cs['product_items'][pindex]['revision']['description']}}</td>
      """,
      tariff_items(),
      """
              </tr>
            </template>
            </tbody>
          </template>
        </q-markup-table>
  """], var"v-if"="show_product_items")
end

function contract_partners()
  card(class="my-card bg-deep-purple-8 text-white",
    [card_section([
        Html.div(class="text-h3 text-white", "Contract Partners"),
      ]),
      """,
              <q-markup-table dark class="bg-deep-purple-5 text-white">
                  <template>
                    <thead>
                      <tr>
                        <th class="text-left text-white">Index</th>
                        <th class="text-left text-white">Role</th>
                        <th class="text-left text-white">Partner Id</th>
                      </tr>
                    </thead>
                  </template>
                  <template>
                    <tbody>
                      <template v-for="(cpid,cpindex) in cs['partner_refs']">
                      <tr>
                        <td class="text-left text-white">{{cpindex}}</td>
                        <td class="text-left text-white">{{rolesContractPartner[cpid['rev']['ref_role']['value']]}}</td>
                        <td class="text-left text-white">{{cpid['rev']['ref_partner']['value']}}</td>
                      </tr>
                    </template>
                    </tbody>
                  </template>
                </q-markup-table>
      """,], var"v-if"="show_contract_partners")
end
function contract()
  card(class="my-card bg-purple-8 text-white",
    [card_section([Html.div(class="text-h2 text-white", "Product ItemsContract"),
        btn("Show Contract Partners", @click("show_contract_partners=!show_contract_partners")),
        btn("Show Product Items", @click("show_product_items=!show_product_items"))
      ]),
      contract_partners(),
      product_items(),
    ])
end

function ui(model)
  page(
    model,
    title="Bitemporal Reactive ContractSection",
    Html.div(id="q-app", style="min-height: 100vh;",
      Html.div(class="q-pa-md",
        contract(),
      ))
  )
end

function handlers(model)
  on(model.tab) do _
    println(model.tab[])
  end

  on(model.isready) do _
    println("ready")
    model.tab[] = "csection"
    model.cs = JSON.parse(JSON.json(csection(1, now(tz"Europe/Warsaw"), now(tz"Europe/Warsaw"))))
    load_roles(model)
    push!(model)
    println("model pushed")
  end
  model
end

function routeTree(model)
  route("/MFLUI") do
    html(ui(model), context=@__MODULE__)
  end
end

function run()
  model = handlers(Stipple.init(Model))
  routeTree(model)
  Stipple.up()
end

end