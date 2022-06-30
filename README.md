[![CI](https://github.com/michaelfliegner/BitemporalReactive.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/michaelfliegner/BitemporalReactive.jl/actions/workflows/CI.yml)

[![Documentation](https://github.com/michaelfliegner/BitemporalReactive.jl/actions/workflows/Documentation.yml/badge.svg)](https://github.com/michaelfliegner/BitemporalReactive.jl/actions/workflows/Documentation.yml)

This is a prototype reactive webapp for bitemporal data management based on [a Julia bitemporal data management API](https://github.com/michaelfliegner/BitemporalPostgres.jl) and a UI based on [Stipple](https://github.com/GenieFramework/StippleUI.jl) and [QUASAR (where Stipple did not yet provide a solution, or I didn't find one)](https://quasar.dev/) 

[The Data Model of this prototype](https://github.com/michaelfliegner/LifeInsuranceDataModel.jl/blob/main/src/LifeInsuranceDataModel.jl) is - as of now - all about versioning of entities and relationships for a Life Insurance app - domain specific attributes will be added when calculations will come into play.
Features are: 
- populating the database 
- displaying contract versions and history

![UML Model](docs/src/BitemporalModel.uxf.png)

  