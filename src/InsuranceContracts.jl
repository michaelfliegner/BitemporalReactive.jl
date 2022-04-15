module InsuranceContracts
import BitemporalPostgres
import SearchLight: DbId
import Base: @kwdef
export Contract, ContractRevision, ContractPartnerRef, ContractPartnerRefRevision, ProductItem, ProductItemRevision, ProductItemTariffRef, ProductItemTariffRefRevision, ProductItemPartnerRef, ProductItemPartnerRefRevision
using BitemporalPostgres

"""
Contract

  a contract component of a bitemporal entity

"""
@kwdef mutable struct Contract <: BitemporalPostgres.Component
  id::DbId = DbId()
  ref_history :: DbId = InfinityKey  
  ref_version :: DbId = InfinityKey  
end

"""
ContractRevision

  a revision of a contract component

"""
@kwdef mutable struct ContractRevision <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component :: DbId = InfinityKey   
  ref_validfrom::DbId = InfinityKey 
  ref_invalidfrom::DbId = InfinityKey 
  description::String = ""
end

"""
ProductItem

  a productitem component of a contract component

"""
@kwdef mutable struct ProductItem <: BitemporalPostgres.SubComponent
  id::DbId = DbId()
  ref_history :: DbId = InfinityKey  
  ref_version :: DbId = InfinityKey  
  ref_super :: DbId = InfinityKey  
end

"""
ProductItemRevision

  a revision of a productitem component

"""
@kwdef mutable struct ProductItemRevision <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component :: DbId = InfinityKey
  position::Integer = 0 :: Int64
  ref_validfrom::DbId = InfinityKey 
  ref_invalidfrom::DbId = InfinityKey 
  description::String = ""
end


"""
ContractPartnerRef

  a partner reference of a contract component, i.e. policy holder, premium payer

"""
@kwdef mutable struct ContractPartnerRef <: BitemporalPostgres.SubComponent
  id::DbId = DbId()
  ref_history :: DbId = InfinityKey  
  ref_version :: DbId = InfinityKey 
  ref_super :: DbId = InfinityKey  
end

"""
ContractPartnerRefRevision

  a revision of a contract's partner reference

"""
@kwdef mutable struct ContractPartnerRefRevision <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component :: DbId = InfinityKey   
  ref_validfrom::DbId = InfinityKey 
  ref_invalidfrom::DbId = InfinityKey 
  description::String = ""
  ref_partner::DbId = InfinityKey 
end


"""
ProductItemTariffRef

  a reference to a tariff of a productitem

"""
@kwdef mutable struct ProductItemTariffRef <: BitemporalPostgres.SubComponent
  id::DbId = DbId()
  ref_history :: DbId = InfinityKey  
  ref_version :: DbId = InfinityKey 
  ref_super :: DbId = InfinityKey  
end

"""
ProductItemTariffRefRevision

  a revision of a productitem's reference to a tariff

"""
@kwdef mutable struct ProductItemTariffRefRevision  <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component :: DbId = InfinityKey   
  ref_validfrom::DbId = InfinityKey 
  ref_invalidfrom::DbId = InfinityKey 
  description::String = ""
  ref_tariff::DbId = InfinityKey 
end


"""
ProductItemPartnerRef

  a reference to a partner of a productitem, i.e. insured person

"""
@kwdef mutable struct ProductItemPartnerRef <: BitemporalPostgres.SubComponent
  id::DbId = DbId()
  ref_history :: DbId = InfinityKey  
  ref_version :: DbId = InfinityKey 
  ref_super :: DbId = InfinityKey  
end

"""
ProductItemPartnerRefRevision

  a revision of a productItem's partner reference

"""
@kwdef mutable struct ProductItemPartnerRefRevision  <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component :: DbId = InfinityKey   
  ref_validfrom::DbId = InfinityKey 
  ref_invalidfrom::DbId = InfinityKey 
  description::String = ""
  ref_partner::DbId = InfinityKey 
end

end
