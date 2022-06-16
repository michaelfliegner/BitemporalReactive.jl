module MFLUI
using Stipple, Stipple.Html, StippleUI
cs = Dict{String,Any}("tsdb_validfrom" => "2022-06-16T16:27:21.510+00:00", "ref_history" => Dict{String,Any}("value" => 4), "contract_partnerrefs" => Any[Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue"), Dict{String,Any}("tsdb_validfrom" => "2022-06-16T16:27:21.449+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "partner_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => ""), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-16T16:27:21.449+00:00")]], "ref_entities" => Dict{String,Any}(), "contract_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 6), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 3), "description" => "red"), "ref_version" => Dict{String,Any}("value" => 6), "tsw_validfrom" => "2022-06-16T16:27:21.510+00:00", "product_items" => Any[Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "position" => 1, "description" => "blue"), "productitem_partnerrefs" => Any[Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue"), Dict{String,Any}("tsdb_validfrom" => "2022-06-16T16:27:21.474+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "partner_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "blue"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-16T16:27:21.474+00:00")], Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 1), "description" => "pink"), Dict{String,Any}("tsdb_validfrom" => "2022-06-16T16:27:21.482+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "partner_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "blue"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-16T16:27:21.482+00:00")]], "productitem_tariffrefs" => Any[Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue", "ref_tariff" => Dict{String,Any}("value" => 1)), Dict{String,Any}("tsdb_validfrom" => "2022-06-16T16:27:21.463+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-16T16:27:21.463+00:00", "tariff_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 2), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "blue"))]]), Dict{String,Any}("productitem_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "position" => 2, "description" => "pink"), "productitem_partnerrefs" => Any[Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "blue"), Dict{String,Any}("tsdb_validfrom" => "2022-06-16T16:27:21.502+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "partner_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "blue"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-16T16:27:21.502+00:00")], Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 1), "description" => "pink"), Dict{String,Any}("tsdb_validfrom" => "2022-06-16T16:27:21.510+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "partner_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "blue"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-16T16:27:21.510+00:00")]], "productitem_tariffrefs" => Any[Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 2), "description" => "pink", "ref_tariff" => Dict{String,Any}("value" => 2)), Dict{String,Any}("tsdb_validfrom" => "2022-06-16T16:27:21.494+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-16T16:27:21.494+00:00", "tariff_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 3), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "description" => "blue"))]])])

@reactive mutable struct Model <: ReactiveModel
  tab::R{String} = ""
  productitems::R{Vector{Dict{String,Any}}} = cs["product_items"]
  rolesTextPartner::R{Dict{Integer,String}} = Dict{Integer,String}([1 => "Policy Holder", 2 => "Premium Payer"])
end


function ui(model)
  page(
    model,
    title="Bitemporal Reactive ContractSection",
    Html.div(id="q-app", style="min-height: 100vh;",
      Html.div(class="q-pa-md",
        card(class="my-card",
          [card_section([Html.div(class="text-h6", "Product Items Stipple"),
              Html.div(class="text-subtitle2", "??? Stipple"),
            ]),
            """
              <q-markup-table>
                <template>
                  <thead>
                    <tr>
                      <th class="text-left">Coverage</th>
                      <th class="text-right">Role</th>
                      <th class="text-right">Id</th>
                    </tr>
                  </thead>
                </template>
                <template>
                  <tbody>
                    <template v-for='(id,index) in productitems'>
                    <tr>
                      <td class="text-left">{{productitems[index]['productitem_partnerrefs'][0][0]['description']}}</td>
                      <td class="text-right">{{rolesTextPartner[productitems[index]['productitem_partnerrefs'][0][0]['ref_role']['value']]}}</td>
                      <td class="text-right">{{productitems[index]['productitem_partnerrefs'][0][0]['id']['value']}}</td>
                    </tr>
                  </template>
                  </tbody>
                </template>
              </q-markup-table>
        """])))
  )
end

function handlers(model)
  on(model.tab) do _
    println(model.tab[])
  end

  on(model.isready) do _
    println("ready")
    model.tab[] = "csection"
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