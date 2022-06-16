module HTree
using InsuranceContractsController, Stipple, StippleUI
import TimeZones, Stipple.js_methods
using TimeZones

@reactive mutable struct Model <: ReactiveModel
  selected_version::R{String} = ""
  history::R{Vector{Dict{String}}} = Dict{String,Any}("tsdb_validfrom" => "2022-06-08T15:04:14.282+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "ref_entities" => Dict{String,Any}(), "contract_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "description" => ""), "contract_partnerref_revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => nothing), "ref_component" => Dict{String,Any}("value" => 9223372036854775807), "id" => Dict{String,Any}("value" => nothing), "ref_role" => Dict{String,Any}("value" => 9223372036854775807), "description" => ""), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-06-08T15:04:14.282+00:00", "product_items" => Any[])
end

TreeDict = Dict{String,Any}[Dict("label" => "7", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 4, "id" => 7, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 6), "time_committed" => "2022-05-21T17:49:58.742+00:00", "time_valid_asof" => "2015-05-30T20:00:01.001+00:00", "children" => Dict{String,Any}[Dict("label" => "5", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2016, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 506, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "ref_history" => 4, "id" => 5, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 5), "time_committed" => "2022-05-21T17:49:58.506+00:00", "time_valid_asof" => "2016-05-30T20:00:01.001+00:00", "children" => Any[])]), Dict("label" => "8", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2014, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 4, "id" => 8, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "is_committed" => 1, "ref_version" => 4), "time_committed" => "2022-05-21T17:49:58.742+00:00", "time_valid_asof" => "2014-05-30T20:00:01.001+00:00", "children" => Any[])]

function ui(model)
  page(
    model,
    title="Hello Stipple QTree with selectable Nodes",
    [
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
    ],
  )
end

function handlers(model)
  on(model.selected_version) do _
    print("Selected node=")
    println(model.selected_version[])
    bubu = InsuranceContractsController.csection_dict(4, parse(Int, model.selected_version[]))
    println(bubu)
  end

  on(model.isready) do _
    println("ready")
    model.history = TreeDict
    push!(model)
    println("model pushed")
  end
  model
end

function routeTree(model)
  route("/tree") do
    html(ui(model), context=@__MODULE__)
  end
end

function run()
  model = handlers(Stipple.init(Model))
  routeTree(model)
  Stipple.up()
end

end #module

