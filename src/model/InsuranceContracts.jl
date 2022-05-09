module InsuranceContracts
import BitemporalPostgres
import SearchLight: DbId, AbstractModel
import Base: @kwdef
export Contract, ContractRevision, ContractPartnerRole, ContractPartnerRef, ContractPartnerRefRevision, ProductItem, ProductItemTariffRole, ProductItemRevision, ProductItemTariffRef, ProductItemTariffRefRevision, ProductItemPartnerRole, ProductItemPartnerRef, ProductItemPartnerRefRevision
using BitemporalPostgres

"""
Contract

  a contract component of a bitemporal entity

"""
@kwdef mutable struct Contract <: BitemporalPostgres.Component
  id::DbId = DbId()
  ref_history::DbId = InfinityKey
  ref_version::DbId = InfinityKey
end

"""
ContractRevision

  a revision of a contract component

"""
@kwdef mutable struct ContractRevision <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component::DbId = InfinityKey
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
  ref_history::DbId = InfinityKey
  ref_version::DbId = InfinityKey
  ref_super::DbId = InfinityKey
end

"""
ProductItemRevision

  a revision of a productitem component

"""
@kwdef mutable struct ProductItemRevision <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component::DbId = InfinityKey
  position::Integer = 0::Int64
  ref_validfrom::DbId = InfinityKey
  ref_invalidfrom::DbId = InfinityKey
  description::String = ""
end

"""
Role

  role of a relationship 

"""
abstract type Role <: AbstractModel end

function get_id(role::Role)::DbId
  role.id
end
function get_domain(role::Role)::DbId
  role.domain
end
function get_value(role::Role)::DbId
  role.value
end


"""
ContractPartnerRole

  role e.g. policy holder or premium payer

"""
@kwdef mutable struct ContractPartnerRole <: Role
  id::DbId = DbId()
  domain::String = "ContractPartner"
  value::String = ""
end

"""
ContractPartnerRef

  a partner reference of a contract component, i.e. policy holder, premium payer

"""
@kwdef mutable struct ContractPartnerRef <: BitemporalPostgres.SubComponent
  id::DbId = DbId()
  ref_history::DbId = InfinityKey
  ref_version::DbId = InfinityKey
  ref_super::DbId = InfinityKey
end

"""
ContractPartnerRefRevision

  a revision of a contract's partner reference

"""
@kwdef mutable struct ContractPartnerRefRevision <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component::DbId = InfinityKey
  ref_role::DbId = InfinityKey
  ref_validfrom::DbId = InfinityKey
  ref_invalidfrom::DbId = InfinityKey
  description::String = ""
  ref_partner::DbId = DbId()
end

"""
ProductItemTariffRole

  role e.g. main or supplemental risk like life and occupational disabilty

"""
@kwdef mutable struct ProductItemTariffRole <: Role
  id::DbId = DbId()
  domain::String = "ProductItemTariff"
  value::String = ""
end

"""
ProductItemTariffRef

  a reference to a tariff of a productitem

"""
@kwdef mutable struct ProductItemTariffRef <: BitemporalPostgres.SubComponent
  id::DbId = DbId()
  ref_history::DbId = InfinityKey
  ref_version::DbId = InfinityKey
  ref_super::DbId = InfinityKey
end

"""
ProductItemTariffRefRevision

  a revision of a productitem's reference to a tariff

"""
@kwdef mutable struct ProductItemTariffRefRevision <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component::DbId = InfinityKey
  ref_role::DbId = InfinityKey
  ref_validfrom::DbId = InfinityKey
  ref_invalidfrom::DbId = InfinityKey
  description::String = ""
  ref_tariff::DbId = DbId()
end

"""
ProductItemPartnerRole

  role e.g. main or supplemental risk like life and occupational disabilty

"""
@kwdef mutable struct ProductItemPartnerRole <: Role
  id::DbId = DbId()
  domain::String = "ProductItemPartner"
  value::String = ""
end

"""
ProductItemPartnerRef

  a reference to a partner of a productitem, i.e. insured person

"""
@kwdef mutable struct ProductItemPartnerRef <: BitemporalPostgres.SubComponent
  id::DbId = DbId()
  ref_history::DbId = InfinityKey
  ref_version::DbId = InfinityKey
  ref_super::DbId = InfinityKey
end

"""
ProductItemPartnerRefRevision

  a revision of a productItem's partner reference

"""
@kwdef mutable struct ProductItemPartnerRefRevision <: BitemporalPostgres.ComponentRevision
  id::DbId = DbId()
  ref_component::DbId = InfinityKey
  ref_role::DbId = InfinityKey
  ref_validfrom::DbId = InfinityKey
  ref_invalidfrom::DbId = InfinityKey
  description::String = ""
  ref_partner::DbId = DbId()
end

end
