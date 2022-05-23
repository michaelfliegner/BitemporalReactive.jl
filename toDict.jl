function mkhdict(
    hid::DbId,
    tsdb_invalidfrom::ZonedDateTime,
    tsworld_validfrom::ZonedDateTime,
    tsworld_invalidfrom::ZonedDateTime,
)::Dict{String,Any}
    map(
        i::ValidityInterval -> Dict{String,Any}(
            "interval" => i,
            "shadowed" => mkforest(hid, i.tsdb_validfrom, i.tsworld_validfrom, i.tsworld_invalidfrom),
        ),
        find(
            ValidityInterval,
            SQLWhereExpression(
                "ref_history=? AND  upper(tsrdb)=? AND tstzrange(?,?) * tsrworld = tsrworld",
                hid,
                tsdb_invalidfrom,
                tsworld_validfrom,
                tsworld_invalidfrom,
            ),
        ),
    )
end