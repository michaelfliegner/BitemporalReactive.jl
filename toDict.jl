h = Dict{String,Any}[Dict("label" => "8", "interval" => Dict{String,Any}("tsworld_validfrom" => ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => ZonedDateTime(2022, 6, 23, 16, 36, 43, 743, tz"UTC"), "tsdb_invalidfrom" => ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 6, "id" => 9, "tsworld_invalidfrom" => ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 8), "time_committed" => "2022-06-23T16:36:43.743+00:00", "time_valid_asof" => "2015-05-30T20:00:01.001+00:00", "children" => Dict{String,Any}[Dict("label" => "7", "interval" => Dict{String,Any}("tsworld_validfrom" => ZonedDateTime(2016, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => ZonedDateTime(2022, 6, 23, 16, 36, 43, 499, tz"UTC"), "tsdb_invalidfrom" => ZonedDateTime(2022, 6, 23, 16, 36, 43, 743, tz"UTC"), "ref_history" => 6, "id" => 7, "tsworld_invalidfrom" => ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "is_committed" => 1, "ref_version" => 7), "time_committed" => "2022-06-23T16:36:43.499+00:00", "time_valid_asof" => "2016-05-30T20:00:01.001+00:00", "children" => Any[])]), Dict("label" => "6", "interval" => Dict{String,Any}("tsworld_validfrom" => ZonedDateTime(2014, 5, 30, 20, 0, 1, 1, tz"UTC"), "tsdb_validfrom" => ZonedDateTime(2022, 6, 23, 16, 36, 43, 743, tz"UTC"), "tsdb_invalidfrom" => ZonedDateTime(2038, 1, 19, 3, 14, 6, 999, tz"UTC"), "ref_history" => 6, "id" => 10, "tsworld_invalidfrom" => ZonedDateTime(2015, 5, 30, 20, 0, 1, 1, tz"UTC"), "is_committed" => 1, "ref_version" => 6), "time_committed" => "2022-06-23T16:36:43.743+00:00", "time_valid_asof" => "2014-05-30T20:00:01.001+00:00", "children" => Any[])]

function findnode(ns::Vector{Dict{String,Any}}, lbl::String)
    for n in ns
        if (n["label"] == lbl)
            n
        else
            if (length(n["children"]) > 0)
                n0 = findnode(n["children"], lbl)
                if (typeof(n0) != Nothing)
                    n0
                else
                    Nothing
                end
            end
        end
    end

end

function fn(ns::Vector{Dict{String,Any}}, lbl::String)
    for n in ns
        if (n["label"] == lbl)
            return (n)
        else
            if (length(n["children"]) > 0)
                m = fn(n["children"], lbl)
                if (typeof(m) != Nothing)
                    return m
                end
            end
        end
    end
end