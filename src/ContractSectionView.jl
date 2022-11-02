module ContractSectionView
using Stipple, Stipple.Html, StippleUI
using BitemporalPostgres, LifeInsuranceDataModel, TimeZones
include("HistoryView.jl")
using .HistoryView

activetxn::Integer = 0

"""
ContractsModel

  reactive data view model (Stipple/Quasar/Vue)
  synched between Julia Server and Browser
"""
@reactive mutable struct ContractsModel <: ReactiveModel
  activetxn::Integer = 0
  command::R{String} = ""
  contracts::Vector{Contract} = []
  current_contract::Contract = Contract()
  selected_contract_idx::R{Integer} = -1
  process::R{Bool} = false
  selected_version::R{String} = ""
  current_version::Integer = 0
  txn_time::ZonedDateTime = now(tz"Africa/Porto-Novo")
  ref_time::ZonedDateTime = now(tz"Africa/Porto-Novo")
  histo::Vector{Dict{String,Any}} = Dict{String,Any}[]
  cs::R{Dict{String,Any}} = Dict{String,Any}("loaded" => "false")
  prs::Dict{String,Any} = Dict{String,Any}("loaded" => "false")
  selected_product_part_idx::R{Integer} = 0
  tab::R{String} = "product"
  leftDrawerOpen::R{Bool} = false
  show_contract_partners::R{Bool} = false
  show_product_items::R{Bool} = false
  selected_product::R{Integer} = 0
  show_tariff_item_partners::R{Bool} = false
  show_tariff_items::R{Bool} = false
  rolesContractPartner::R{Dict{Integer,String}} = Dict{Integer,String}()
  rolesTariffItem::R{Dict{Integer,String}} = Dict{Integer,String}()
  rolesTariffItemPartner::R{Dict{Integer,String}} = Dict{Integer,String}()
end

"""
contract_list
Display the contracts selection tab
"""
function contract_list()
  """
    <div class="q-pa-md">
  	<div class="q-gutter-md" style="max-width: 300px">
  	  <template v-slot:control>
  		<div class="self-center full-width no-outline" tabindex="0">{{selected_contract_idx}}</div>
  	  </template>
  	</q-field>
  	</div>
    </div>
    <template v-for="(cid,cindex) in contracts">
  	<div class="q-pa-md" style="max-width: 350px">
  	  <q-list dense bordered padding class="rounded-borders">
  		<q-item clickable v-on:click="selected_contract_idx=cindex">
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
selected_product_part_idx
Display the product tab
"""
function product()
  card(
    class="my-card bg-purple-8 text-white",
    [
      card_section([Html.div(class="text-h2 text-white", "Product {{prs['revision']['ref_component']['value']}}"), Html.div(class="text-h2 text-white", "{{prs['revision']['description']}}")]),
      """
        <div class="q-pa-md" style="max-width: 350px">
      	<q-list dense bordered padding class="rounded-borders">
      	  <q-item clickable v-ripple v-on:click="selected_product_part_idx=ppindex" v-for="(ppid,ppindex) in prs['parts']">
      		<q-item-section>
      		  {{ppid['revision']['description']}}
      		</q-item-section>
      		<q-item-section>
      		  tariff id {{ppid['ref']['revision']['ref_component']['value']}}
      		</q-item-section>
      		<q-item-section>
      		  description {{ppid['ref']['revision']['description']}}
      		</q-item-section><q-item-section>
      		  Mortality Table {{ppid['ref']['revision']['mortality_table']}}
      		</q-item-section>
      	  </q-item>   
      	</q-list>
        </div>
       """,
    ],
    var"v-if"="prs['loaded'] == 'true'",
  )
end

