module PartnerSectionView
using LifeInsuranceDataModel, Stipple, StippleUI, TimeZones
include("HistoryView.jl")
using .HistoryView

@reactive mutable struct PartnersModel <: ReactiveModel
  partners::R{Vector{Partner}} = []
  current_partner::R{Partner} = Partner()
  selected_partner_idx::R{Integer} = -1
  process::R{Bool} = false
  selected_version::R{String} = ""
  current_version::R{Integer} = 0
  txn_time::R{ZonedDateTime} = now(tz"Africa/Porto-Novo")
  ref_time::R{ZonedDateTime} = now(tz"Africa/Porto-Novo")
  histo::R{Vector{Dict{String,Any}}} = Dict{String,Any}[]
  ps::R{Dict{String,Any}} = Dict{String,Any}("tsdb_validfrom" => "2022-09-07T09:00:02.844+00:00", "ref_history" => Dict{String,Any}("value" => 2^53 - 1), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 2^53 - 1), "date_of_birth" => "", "ref_component" => Dict{String,Any}("value" => 0), "id" => Dict{String,Any}("value" => 0), "description" => ""), "ref_version" => Dict{String,Any}("value" => 2^53 - 1), "tsw_validfrom" => "2022-09-07T09:00:02.844+00:00")
  tab::R{String} = "partners"
end

"""
partner_list
Display the contracts selection tab
"""
function partner_list()
  """
    <template v-for="(cid,cindex) in partners">
      <div class="q-pa-md" style="max-width: 350px">
        <q-list dense bordered padding class="rounded-borders">
          <q-item clickable v-ripple v-on:click="selected_partner_idx=cindex">
            <q-item-section>
              {{cid['id']['value']}}
            </q-item-section>
          </q-item>   
        </q-list>
      </div>
    </template>
  """
end

"""
partner()
partner version tab
"""
function partner()
  card(class="my-card bg-purple-8 text-white",
    [card_section([Html.div(class="text-h2 text-white", "Partner {{ps['revision']['ref_component']['value']}}"),
      Html.div(class="text-h5 text-white", "valid as of {{ref_time}} transaction time {{txn_time}}"),
      """
      <q-markup-table dark class="bg-deep-purple-5 text-white">
                      <template>
                        <thead>
                          <tr>
                            <th class="text-left text-white">Partner Id</th>
                            <th class="text-left text-white">Partner Description</th>
                            <th class="text-left text-white">Partner Date of Birth</th>
                          </tr>
                        </thead>
                      </template>
                      <template>
                        <tbody>
                          <tr>
                          <td class="text-left text-white">{{ps['revision']['ref_component']['value']}}</td>
                          <td class="text-left text-white">{{ps['revision']['description']}}</td>
                          <td class="text-left text-white">{{ps['revision']['date_of_birth']}}</td>
                          </tr>
                        </tbody>
                       </template>
                    </q-markup-table>
      """
    ])
    ])
end

"""
page_content(model)
provides the tab structure slots
"""
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
            <q-tab-panel name="partners">
                <div class="text-h4 q-mb-md">Partners</div>
    """,
    partner_list(),
    """       
            </q-tab-panel>
            <q-tab-panel name="history">
                <div class="text-h4 q-mb-md">History</div>
    """,
    renderhforest(model),
    """ 
            </q-tab-panel>
            <q-tab-panel name="psection">
    """,
    partner(),
  ])
end


"""
ui(model)
entry point of the vue app
"""
function ui(model::PartnerSectionView.PartnersModel)
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
                      <q-item-section>Recent tabs</q-item-section>
                    </q-item>
                    <q-item tag="a" href="/ContractSection" clickable>
                      <q-item-section>Contracts</q-item-section>
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
        <q-tab name="partners" icon="format_list_bulleted" label="Search Partner"></q-tab>
        <q-tab name="psection" icon="verified_user" label="Partner Version"></q-tab>
        <q-tab name="history" icon="history" label="Partner History"></q-tab>
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

end