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
	histo::Vector{Dict{String, Any}} = Dict{String, Any}[]
	cs::R{Dict{String, Any}} = Dict{String, Any}("loaded" => "false")
	prs::Dict{String, Any} = Dict{String, Any}("loaded" => "false")
	selected_product_part_idx::R{Integer} = 0
	tab::R{String} = "product"
	leftDrawerOpen::R{Bool} = false
	show_contract_partners::R{Bool} = false
	show_product_items::R{Bool} = false
	selected_product::R{Integer} = 0
	show_tariff_item_partners::R{Bool} = false
	show_tariff_items::R{Bool} = false
	rolesContractPartner::R{Dict{Integer, String}} = Dict{Integer, String}()
	rolesTariffItem::R{Dict{Integer, String}} = Dict{Integer, String}()
	rolesTariffItemPartner::R{Dict{Integer, String}} = Dict{Integer, String}()
end

"""
contract_list
Display the contracts selection tab
"""
function contract_list()
	"""
	  <div class="q-pa-md">
		<div class="q-gutter-md" style="max-width: 300px">
		  <q-field filled label="Filled" stack-label>
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
		class = "my-card bg-purple-8 text-white",
		[
			card_section([Html.div(class = "text-h2 text-white", "Product {{prs['revision']['ref_component']['value']}}"), Html.div(class = "text-h2 text-white", "{{prs['revision']['description']}}")]),
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
		var"v-if" = "prs['loaded'] == 'true'",
	)
end


"""
tariff_item_partners
Display the partners referenced by a tarif item, insured person(s) typically
"""
function tariff_item_partners()
	card(
		class = "my-card bg-deep-purple-8 text-white",
		[
			card_section([Html.div(class = "text-h3 text-white", "Tariff Item Partners")]),
			""",
					<q-markup-table dark class="bg-deep-purple-5 text-white">
						  <thead>
							<tr>
							  <th class="text-left text-white">Item</th>
							  <th class="text-left text-white">Role</th>
							  <th class="text-left text-white">Partner Id</th>
							  <th class="text-left text-white">Partner Description</th>
							  <th class="text-left text-white">Date of Birth</th>
							</tr>
						  </thead>
						  <tbody>
							<tr v-for="(tpid,tpindex) in cs['product_items'][pindex]['tariff_items'][tindex]['partner_refs']" >
							  <td class="text-left text-white">{{pindex}},{{tindex}},{{tpindex}}</td>
							  <td class="text-left text-white">{{rolesTariffItemPartner[tpid['rev']['ref_role']['value']]}}</td>
							  <td class="text-left text-white">{{tpid['rev']['ref_partner']['value']}}</td>
							  <td class="text-left text-white">{{tpid['ref']['revision']['description']}}</td>
							  <td class="text-left text-white">{{tpid['ref']['revision']['date_of_birth']}}</td>
							</tr>
						  </tbody>
					  </q-markup-table>
			""",
		],
		var"v-if" = "show_tariff_item_partners",
	)
end

"""
tariff_items
Displays tariff parameters and partners referenced 
"""
function tariff_items()
	card(
		class = "my-card bg-indigo-8 text-white",
		[
			card_section([Html.div(class = "text-h3 text-white", "Tariff Items"), btn("Show Tariff Item Partners", outline = true, @click("show_tariff_item_partners=!show_tariff_item_partners"))]),
			""",
					<q-markup-table dark class="bg-indigo-5 text-white">
						  <thead>
							<tr>
							  <th class="text-left text-white">Item</th>
							  <th class="text-left text-white">Role</th>
							  <th class="text-left text-white">Tariff Id</th>
							  <th class="text-left text-white">Description</th>
							  <th class="text-left text-white">net premium</th>
							  <th class="text-left text-white">annuity immediate</th>
							  <th class="text-left text-white">annuity due</th>
							  <th class="text-left text-white">deferment</th>
							</tr>
						  </thead>
						  <tbody>
							<template v-for="(tid,tindex) in cs['product_items'][pindex]['tariff_items']">
							<tr>
							   <td class="text-left text-white">{{pindex}},{{tindex}}</td>
							  <td class="text-left text-white"> {{rolesTariffItem[tid['tariff_ref']['rev']['ref_role']['value']]}}</td>
							  <td class="text-left text-white"> {{tid['tariff_ref']['rev']['ref_tariff']['value']}}</td>
							  <td class="text-left text-white"> {{tid['tariff_ref']['rev']['description']}}</td>
							  <td class="text-left text-white"> {{tid['tariff_ref']['rev']['net_premium']}}</td>
							  <td class="text-left text-white"> {{tid['tariff_ref']['rev']['annuity_immediate']}}</td>
							  <td class="text-left text-white"> {{tid['tariff_ref']['rev']['annuity_due']}}</td>
							  <td class="text-left text-white"> {{tid['tariff_ref']['rev']['deferment']}}</td>
							</tr>
			""",
			tariff_item_partners(),
			"""
			  		
					   </template>
			  		</tbody>
			  		</q-markup-table>
			  """,
		],
		var"v-if" = "show_tariff_items",
	)
end

"""
product_items
Displays product items, technically insurance (sub) contracts of which the contract proper can contain several, for instance 
to represent dynamic increases of the insurance sum, which can be be revoked individually. 
"""
function product_items()
	card(
		class = "my-card bg-purple-8 text-white",
		[
			card_section([Html.div(class = "text-h2 text-white", "Product Items"), btn("Show Tariff Items", outline = true, @click("show_tariff_items=!show_tariff_items"))]),
			"""
			  	  <q-markup-table class="dark bg-purple-5 text-white">
			  		<template>
			  		  <thead>
			  			<tr>
			  			  <th class="text-left text-white">Item</th>
			  			  <th class="text-left text-white">Description</th>
			  			  <th class="text-left text-white">Product id</th>
			  			</tr>
			  		  </thead>
			  		</template>
			  		<template>
			  		  <tbody>
			  			<template v-for="(pid,pindex) in cs['product_items']">
			  	  <tr outline=true>
			  		<td class="text-left text-white">{{pindex}}</td>
			  		<td class="text-left text-white">{{pid['revision']['description']}}</td>
			  		<td class="text-left text-white">{{pid['revision']['ref_product']['value']}}</td>
			  		<td class="text-left text-white"><q-btn outline icon="functions" @click="selected_product=pid['revision']['ref_product']['value']"></q-btn></td>
			  		
			  """,
			tariff_items(),
			"""
			  			</tr>
			  		  </template>
			  		  </tbody>
			  		</template>
			  	  </q-markup-table>
			  """,
		],
		var"v-if" = "show_product_items",
	)
end

"""
contract_partners
Partners, at least the policy holder, but also premium payer and beneficiaries, if different from policy holder.
"""
function contract_partners()
	card(
		class = "my-card bg-deep-purple-8 text-white",
		[
			card_section([Html.div(class = "text-h3 text-white", "Contract Partners")]),
			""",
					<q-markup-table dark class="bg-deep-purple-5 text-white">
						<template>
						  <thead>
							<tr>
							  <th class="text-left text-white">Index</th>
							  <th class="text-left text-white">Role</th>
							  <th class="text-left text-white">Partner Id</th>
							  <th class="text-left text-white">Partner Description</th>
							  <th class="text-left text-white">Partner Date of Birth</th>
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
							  <td class="text-left text-white">{{cpid['ref']['revision']['date_of_birth']}}</td>
							</tr>
						  </template>
						  </tbody>
						 </template>
					  </q-markup-table>
			""",
		],
		var"v-if" = "show_contract_partners",
	)
end

"""
contract
contract version tab
"""
function contract()
	card(
		class = "my-card bg-purple-8 text-white",
		[
			card_section([
				Html.div(class = "text-h2 text-white", "Contract {{cs['revision']['ref_component']['value']}}"),
				Html.div(class = "text-h5 text-white", "valid as of {{ref_time}} transaction time {{txn_time}}"),
				btn("Show Contract Partners", outline = true, @click("show_contract_partners=!show_contract_partners")),
				btn("Show Product Items", outline = true, @click("show_product_items=!show_product_items")),
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
								<td class="text-left text-white"><q-input standout="bg-teal text-white" v-model="cs['revision']['description']"/>description</td>
							  </tr>
							</tbody>
						   </template>
						</q-markup-table>
				""",
			]),
			contract_partners(),
			product_items(),
		],
		var"v-if" = "cs['loaded'] == 'true'",
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
	page(model, class = "container", Genie.Renderer.Html.div(join([
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
