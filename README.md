# COVID-19 Agent Based Model

## Model details:
A stochastic, age-stratified agent-based computational model for the transmission dynamics of COVID-19. The computational model simulates autonomous agents (representing individuals in a human population) and their interactions within a constrained virtual environment. Agents follow the natural history of disease, including epidemiological stages of susceptible, infected and incubating, asymptomatic, presymptomatic, and symptomatic with either mild, severe, or critical illness, recovered, and dead.

Model features include:

- Age structured with realistic contact dynamics
- Asymptomatic, Presymptomatic transmission
- Isolation of mild/severe cases
- Isolation of symptomatic individuals
- The average number of daily contacts can be changed to fit to data
- Four strains, corresponding to when they were identified in the United States

## How to download and run

Prerequisites: Julia 1.0.4, access to a cluster or a high-compute workstation. 

1) Download or **clone** the entire repository and navigate to the folder.
2) Launch Julia and cctivate the project by: `julia --project=.`. Double check if the project environment is set correct by entering `Pkg` mode by typing `]`. 
3) Instantiate the project by typing `] instantiate`.
4) Include the file *simulations_cluster.jl* using the command
```
include("simulations_cluster.jl")
```
Note, that in our version of this file we connect to our compute cluster using the `Slurm` cluster software. The user may want to simply use `addprocs` to run locally on their computer, run everything in a serial manner (takes long), or use a compute cluster with the help of `ClusterManagers`. The simulations/scenarios can be launched by executing 

```
run_param_scen_cal(b,h,init1,init2,init3,init4,init5,init6,time2,time3,time4,time5,time6,vaccination,r,index,status,days_after,v1,v2,modeltime,vaccination,type,proportion)
```

to run the scenarios. The arguments are

- b: Float64 \- probability of transmission for presymptomatic cases.
- h: Int64 \- previous herd immunity in the population (either 5, 10, 20, 30 or 50%).
- init: Int64 \- number of initial infected for third strain.
- fm and fs: Float64 \- probability of isolation for symptomatic cases (mild and severe).
- vaccination: Bool \- apply vaccination?.
- r: Float64 \- vaccine effectiveness reduction for third strain.
- index: Int64 \- index to differ different files (see *Model output*).
- status: Integer \- On April 3, vaccinated individuals are allowed to go back to the normal number of contacts. This argument controls if they need to have first or second dosis (set it to '1' or '2'). If you do not want to allow them to go back to normal, set it to '3'.
- days_after: Int64 \- how many days after the desire dosis the individuals are allowed to go back to normal behavior.
- v1: vector with changes in contact pattern.
- v2: vector when the change (v1) will happen.
- modeltime: simulated time (number of days).
- type: either "baselone" or "fast". "fast" makes multiplies the vaccination rate by "proportion".
- proportion: if "fast", the vaccination rate is multiplied by this number.

One can find the state of interest in "scen_TXnFL.jl".

```
include("scen_TXFL.jl")
```

## Model output

***First, make sure that the address 'main_folder' inside function 'create_folder' in file [simulations_cluster](simulations_cluster.jl) points to a valid directory in your system.*** 

The model is parameterized to fit to data from US from Octuber to May. The [incidence data](cases_us.csv) was taken from [NY times](https://github.com/nytimes/covid-19-data/). The function 'run_param_scen_cal' will generate a folder, inside the pointed directory, named **results\__b_\_herd\_immu\__h_\__vaccine\__index_\__state_** in which all the ***variables*** are the ones cited in the previous section. ***b*** is the probability, but the '.' is replaced by '\_'. If you ran the ***scen.jl*** file.

Inside this folder, one will find different data files. The most important ones are the ones named
**simlevel_\*\_inc\_\*\*.dat** in which

- \* stands for **lat**, **lat2**, **lat3**, **lat4**, **hos**, **hos2**, **hos3**, **hos4**, **icu**, **icu2**, **icu3**, **icu4**, **ded** , **ded2**, **ded3**, **ded4**, and so on. Which are the number of infections, Non-ICU hospitalizations, ICU hospitalizations and deaths generated by each one of the strains. It may be necessary to scale the number of hospitalizations and deaths by the reported ones when analyzing the data.


The files contain a *modeltime* x *number of simulations* (by default 318x500) matrix. However, the first row is the heading of the file and the first column of it is the timeline. The other columns are the incidence of a given outcome in the given day of simulation.
