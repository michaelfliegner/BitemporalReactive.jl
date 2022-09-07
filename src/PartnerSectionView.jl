module PartnerSectionView
using Stipple

@reactive mutable struct PartnersModel <: ReactiveModel
  ps::R{Dict{String,Any}} = Dict{String,Any}("tsdb_validfrom" => "2022-09-07T09:00:02.844+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "date_of_birth" => "", "ref_component" => Dict{String,Any}("value" => 0), "id" => Dict{String,Any}("value" => 0), "description" => ""), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-09-07T09:00:02.844+00:00")
end

function ui(partnersModel::PartnersModel)
  page(
    partnersModel,
    class="container",
    [
      """
      <q-markup-table dark class="bg-deep-purple-5 text-white">
                      <template>
                        <thead>
                          <tr>
                            <th class="text-left text-white">Partner Id</th>
                            <th class="text-left text-white">Partner Description</th>
                            <th class="text-left text-white">Partner Date of Birth</th>
                          </tr>
                        </thead>
                      </template>
                      <template>
                        <tbody>
                          <tr>
                          <td class="text-left text-white">{{ps['revision']['ref_component']['value']}}</td>
                          <td class="text-left text-white">{{ps['revision']['description']}}</td>
                          <td class="text-left text-white">{{ps['revision']['date_of_birth']}}</td>
                          </tr>
                        </tbody>
                       </template>
                    </q-markup-table>
      """]
  )
end

# partnersModel = PartnersModel |> init
# 
# route("/PartnerSection") do
# 
#   html(ui(partnersModel), context=@__MODULE__)
# end
# 
# up()

end