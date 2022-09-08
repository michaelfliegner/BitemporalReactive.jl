module HistoryView
using Stipple, Stipple.Html, StippleUI
export renderhforest


"""
renderhforest
Display the tree of versions, history tab
"""
function renderhforest(model)
    quasar(:tree, ref="tree", var"node-key"="label", var"children-key"="children", nodes=:histo, var"default-expand-all"=false,
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
              <q-field label="valid as of" stack-label outlined >
                <template v-slot:control>
                  <div class="self-center full-width no-outline" tabindex="4">{{prop.node.time_valid_asof}}</div>
                </template>
              </q-field> 
              <q-field label="committed" stack-label outlined >
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
end

end