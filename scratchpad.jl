
using BitemporalPostgres, SearchLight, SearchLightPostgreSQL, InsuranceContractsController

SearchLight.Configuration.load() |> SearchLight.connect

let th = 2, vc = find(ValidityInterval, SQLWhereExpression("ref_history = BIGINT ? and ref_version = BIGINT ?", DbId(4), DbId(6)))[1],
  validfromdb = vc.tsdb_validfrom, validfromworld = vc.tsworld_validfrom,
  vt = find(ValidityInterval, SQLWhereExpression("ref_history = BIGINT ? and tsrworld @> TIMESTAMPTZ ? and tsrdb @> TIMESTAMPTZ ?", DbId(th), validfromworld, validfromdb))[1]

  ts = InsuranceContractsController.tsection(vt.ref_history.value, vt.ref_version.value)
  println(ts)
end

function recstr2dct(s, fn)
  f = getfield(s, fn)
  if (isprimitivetype(typeof(f)))
    println("primitive " * string(f))
    f
  else
    println("complex " * string(f))
    if (isa(f, Array))
      println("array " * string(f))
      map(str2dct, f)
    else
      println("complex " * string(f))
      str2dct(f)
    end
  end
end

function str2dct(s)
  res = Dict(string(fn) => getfield(s, fn) for fn ∈ fieldnames(typeof(s)))
  if (haskey(res, "product_items"))
    res["product_items"] = map(res["product_items"]) do pi
      str2dct(pi)
    end
  end
  res
end

str2dct(csection(4, 6))
