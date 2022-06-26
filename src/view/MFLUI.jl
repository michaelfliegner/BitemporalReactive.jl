module MFLUI
using SearchLight, Stipple, Stipple.Html, StippleUI

using BitemporalPostgres, InsuranceContractsController, JSON, TimeZones

@reactive mutable struct Model <: ReactiveModel
  contracts::R{Vector{Contract}} = []
  current_contract::R{Contract} = Contract()
  selected_contract_idx::R{Integer} = -1
  process::R{Bool} = false
  selected_history::R{Integer} = 0
  selected_version::R{Integer} = 0
  history::R{Vector{Dict{String}}} = Dict{String,Any}[]
  cs::Dict{String,Any} = Dict{String,Any}("loaded" => "false")
  tab::R{String} = "contracts"
  leftDrawerOpen::R{Bool} = false
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

function contract_list()
  list(dark=true, bordered=true, separator=true, style="max-width: 318px",
    template(
      item(
        clickable=true,
        vripple=true,
        [
          itemsection(
            """<q-field outlined label="History ID" stack-label>
                    <template v-slot:control>
                        <div class="self-center no-outline" tabindex="0">{{c['id']['value'}}</div>
                    </template>
                </q-field>"""
          )
        ], @click("process=true")
      ),
      @recur(:"(c,index) in contracts")
    )
  )
end

