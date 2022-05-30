module Tree
using Stipple, StippleUI
import Stipple.js_methods

@reactive mutable struct Model <: ReactiveModel
  selectedm::R{String} = "Dummy"
  props::R{Vector{Dict{String}}} = t1
end

t1 = [Dict{String,Any}("label" => "Server SatisIIIfied customers", "children" => Any[Dict{String,Any}("label" => "Good food", "icon" => "restaurant_menu", "children" => Any[Dict{String,Any}("label" => "Quality ingredients"), Dict{String,Any}("label" => "Good recipe")]), Dict{String,Any}("label" => "Good service", "icon" => "room_service", "children" => Any[Dict{String,Any}("label" => "Prompt attention"), Dict{String,Any}("label" => "Professional waiter")]), Dict{String,Any}("label" => "Pleasant surroundings", "icon" => "photo", "children" => Any[Dict{String,Any}("label" => "Happy atmosphere"), Dict{String,Any}("label" => "Good table presentation"), Dict{String,Any}("label" => "Pleasing decor")])], "avatar" => "https://cdn.quasar.dev/img/boy-avatar.png")]

js_created(app::Model) = """
   alert('created')
 """
import Stipple.client_data
client_data(m::Model) = client_data(
  selected=Dict{String,Any
  }("__v_isRef" => true,
    "_rawValue" => "Pleasant surroundings",
    "__v_isShallow" => false,
    "_value" => "Pleasant surroundings"),
  ticked=Dict{String,Any
  }("__v_isRef" => true,
    "_rawValue" => Any[
      "Quality ingredients",
      "Good table presentation"
    ],
    "__v_isShallow" => false,
    "_value" => Any[
      "Quality ingredients",
      "Good table presentation"
    ]),
  simple=Any[Dict{String,Any
  }("label" => "client Satisfied customers",
    "children" => Any[Dict{String,Any
      }("label" => "Good food",
        "children" => Any[Dict{String,Any
          }("label" => "Quality ingredients"), Dict{String,Any
          }("label" => "Good recipe")
        ]), Dict{String,Any
      }("label" => "Good service (disabled node)",
        "disabled" => true,
        "children" => Any[Dict{String,Any
          }("label" => "Prompt attention"), Dict{String,Any
          }("label" => "Professional waiter")
        ]), Dict{String,Any
      }("label" => "Pleasant surroundings",
        "children" => Any[Dict{String,Any
          }("label" => "Happy atmosphere"), Dict{String,Any
          }("label" => "Good table presentation"), Dict{String,Any
          }("label" => "Pleasing decor")
        ])
    ])
  ],
  expanded=Dict{String,Any
  }("__v_isRef" => true,
    "_rawValue" => Any[
      "Satisfied customers",
      "Good service (disabled node)",
      "Pleasant surroundings"
    ],
    "__v_isShallow" => false,
    "_value" => Any[
      "Satisfied customers",
      "Good service (disabled node)",
      "Pleasant surroundings"
    ]))

js_methods(::Model) = raw"""
     selectGoodService () {
        if (this.selected.value !== 'Good service') {
          this.selected.value = 'Good service'
        }
        if (this.selected.value == 'Good service') {
          this.selected.value = 'Good food'
        }

      },


      unselectNode () {
        this.selected.value = null
      },
    """

function ui(model)
  page(
    model,
    class="container",
    """
    <div class="q-pa-md q-gutter-sm">
      <div>
        <div class="q-gutter-sm">
          <q-btn size="sm" color="primary" @click="selectGoodService" label="Select 'Good service'"></q-btn>
          <q-btn v-if="selected" size="sm" color="red" @click="unselectNode" label="Unselect node"></q-btn>
        </div>
      </div>
      <q-tree
        :nodes="props"
        default-expand-all
        v-model:selected="selected"
        node-key="label"
      ></q-tree>
    </div>
  </div>
      <div class="q-pa-md q-gutter-sm">
        <div>
          <div class="q-gutter-sm">
            <q-btn size="sm" color="primary" @click="props=simple" label="Select client data"></q-btn>
            <q-btn size="sm" color="primary" @click="selectGoodService" label="Select 'Good service'"></q-btn>
            <q-btn v-if="selected" size="sm" color="red" @click="unselectNode" label="Unselect node" ></q-btn>
          </div>
        </div>
        <q-tree
          :nodes="props"
          default-expand-all
          v-model:selected="this.selected"
          node-key="label"
        ></q-tree>
      </div>
                """)
end

function handlers(model)
  on(model.selectedm) do _
    println("huhu")
    println(model.selectedm[])
    println("haha")
    println(model.props[])
  end
  on(model.props) do _
    println("huhu Props")
    println(model.props[])
  end
  on(model.isready) do _
    model.props = t1
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
  js_methods(model)
  println("model")
  println(model)
  println(js_methods(model))
  routeTree(model)
  Stipple.up()
end

end #module

