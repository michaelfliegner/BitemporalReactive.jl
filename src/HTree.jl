module HTree
using Stipple, StippleUI
import TimeZones, Stipple.js_methods
using TimeZones

@reactive mutable struct Model <: ReactiveModel
  selectedm::R{String} = ""
  props::R{Vector{Dict{String}}} = TreeDict
end

TreeDict = Dict{String,Any}[Dict("label" => "7", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 4, "id" => 7, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 6), "children" => Dict{String,Any}[Dict("label" => "5", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2016, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 506, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "ref_history" => 4, "id" => 5, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 5), "children" => Any[])]), Dict("label" => "8", "interval" => Dict{String,Any}("tsworld_validfrom" => TimeZones.ZonedDateTime(2014, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => TimeZones.ZonedDateTime(2022, 5, 21, 17, 49, 58, 742, tz"UTC"), "tsdb_invalidfrom" => TimeZones.ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 4, "id" => 8, "tsworld_invalidfrom" => TimeZones.ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "is_committed" => 1, "ref_version" => 4), "children" => Any[])]

js_methods(::Model) = raw"""
    selectNode (target) {
      alert(target)
      alert(this.$refs.tree.getNodeByKey(target).label)
      alert(this.selectm)
    }
  """


function ui(model)
  page(
    model,
    title="Hello Stipple QTree with selectable Nodes",
    [
      quasar(:tree, ref="tree", var"node-key"="label", var"children-key"="children", nodes=:props, var"default-expand-all"=true,
        var"selected"=:selectedm, var"@update:selected"="selectNode",
        """
        <template v-slot:default-header="prop">
        <div class="row items-center">
          <div v-if="prop.node.icon">
          <q-icon :name="prop.node.icon" size="28px" class="q-mr-sm" />
          </div>
          <div class="text-weight-bold text-primary">{{ prop.node.label }}</div>
        </div>
      </template>

      <template v-slot:default-body="prop">
        <div v-if="prop.node.children">
          <span class="text-weight-bold">{{ prop.node.children }}
        </div>
        <span v-else class="text-weight-light text-black">no children</span>
      </template>
        """)
    ],
  )
end

function handlers(model)
  on(model.selectedm) do _
    print("Selected node=")
    println(model.selectedm[])
  end

  on(model.isready) do _
    println("ready")
    model.props = TreeDict
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

