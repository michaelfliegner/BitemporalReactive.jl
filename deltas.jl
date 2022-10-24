    on(contractsModel.command) do _
        if (contractsModel.command[] != "")
            println("command is " * string(contractsModel.command[]))
            println(contractsModel.cs["revision"]["description"])
            w = Workflow(type_of_entity="Contract",
                ref_history=DbId(9),
                tsw_validfrom=ZonedDateTime(2022, 11, 01, 12, 0, 1, 1, tz"UTC"),
            )
            update_entity!(w)
            try
                previous::Dict{String,Any} = contractsModel.csorig
                current::Dict{String,Any} = contractsModel.cs[]
                println("vor compare")
                deltas = compareModelStateContract(previous, current)
                for delta in deltas
                    println(delta)
                    prev = delta[1]
                    curr = delta[2]
                    update_component!(prev, curr, w)
                end
                contractsModel.command[] = ""
                println("model persisted")
            catch err
                println("compare shief gegangen ")
                @error "ERROR: " exception = (err, catch_backtrace())
            end
        end
    end
    
    
    
    
    contractsModel.cs = cs
    contractsModel.cs["loaded"] = "true"
    contractsModel.csorig = copy(cs)


  cs::R{Dict{String,Any}} = Dict{String,Any}("loaded" => "false")
  csorig::Dict{String,Any} = Dict{String,Any}("loaded" => "false")



            btn("Show Product Items", outline=true, @click("show_product_items=!show_product_items")),
        """
        <div class="q-pa-md">
          <div class="q-gutter-md" style="max-width: 300px">
            <q-field label="Standard" stack-label>
              <template v-slot:control>
                <div class="self-center full-width no-outline" tabindex="0">{{cs['revision']['ref_invalidfrom']}}</div>
              </template>
            </q-field>
            <q-field label="Standard" stack-label>
              <template v-slot:control>
                <div class="self-center full-width no-outline" tabindex="0">{{selected_contract_idx}}</div>
              </template>
            </q-field>
            <q-input v-model="cs['revision']['description']" label="Description" placeholder="Placeholder" hint="With placeholder" :dense="dense"></q-input></td>
          </div>
        </div>
