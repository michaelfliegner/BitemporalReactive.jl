module ContractSection
push!(LOAD_PATH, "src/model")
using DataFrames, Stipple, StippleUI, TimeZones

@reactive mutable struct Model <: ReactiveModel
  selected_contract::R{Contract} = Contract()
  selected_history::R{Integer} = 0
  selected_version::R{String} = ""
  process::R{Bool} = false
  contracts::R{Vector{Contract}} = []
  current_version::R{Integer} = 0
  history::R{Vector{Dict{String}}} = Dict{String,Any}[]
  rolesText::R{Dict{Integer,String}} = Dict{Integer,String}([1 => "Policy Holder", 2 => "Premium Payer"])
  roles::R{Vector{Integer}} = [1, 2]
  modContractRevision::R{Bool} = false
  modContractPartnerRefRevision::R{Bool} = false
  modProductitemRevision::R{Bool} = false
  addProductItem::R{Bool} = false
  csect::R{Dict{String,Any}} = Dict{String,Any}("tsdb_validfrom" => "2022-06-10T14:25:10.011+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "contract_partnerrefs" => Any[Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => nothing), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "ref_role" => Dict{String,Any}("value" => 9223372036854775807), "description" => ""), Dict{String,Any}("tsdb_validfrom" => "2022-06-10T14:25:10.011+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "partner_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => ""), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-10T14:25:10.011+00:00")]], "ref_entities" => Dict{String,Any}(), "contract_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => ""), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-10T14:25:10.011+00:00", "product_items" => Any[])
  #data::R{DataTable} = DataTable(DataFrame(rand(100, 2), ["x1", "x2"]), DataTableOptions(columns=[Column("x1"), Column("x2", align=:right)]))
  #data_pagination::DataTablePagination = DataTablePagination(rows_per_page=50)
  leftDrawerOpen::R{Bool} = false
  tab::R{String} = "contracts"
end

TreeDict = Dict{String,Any}[Dict("label" => "7", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 4, "id" => 7, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 6), "time_committed" => "2022-05-21T17:49:58.742+00:00", "time_valid_asof" => "2015-05-30T20:00:01.001+00:00", "children" => Dict{String,Any}[Dict("label" => "5", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2016, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 506, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "ref_history" => 4, "id" => 5, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 5), "time_committed" => "2022-05-21T17:49:58.506+00:00", "time_valid_asof" => "2016-05-30T20:00:01.001+00:00", "children" => Any[])]), Dict("label" => "8", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2014, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 4, "id" => 8, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "is_committed" => 1, "ref_version" => 4), "time_committed" => "2022-05-21T17:49:58.742+00:00", "time_valid_asof" => "2014-05-30T20:00:01.001+00:00", "children" => Any[])]

function contract_version(model)
  list(dark=true, bordered=true, separator=true, style="max-width: 318px",
    ["""
  <div class="q-gutter-md row items-start">
    <q-card style="max-width: 250px">
      <q-card-section>
        <div class="text-h6">Contract</div>
        <div class="text-subtitle2">by John Doe</div>
      </q-card-section>
      <q-separator></q-separator>
      <q-card-actions>
        <q-input v-model="csect['contract_revision']['description']" v-on:keyup.enter="modContractRevision=true" label="Contract Revision Description" stack-label></q-input>
        <q-card style="max-width: 250px">
          <q-card-section>
            <div class="text-h6">Contract Partners</div>
            <div class="text-subtitle2">by John Doe</div>
          </q-card-section>
          <q-separator></q-separator>
          <q-card-actions>
            <q-input v-model="csect['contract_partnerrefs'][0][0]['description']" v-on:keyup.enter="modContractPartnerRefRevision=true" label="Contract Partnerref 1 Description"></q-input>
            <q-select v-model="csect['contract_partnerrefs'][0][0]['ref_role']['value']"
                    :options="roles" label="Partner role" :display-value="rolesText[csect['contract_partnerrefs'][0][0]['ref_role']['value']]" />
                              <template v-slot:append><q-icon name="handshake" /></template>
                </q-select> 
          </q-card-actions>
        </q-card>
        <q-card style="max-width: 250px">
          <q-card-section>
            <div class="text-h6">Product Items</div>
            <div class="text-subtitle2">by John Doe</div>
          </q-card-section>
          <q-separator></q-separator>
          <q-card-actions>""",
      #      template(
      #        list(item(input(@bind("""csect["product_items"][index]["productitem_revision"]["description"]"""), @on("keyup.enter", "modProductitemRevision=true"), label="huhu1")),
      #          item(input(@bind("""csect["product_items"][index]["productitem_revision"]["description"]"""), @on("keyup.enter", "modProductitemRevision=true", label = "huhu1")))),
      #        var"v-for"="(item,index) in csect['product_items']"),
      """ 
        </q-card-actions>
      </q-card>
    </q-card-actions>
  </q-card>
</div>
""",
      list(template(
        item(
          clickable=true,
          vripple=true, itemsection([
            itemlabel("Product item {{index}}", overline=true),
            textfield("Description", bg__color="white", R"""csect['product_items'][index]['productitem_revision']['description']""", @on("keyup.enter", "modProductitemRevision=true")),
            itemlabel("Description"),
            input(@bind("""csect["product_items"][index]["productitem_revision"]["description"]"""), @on("keyup.enter", "modProductitemRevision=true")),
            itemlabel("Tariff"),
            """
            <input v-model="csect['product_items'][index]['productitem_tariffref_revision']['ref_tariff']['value']" v-on:keyup.enter="modProductitemRevision=true"/>      
            """,
            itemlabel("Insured Person id"),
            """
            <input v-model="csect['product_items'][index]['productitem_partnerref_revision']['ref_partner']['value']" v-on:keyup.enter="modProductitemRevision=true"/>      
            """],
          )),
        var"v-for"="(item,index) in csect['product_items']"
      )
      ),
    ])
end

function contract_list(model)
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
        ], @click("selected_contract=c")
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
    contract_list(model),
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
    contract_version(model),
    """
            </q-tab-panel>
        </q-tab-panels>
    """
  ])
end

#function drawer_content()
#  table(title="Random numbers", :data; pagination=:data_pagination, style="height: 350px;")
#end

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

function routeContractSection(model)
  route("/csection") do
    html(ui(model), context=@__MODULE__)
  end
end

function startup(model)
  routeContractSection(model)
  Stipple.up()
end


end #module

