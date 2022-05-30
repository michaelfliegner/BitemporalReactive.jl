module QTree
using Stipple, StippleUI
import Stipple.js_methods

@reactive mutable struct Model <: ReactiveModel
  selectedm::R{String} = "Good food"
  props::R{Vector{Dict{String}}} = TreeDict
end

TreeDict = [Dict{String,Any}("label" => "Satisfied customers", "children" => Any[Dict{String,Any}("label" => "Good food", "icon" => "restaurant_menu", "children" => Any[Dict{String,Any}("label" => "Quality ingredients"), Dict{String,Any}("label" => "Good recipe")]), Dict{String,Any}("label" => "Good service", "icon" => "room_service", "children" => Any[Dict{String,Any}("label" => "Prompt attention"), Dict{String,Any}("label" => "Professional waiter")]), Dict{String,Any}("label" => "Pleasant surroundings", "icon" => "photo", "children" => Any[Dict{String,Any}("label" => "Happy atmosphere"), Dict{String,Any}("label" => "Good table presentation"), Dict{String,Any}("label" => "Pleasing decor")])], "avatar" => "https://cdn.quasar.dev/img/boy-avatar.png")]
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
      quasar(:tree, ref="tree", var"node-key"="label", nodes=:props, var"default-expand-all"=true,
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
    model.props = TreeDict
    push!(model)
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

