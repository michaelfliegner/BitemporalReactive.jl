I[![CI](https://github.com/actuarial-sciences-for-africa-asa/BitemporalReactive.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/actuarial-sciences-for-africa-asa/BitemporalReactive.jl/actions/workflows/CI.yml)

[![Documentation](https://github.com/actuarial-sciences-for-africa-asa/BitemporalReactive.jl/actions/workflows/GenDocs.yml/badge.svg)](https://github.com/actuarial-sciences-for-africa-asa/BitemporalReactive.jl/actions/workflows/GenDocs.yml)

This is a prototype reactive web app for bitemporal data management based on [a Julia bitemporal data management API](https://github.com/actuarial-sciences-for-africa-asa/BitemporalPostgres.jl) and a UI based on [Stipple](https://github.com/GenieFramework/StippleUI.jl) and [QUASAR (where Stipple did not yet provide a solution, or I didn't find one)](https://quasar.dev/). 

Architecture is [MVVM](https://012.vuejs.org/guide/)

* BitemporalReactive connects the business model to the view model and provides event handling. 
* ContractSectionView defines the view model, the UI elements, and their data bindings.
* LifeInsuranceDataModel - an imported package - provides the business model and logic
* LifeInsuranceProduct - an imported package - provides actuarial computations

![work in progress](docs/src/assets/wip.png) To populate the database use [this notebook](testcreatecontract.ipynb)

Demo: Opening this project in GITPOD using the gitpod Button on the repo page ![gitpod Button on the repo page](docs/src/assets/GitpodButton.PNG)

You get an environment with a running database populated with sample data, the Webapp running and link to open a browser window.
![Port8000Open](docs/src/assets/Port8000open.PNG)

[App in action. In the beginning it is quitedue to just in time compiling](/home/mf/dev/BitemporalReactive.jl/docs/src/assets/BitemporalReactive_20220910.mp4)
