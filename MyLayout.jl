module ContractSectionSO
using DataFrames, JSON, Stipple, StippleUI

modelData = Dict{String,Any}("tsdb_validfrom" => "2022-05-08T17:43:49.077+00:00", "ref_history" => Dict{String,Any}("value" => 4), "ref_entities" => Dict{String,Any}(), "contract_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 5), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "blue"), "contract_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue"), "ref_version" => Dict{String,Any}("value" => 4), "tsw_validfrom" => "2022-05-08T17:43:49.077+00:00", "product_items" => Any[Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "position" => 1, "description" => "blue"), "productitem_tariffref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue", "ref_tariff" => Dict{String,Any}("value" => 1)), "productitem_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue")), Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "position" => 2, "description" => "pink"), "productitem_tariffref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 2), "description" => "pink", "ref_tariff" => Dict{String,Any}("value" => 2)), "productitem_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 1), "description" => "pink"))])
newItem = Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "ref_role" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => nothing), "position" => 0, "description" => ""), "productitem_tariffref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => "", "ref_tariff" => Dict{String,Any}("value" => nothing)), "productitem_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => nothing), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => ""))

Dict(["Policy Holder" => 1, "Premium Payer => 2"])

@reactive mutable struct Model <: ReactiveModel
  rolesText::R{Dict{Integer,String}} = Dict{Integer,String}([1 => "Policy Holder", 2 => "Premium Payer"])
  roles::Vector{Integer} = [1, 2]
  modContractRevision::R{Bool} = false
  modContractPartnerRefRevision::R{Bool} = false
  modProductitemRevision::R{Bool} = false
  addProductItem::R{Bool} = false
  csect::R{Dict{String,Any}} = Dict{String,Any}("contract_revision" => 1)
  data::R{DataTable} = DataTable(DataFrame(rand(100000, 2), ["x1", "x2"]), DataTableOptions(columns=[Column("x1"), Column("x2", align=:right)]))
  data_pagination::DataTablePagination = DataTablePagination(rows_per_page=50)
  leftDrawerOpen::R{Bool} = false
  tab::R{String} = "three"
end

function ui(model)
  page(
    model,
    class="container",
    Genie.Renderer.Html.div(
      """
        <q-layout view="hHh lpR fFf">
          <q-header elevated class="bg-primary text-white" >
            <q-toolbar>
              <q-btn dense flat round icon="menu" @click="leftDrawerOpen=!leftDrawerOpen" />
              <q-btn color="primary" label="Basic Menu">
        <q-menu>
          <q-list style="min-width: 100px">
            <q-item clickable v-close-popup>
              <q-item-section>New tab</q-item-section>
            </q-item>
            <q-item clickable v-close-popup>
              <q-item-section>New incognito tab</q-item-section>
            </q-item>
            <q-separator />
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
              Title
              </q-toolbar-title>
            </q-toolbar>
          </q-header>
          <q-drawer show-if-above v-model="leftDrawerOpen" side="left" bordered>
      """
      * table(title="Random numbers", :data; pagination=:data_pagination, style="height: 350px;") *
      """
          </q-drawer>
          <q-page-container>
      """
      * string([table(title="Random numbers", :data; pagination=:data_pagination, style="height: 350px;"),
        list(dark=true, bordered=true, separator=true, style="max-width: 318px",
          [item(vripple=true,
              item_section([
                item_label(overline=true, "Contract"),
                item_label(overline=true, "Description"),
                """ <input v-model="csect['contract_revision']['description']" v-on:keyup.enter="modContractRevision=true"/> """,
                item_label(overline=true, "Policy Holder description"),
                """ <input v-model="csect['contract_partnerref_revision']['description']" v-on:keyup.enter="modContractPartnerRefRevision=true"/> """,
                """ <q-select class="bg-grey-5" filled outlined v-model="csect['contract_partnerref_revision']['ref_role']['value']"
                        :options="roles" label="Partner role" :display-value="rolesText[csect['contract_partnerref_revision']['ref_role']['value']]" />
                                  <template v-slot:append>
                                            <q-icon name="handshake" />
                                        </template>
                                    </q-select>        
                """,
                item_label(overline=true, "Policy Holder id"),
                """ <input v-model="csect['contract_partnerref_revision']['ref_partner']['value']" v-on:keyup.enter="modContractPartnerRefRevision=true"/> """,
              ])),
            p(btn("add item", class="bg-grey-5", icon="add", @click("addProductItem=true"))),
            list(template(
              item(
                clickable=true,
                vripple=true, itemsection([
                  itemlabel("Product item {{index}}", overline=true),
                  textfield("HHDescription", dense=true, label__color="orange", bg__color="white", R"""csect['product_items'][index]['productitem_revision']['description']""", @on("keyup.enter", "modProductitemRevision=true")),
                  itemlabel("HHDescription"),
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
      ]) *
      """
          </q-page-container>
        </q-layout>
      """
    ))

end

function handlers(model)
  on(model.modContractRevision) do _
    if (model.modContractRevision[])
      println("mod contract")
      println(model.csect["contract_revision"])
      model.modContractRevision[] = false
    end
  end
  on(model.modContractPartnerRefRevision) do _
    if (model.modContractPartnerRefRevision[])
      println("mod contractpartnerref")
      println(model.csect["contract_partnerref_revision"])
      model.modContractPartnerRefRevision[] = false
    end
  end

  on(model.modProductitemRevision) do _
    if (model.modProductitemRevision[])
      println("mod Productitem")
      model.modProductitemRevision[] = false
    end
  end
  on(model.addProductItem) do _
    println("on add pi2")
    if (model.addProductItem[])
      println("add pi2")
      println("newItem ")
      println(newItem)
      currentItems = model.csect["product_items"]
      println("curritems")
      println(currentItems)
      newItems = [currentItems; newItem]
      println("newItems")
      println(newItems)
      model.csect["product_items"] = newItems
      println("f'ddich")
      model.addProductItem[] = false
      push!(model)
    end
  end

  on(model.isready) do _
    println("pushing")
    println(model.csect["contract_partnerref_revision"]["ref_role"])
    push!(model)
  end
  model
end

function routeContractSection(model)
  route("/csection") do
    html(ui(model), context=@__MODULE__)
    # html(ui2(model), context=@__MODULE__)
  end
end

model = handlers(Stipple.init(Model))
csectDict = modelData
model.csect = csectDict
println("init")
println(model)
routeContractSection(model)
Stipple.up()


end #module