function renderhforest(model)
  quasar(:tree, ref="tree", var"node-key"="label", var"children-key"="children", nodes=:history, var"default-expand-all"=false,
    var"selected"=:selected_version,
    """
    <template v-slot:default-header="prop">
    <div class="row items-center">
      <div v-if="prop.node.icon">
      <q-icon :name="prop.node.icon" size="28px" class="q-mr-sm" />
      </div>
          <q-field color="grey-3" label-color="primary" outlined>
            <template v-slot:control>
              <div class="self-center full-width no-outline" tabindex="0"><b>{{prop.node.label}}</b></div>
            </template>
          </q-field>
          <q-field label="valid as of" stack-label outlined :dense="dense">
            <template v-slot:control>
              <div class="self-center full-width no-outline" tabindex="4">{{prop.node.time_valid_asof}}</div>
            </template>
          </q-field> 
          <q-field label="committed" stack-label outlined :dense="dense">
            <template v-slot:control>
              <div class="self-center full-width no-outline" tabindex="2">{{prop.node.time_committed}}</div>
            </template>
          </q-field>     
        </div>
    </div>
  </template>
  <template v-slot:default-body="prop">
  </template>
    """)
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
                        <th class="text-left text-white">Partner Description</th>
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
                        <td class="text-left text-white">{{tpid['ref']['revision']['description']}}</td>
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
                        <th class="text-left text-white">Tariff Parameters</th>
                      </tr>
                    </thead>
                  </template>
                  <template>
                    <tbody>
                      <template v-for="(tid,tindex) in cs['product_items'][pindex]['tariff_items']">
                      <tr>
                         <td class="text-left text-white">{{pindex}},{{tindex}}</td>
                        <td class="text-left text-white"> {{rolesTariffItem[tid['tariff_ref']['rev']['ref_role']['value']]}}</td>
                        <td class="text-left text-white"> {{tid['tariff_ref']['rev']['ref_tariff']['value']}}</td>
                        <td class="text-left text-white"> {{tid['tariff_ref']['rev']['description']}}</td>
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
                        <th class="text-left text-white">Partner Description</th>
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
                        <td class="text-left text-white">{{cpid['ref']['revision']['description']}}</td>
                      </tr>
                    </template>
                    </tbody>
                   </template>
                </q-markup-table>
      """,], var"v-if"="show_contract_partners")
end

function contract()
  card(class="my-card bg-purple-8 text-white",
    [card_section([Html.div(class="text-h2 text-white", "Contract {{cs['revision']['ref_component']['value']}}"),
        btn("Show Contract Partners", @click("show_contract_partners=!show_contract_partners")),
        btn("Show Product Items", @click("show_product_items=!show_product_items")),
        """
        <q-markup-table dark class="bg-deep-purple-5 text-white">
                  <template>
                    <thead>
                      <tr>
                        <th class="text-left text-white">Description</th>
                      </tr>
                    </thead>
                  </template>
                  <template>
                    <tbody>
                      <tr>
                        <td class="text-left text-white">{{cs['revision']['description']}}</td>
                      </tr>
                    </tbody>
                   </template>
                </q-markup-table>
        """
      ]),
      contract_partners(),
      product_items(),
    ], var"v-if"="cs['loaded'] == 'true'")
end

function page_content(model)
  join([
    """

          <q-tab-panels
            v-model="tab"
            animated
            swipeable
            horizontal
            transition-prev="jump-up"
            transition-next="jump-up"
          >
            <q-tab-panel name="contracts">
                <div class="text-h4 q-mb-md">Contracts</div>
    """,
    """
      <template v-for="(cid,cindex) in contracts">
        <div class="q-pa-md" style="max-width: 350px">
          <q-list dense bordered padding class="rounded-borders">
            <q-item clickable v-ripple v-on:click="selected_contract_idx=cindex">
              <q-item-section>
                {{cid}}
              </q-item-section>
            </q-item>   
          </q-list>
        </div>
      </template>
    """,
    """       
            </q-tab-panel>
            <q-tab-panel name="history">
                <div class="text-h4 q-mb-md">History</div>
    """,
    renderhforest(model),
    """ 
            </q-tab-panel>
            <q-tab-panel name="csection">
    """,
    contract(),
    """
            </q-tab-panel>
        </q-tab-panels>
    """
  ])
end

function ui(model)
  page(
    model,
    class="container",
    Genie.Renderer.Html.div(join([
      """
        <q-layout view="hHh lpR fFf">
          <q-header elevated class="bg-primary text-white" >
            <q-toolbar>
              <!-- <q-btn dense flat icon="drawer" @click="leftDrawerOpen=!leftDrawerOpen" /></q-btn> -->
              <q-btn color="primary" icon="menu" >
                <q-menu>
                  <q-list style="min-width: 100px">
                    <q-item clickable v-close-popup>
                      <q-item-section>New tab</q-item-section>
                    </q-item>
                    <q-item clickable v-close-popup>
                      <q-item-section>New incognito tab</q-item-section>
                    </q-item>
                    <q-item clickable v-close-popup>
                      <q-item-section>Recent tabs</q-item-section>
                    </q-item>
                    <q-item clickable v-close-popup>
                      <q-item-section>History</q-item-section>
                    </q-item>
                    <q-item clickable v-close-popup>
                      <q-item-section>Downloads</q-item-section>
                    </q-item>
                    <q-separator />
                    <q-item clickable v-close-popup>
                      <q-item-section>Settings</q-item-section>
                    </q-item>
                    <q-separator />
                    <q-item clickable v-close-popup>
                      <q-item-section>Help &amp; Feedback</q-item-section>
                    </q-item>
                  </q-list>
                </q-menu>
              </q-btn>
              <q-toolbar-title>
              BitemporalReactive
              </q-toolbar-title>
            </q-toolbar>
                  <q-tabs
        v-model="tab"
        class="bg-primary text-white shadow-2" align="left"
      >
        <q-tab name="contracts" icon="format_list_bulleted" label="Search Contract"></q-tab>
        <q-tab name="history" icon="history" label="Contract History"></q-tab>
        <q-tab name="csection" icon="verified_user" label="Contract Version"></q-tab>
      </q-tabs>
      </q-header>
          <!-- <q-drawer show-if-above v-model="leftDrawerOpen" side="left" bordered> -->
      """,
      # drawer_content(),
      """
      <!--   </q-drawer> -->
         <q-page-container> 
     """,
      page_content(model),
      """
          </q-page-container>
        </q-layout>
      """]
    )))

end

function convert(node::BitemporalPostgres.Node)::Dict{String,Any}
  i = Dict(string(fn) => getfield(getfield(node, :interval), fn) for fn ∈ fieldnames(ValidityInterval))
  shdw = length(node.shadowed) == 0 ? [] : map(node.shadowed) do child
    convert(child)
  end
  Dict("label" => string(i["ref_version"]), "interval" => i, "children" => shdw,
    "time_committed" => string(i["tsdb_validfrom"]), "time_valid_asof" => string(i["tsworld_validfrom"]))
end

function handlers(model)

  on(model.selected_contract_idx) do _
    if (model.selected_contract_idx[] == -1)
      println("selected_contract ==-1")
    else
      println("selected contract")
      println(model.selected_contract_idx[])
      println("sel c obj")
      println(model.contracts[model.selected_contract_idx[]+1])
      model.current_contract[] = model.contracts[model.selected_contract_idx[]+1]
      model.selected_contract_idx[] = -1
      model.cs = JSON.parse(JSON.json(csection(model.current_contract[].id.value, now(tz"Europe/Warsaw"), now(tz"Europe/Warsaw"))))
      model.cs["loaded"] = "true"
      model.tab[] = "csection"
      push!(model)
    end

  end

  on(model.tab) do _
    println("tab changed")
    println(model.tab[])
    if (model.tab[] == "history")
      println("current contract")
      println(model.current_contract[])
      println("history selected")
      ref_h = model.current_contract[].ref_history.value
      println(typeof(ref_h))
      println(ref_h)
      model.selected_history[] = ref_h
      println("selected history")
      println(model.selected_history[])
      model.history[] = map(convert, InsuranceContractsController.history_forest(model.selected_history[]).shadowed)
      println(typeof(h))
      println(h)
      push(!model)
    end
  end

  on(model.isready) do _
    println("ready")
    println("csection")
    model.contracts = InsuranceContractsController.get_contracts()
    model.tab[] = "contracts"
    model.cs["loaded"] = "false"
    println()
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