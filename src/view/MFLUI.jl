module MFLUI
using Stipple, Stipple.Html, StippleUI

cs = Dict{String,Any}(
  "tsdb_validfrom" => "2022-06-20T16:22:14.423+00:00",
  "ref_history" => Dict{String,Any}("value" => 5),
  "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 7), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807),
    "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 3), "description" => "contract 1, 3rd mutation retrospective"),
  "partner_refs" => Any[
    Dict{String,Any}(
    "rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "policiyholder ref properties"),
    "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-06-20T16:22:06.100+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => ""), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-20T16:22:06.100+00:00"))
  ],
  "ref_version" => Dict{String,Any}("value" => 7),
  "tsw_validfrom" => "2022-06-20T16:22:14.423+00:00",
  "product_items" => Any[
    Dict{String,Any}(
      "tariff_items" => Any[
        Dict{String,Any}(
        "tariff_ref" => Dict{String,Any}(
          "rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "Life Risk tariff parameters", "ref_tariff" => Dict{String,Any}("value" => 2)),
          "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-06-20T16:22:10.463+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 3), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "description" => "Terminal Illness"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-20T16:22:10.463+00:00")),
        "partner_refs" => Any[
          Dict{String,Any}(
          "rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "partner 1 ref properties"),
          "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-06-20T16:22:14.316+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-20T16:22:14.316+00:00"))])], "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "position" => 1, "description" => "Item 1")),
    Dict{String,Any}(
      "tariff_items" => Any[
        Dict{String,Any}(
        "tariff_ref" => Dict{String,Any}(
          "rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 2), "description" => "Occupational Disability tariff parameters", "ref_tariff" => Dict{String,Any}("value" => 3)),
          "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-06-20T16:22:14.353+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 4), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 3), "id" => Dict{String,Any}("value" => 3), "description" => "Occupational Disability"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-20T16:22:14.353+00:00")),
        "partner_refs" => Any[
          Dict{String,Any}(
          "rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 1), "description" => "pink"),
          "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-06-20T16:22:14.365+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-20T16:22:14.365+00:00"))])], "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "position" => 2, "description" => "pink"))])

@reactive mutable struct Model <: ReactiveModel
  cs::Dict{String,Any} = cs
  tab::R{String} = ""
  rolesTextPartner::R{Dict{Integer,String}} = Dict{Integer,String}([1 => "Insured Person"])
  rolesTextTariff::R{Dict{Integer,String}} = Dict{Integer,String}([1 => "Death", 2 => "Occupational Disability"])
end


function ui(model)
  page(
    model,
    title="Bitemporal Reactive ContractSection",
    Html.div(id="q-app", style="min-height: 100vh;",
      Html.div(class="q-pa-md",
        card(class="my-card",
          [card_section([Html.div(class="text-h6", "Product Items"),
            ]),
            """
              <q-markup-table>
                <template>
                  <thead>
                    <tr>
                      <th class="text-left">Item</th>
                      <th class="text-right">Description</th>
                    </tr>
                  </thead>
                </template>
                <template>
                  <tbody>
                    <template v-for="(pid,pindex) in cs['product_items']">
                  <tr>
                    <td class="text-left">{{pindex}}</td>
                    <td class="text-right">{{cs['product_items'][pindex]['revision']['description']}}</td>
            """,
            card(class="my-card",
              [card_section([Html.div(class="text-h6", "Tariff Items"),
                ]),
                """,
                        <q-markup-table>
                            <template>
                              <thead>
                                <tr>
                                  <th class="text-left">Item</th>
                                  <th class="text-right">Role</th>
                                </tr>
                              </thead>
                            </template>
                            <template>
                              <tbody>
                                <template v-for="(tid,tindex) in cs['product_items'][pindex]['tariff_items']">
                                <tr>
                                  <td class="text-left">PINDEX {{pindex}} TINDEX {{tindex}}</td>
                                  <td class="text-right"> {{cs.product_items[pindex]['tariff_items'][tindex]['tariff_ref']['rev']['ref_role']['value']}}</td>
                                </tr>
                              </template>
                              </tbody>
                            </template>
                          </q-markup-table>
                """,]),
            """
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