"""
contract
contract version tab
"""
function contract()
  card(
    class="my-card bg-purple-8 text-white",
    [
      card_section([
        Html.div(class="text-h2 text-white", "Contract {{cs['revision']['ref_component']['value']}}"),
        Html.div(class="text-h5 text-white", "valid as of {{ref_time}} transaction time {{txn_time}}"),
        """
        <q-markup-table dark class="bg-deep-purple-5 text-white">div
        			<thead>
        			  <tr>
        				<th class="text-left text-white">Description</th>
        			  </tr>
        			</thead>
        			<tbody>
        			  <tr>
        				<td class="text-left text-white"><q-input bg-color="white" standout="bg-teal text-white" v-model="cs['revision']['description']"/>description</td>
        			  </tr>
        			</tbody>
        		</q-markup-table>
        """,
        """
<q-list>
    <q-item class="q-pa-md bg-purple-8 text-white">
        <div class="row">
            <div class="col">
                <q-input bg-color="white" label="description" v-model="cs['revision']['description']"></q-input
                    bg-color="white">
            </div>
            <div class="col">
                <q-input bg-color="white" label="ref_history" v-model="cs['ref_history']['value']"></q-input
                    bg-color="white">
            </div>
            <div class="col">
                <q-input bg-color="white" label="tsdb_validfrom" v-model="cs['tsdb_validfrom']"></q-input
                    bg-color="white">
            </div>
        </div>
    </q-item>

    <hr />
    <q-expansion-item label="contract partners" class="q-mt-md q-mr-sm bg-deep-purple-8 text-white">
        <div v-for="(pr,pridx) in cs['partner_refs']" class="q-pa-md">
            <div class="q-pa-md">
                <q-checkbox label="selected" v-model="cs['partner_refs'][pridx]['selected']"></q-checkbox>
            </div>
            <div class="row">
                <div class="col">
                    <q-input bg-color="white" label="ref_component" v-model="pr['rev']['ref_component']['value']">
                 </section>   </q-input>
                </div>
                <div class="col">
                    <q-input bg-color="white" label="description" v-model="pr['rev']['description']"></q-input
                        bg-color="white">
                </div>
                <div class="col">
                    <q-select label="ref_partner sel" v-model="pr['rev']['ref_partner']['value']" :options="partner">
                    </q-select>
                </div>
                <div class="col">
                    <q-input bg-color="white" label="ref_partner" v-model="pr['rev']['ref_partner']['value']"></q-input
                        bg-color="white">
                </div>
            </div>
        </div>
    </q-expansion-item >
    <hr/>
    <q-expansion-item label="product items" class="q-mt-md q-mr-sm bg-deep-purple-8 text-white">
      <q-btn label="add" v-on:click="command='add productitem'"></q-btn>
        <div v-for="pi in cs['product_items']" class="q-pa-md">
            <div class="row">
                <div class="col">
                    <q-input bg-color="white" label="description" v-model="pi['revision']['ref_component']['value']">
                    </q-input>
                </div>
                <div class="col">
                    <q-input bg-color="white" label="description" v-model="pi['revision']['description']"></q-input
                        bg-color="white">
                </div>
            </div>
            <hr />
            <q-expansion-item label="tariff items">
            <q-list class="q-mt-md q-mr-sm bg-purple text-white">
                <div v-for="ti in pi['tariff_items']" class="q-pa-md">
                    <div class="row">
                        <div class="col">
                            <q-input bg-color="white" label="description"
                                v-model="ti['tariff_ref']['rev']['description']"></q-input>
                        </div>
                        <div class="col">
                            <q-input bg-color="white" label="ref_tariff"
                                v-model="ti['tariff_ref']['rev']['ref_tariff']['value']">
                            </q-input>
                        </div>
                        <div class="col">
                            <q-input bg-color="white" label="deferment" v-model="ti['tariff_ref']['rev']['deferment']">
                            </q-input>
                        </div>
                        <div class="col">
                            <q-input bg-color="white" label="annuity_due"
                                v-model="ti['tariff_ref']['rev']['annuity_due']">
                            </q-input>
                        </div>
                    </div>
                    <hr />
                    <q-expansion-item label="tariff_item_partners">
                    <q-list class="q-mt-md q-mr-sm bg-deep-purple-8 text-white">
                        <div v-for="tipr in ti['partner_refs']" class="q-pa-md">
                        <p>description {{tipr['rev']['description']}}
                        </p>
                        <p>ref_partner {{tipr['rev']['ref_partner']['value']}}
                        </p>
                            <div class="row">
                                <div class="col">
                                    <q-input bg-color="white" label="ref_component" v-model="tipr['rev']['ref_component']['value']">
                                    </q-input>
                                </div>
                                <div class="col">
                                <q-input bg-color="white" label="id" v-model="tipr['rev']['id']['value']">
                                </q-input>
                                </div>
                                <div class="col">
                                <q-input bg-color="white" label="description" v-model="tipr['rev']['description']">
                                </q-input>
                                </div>
                                <div class="col">
                                <q-input bg-color="white" label="ref_role" v-model="tipr['rev']['ref_role']['value']">
                                </q-input>
                                </div>
                                <div class="col">
                                <q-input bg-color="white" label="ref_partner"
                                    v-model="tipr['rev']['ref_partner']['value']">
                                </q-input>
                                </div>

                            </div>
                        </div>
                    </q-list>
                    </q-expansion-item>
                </div>
            </q-list>
            </q-expansion-item>
        </div>
    </q-expansion-item>
</q-list>				
			   	""",
      ]),
    ],
    var"v-if"="cs['loaded'] == 'true'",
  )
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
    		<q-tab-panel name="contracts">
    			<div class="text-h4 q-mb-md">Contracts</div>
    """,
    contract_list(),
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
    		<q-tab-panel name="product">
    """,
    product(),
    """
    		</q-tab-panel>
    	</q-tab-panels>
    """,
  ])
end

"""
ui(model)
entry point of the vue app
"""
function ui(model)
  page(model, class="container", Genie.Renderer.Html.div(join([
    """
      <q-layout view="hHh lpR fFf">
    	<q-header elevated class="bg-primary text-white" >
    	  <q-toolbar>
    		<!-- <q-btn dense flat icon="drawer" @click="leftDrawerOpen=!leftDrawerOpen" /></q-btn> -->
    		<q-btn color="primary" icon="menu" >
    		  <q-menu>
    			<q-list style="min-width: 100px">
    			  <q-item clickable v-close-popup @click="command='persist'" />
    				<q-item-section>Persist</q-item-section>
    			  </q-item>
    			  <q-item clickable v-close-popup @click="command='reset'" />
    				<q-item-section>Reset Command</q-item-section>
    			  </q-item>
    			  <q-item tag="a" href="/PartnerSection" clickable v-close-popup>
    				<q-item-section>Partners</q-item-section>
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
      <q-tab name="csection" icon="verified_user" label="Contract Version"></q-tab>
      <q-tab name="history" icon="history" label="Contract History"></q-tab>
      <q-tab name="product" icon="functions" label="Product"></q-tab>
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
    """,
  ])))

end
end
