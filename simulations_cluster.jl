using Distributed
using Base.Filesystem
using DataFrames
using CSV
using Query
using Statistics
using UnicodePlots
using ClusterManagers
using Dates
using DelimitedFiles

## load the packages by covid19abm

#using covid19abm

#addprocs(2, exeflags="--project=.")


#@everywhere using covid19abm

addprocs(SlurmManager(500), N=17, topology=:master_worker, exeflags="--project=.")
@everywhere using Parameters, Distributions, StatsBase, StaticArrays, Random, Match, DataFrames
@everywhere include("covid19abm.jl")
@everywhere const cv=covid19abm


function run(myp::cv.ModelParameters, nsims=1000, folderprefix="./")
    println("starting $nsims simulations...\nsave folder set to $(folderprefix)")
    dump(myp)
   
    # will return 6 dataframes. 1 total, 4 age-specific 
    cdr = pmap(1:nsims) do x                 
            cv.runsim(x, myp)
    end      

    println("simulations finished")
    println("total size of simulation dataframes: $(Base.summarysize(cdr))")
    ## write the infectors     

    ## write contact numbers
    #writedlm("$(folderprefix)/ctnumbers.dat", [cdr[i].ct_numbers for i = 1:nsims])    
    ## stack the sims together
    allag = vcat([cdr[i].a  for i = 1:nsims]...)
    ag1 = vcat([cdr[i].g1 for i = 1:nsims]...)
    ag2 = vcat([cdr[i].g2 for i = 1:nsims]...)
    ag3 = vcat([cdr[i].g3 for i = 1:nsims]...)
    ag4 = vcat([cdr[i].g4 for i = 1:nsims]...)
    ag5 = vcat([cdr[i].g5 for i = 1:nsims]...)
    ag6 = vcat([cdr[i].g6 for i = 1:nsims]...)
    mydfs = Dict("all" => allag, "ag1" => ag1, "ag2" => ag2, "ag3" => ag3, "ag4" => ag4, "ag5" => ag5, "ag6" => ag6)
    #mydfs = Dict("all" => allag)
    
    ## save at the simulation and time level
    ## to ignore for now: miso, iiso, mild 
    #c1 = Symbol.((:LAT, :ASYMP, :INF, :PRE, :MILD,:IISO, :HOS, :ICU, :DED), :_INC)
    #c2 = Symbol.((:LAT, :ASYMP, :INF, :PRE, :MILD,:IISO, :HOS, :ICU, :DED), :_PREV)
    
    c1 = Symbol.((:LAT, :HOS, :ICU, :DED,:LAT2, :HOS2, :ICU2, :DED2,:LAT3, :HOS3, :ICU3, :DED3,:LAT4, :HOS4, :ICU4, :DED4,:LAT5, :HOS5, :ICU5, :DED5), :_INC)
    #c2 = Symbol.((:LAT, :HOS, :ICU, :DED,:LAT2, :HOS2, :ICU2, :DED2), :_PREV)
    for (k, df) in mydfs
        println("saving dataframe sim level: $k")
        # simulation level, save file per health status, per age group
        #for c in vcat(c1..., c2...)
        for c in vcat(c1...)
        #for c in vcat(c2...)
            udf = unstack(df, :time, :sim, c) 
            fn = string("$(folderprefix)/simlevel_", lowercase(string(c)), "_", k, ".dat")
            CSV.write(fn, udf)
        end
        println("saving dataframe time level: $k")
        # time level, save file per age group
        #yaf = compute_yearly_average(df)       
        #fn = string("$(folderprefix)/timelevel_", k, ".dat")   
        #CSV.write(fn, yaf)       
    end
    
   
    R01 = [cdr[i].R01 for i=1:nsims]
    R02 = [cdr[i].R02 for i=1:nsims]
    writedlm(string(folderprefix,"/R01.dat"),R01)
    writedlm(string(folderprefix,"/R02.dat"),R02)
    
    writedlm(string(folderprefix,"/init_iso.dat"),[cdr[i].iniiso for i=1:nsims])

    return mydfs
end


function compute_yearly_average(df)
    ya = df |> @groupby(_.time) |> @map({time=key(_), cnt=length(_),
              sus_prev=mean(_.SUS_PREV), 
              lat_prev=mean(_.LAT_PREV), 
              pre_prev=mean(_.PRE_PREV), 
              asymp_prev=mean(_.ASYMP_PREV), 
              mild_prev=mean(_.MILD_PREV), 
              miso_prev=mean(_.MISO_PREV), 
              inf_prev=mean(_.INF_PREV), 
              iiso_prev=mean(_.IISO_PREV), 
              hos_prev=mean(_.HOS_PREV), 
              icu_prev=mean(_.ICU_PREV), 
              rec_prev=mean(_.REC_PREV), 
              ded_prev=mean(_.DED_PREV), 
              sus_inc=mean(_.SUS_INC),
              lat_inc=mean(_.LAT_INC), 
              pre_inc=mean(_.PRE_INC), 
              asymp_inc=mean(_.ASYMP_INC), 
              mild_inc=mean(_.MILD_INC), 
              miso_inc=mean(_.MISO_INC), 
              inf_inc=mean(_.INF_INC),
              iiso_inc=mean(_.IISO_INC),
              hos_inc=mean(_.HOS_INC),
              icu_inc=mean(_.ICU_INC),
              rec_inc=mean(_.REC_INC),
              ded_inc=mean(_.DED_INC)
              }) |> DataFrame
    return ya
end

function _calibrate(nsims, myp::cv.ModelParameters)
    myp.calibration != true && error("calibration parameter not turned on")
    vals = zeros(Int64, nsims)
    println("calibrating with beta: $(myp.β), total sims: $nsims, province: $(myp.prov)")
    println("calibration parameters:")
    dump(myp)
    cdr = pmap(1:nsims) do i 
        h,hh = cv.main(myp,i) ## gets the entire model. 
        val = sum(cv._get_column_incidence(h, covid19abm.LAT))            
        return val
    end
    return mean(cdr), std(cdr)
end

function calibrate(beta, nsims, herdi = 0, cali2 = false, fs = 0.0, prov=:usa, init_inf=1, size=10000)
    myp = cv.ModelParameters() # set up default parameters 
    myp.β = beta
    myp.prov = prov
    myp.popsize = size
    myp.modeltime = 30
    myp.calibration = true
    myp.calibration2 = cali2
    myp.fsevere = fs
    myp.fmild = fs
    myp.initialinf = init_inf
    myp.herd = herdi
    m, sd = _calibrate(nsims, myp)
    println("mean R0: $(m) with std: $(sd)")
    myp.calibration = false       
    return m
end

function calibrate_robustness(beta, reps, prov=:usa)
    #[:ontario, :alberta, :bc, :manitoba, :newbruns, :newfdland, :nwterrito, :novasco, :nunavut, :pei, :quebec, :saskat, :yukon]
    # once a beta is found based on nsims simulations, 
    # see how robust it is. run calibration with same beta 100 times 
    # to see the variation in R0 produced. 
    #nsims = [1000]
    means = zeros(Float64, reps)
    #for (i, ns) in enumerate(nsims)
    cd = map(1:reps) do x 
        println("iter: $x")
        mval = calibrate(beta,10000)         
        return mval
    end
    
    #end
    # for i in 2:nworkers()
    #     ## mf defined as: @everywhere mg() = covid19abm.p.β     
    #     rpr = remotecall_fetch(mf,  i+1).prov
    #     rpr != prov && error("province didn't get set in the remote workers")
    # end
    return cd
end

function create_folder(ip::cv.ModelParameters,vac="none")
    
    
    
    
    #RF = string("heatmap/results_prob_","$(replace(string(ip.β), "." => "_"))","_vac_","$(replace(string(ip.vaccine_ef), "." => "_"))","_herd_immu_","$(ip.herd)","_$strategy","cov_$(replace(string(ip.cov_val)))") ## 
    main_folder = "/data/thomas-covid/NYC_July"
    #main_folder = "."
   
    RF = string(main_folder,"/results_prob_","$(replace(string(ip.β), "." => "_"))","_herd_immu_","$(ip.herd)","_$vac","_$(ip.fourth_strain_trans)_$(ip.strain_ef_red3)_$(ip.file_index)") ##  
   
    if !Base.Filesystem.isdir(RF)
        Base.Filesystem.mkpath(RF)
    end
    return RF
end

function run_param_scen(b,h_i = 0,ic=1,fs=0.0,fm=0.0,strain3_trans=1.5,strain4_trans=1.6,vaccine = true,red = 0.0,index = 0,when_= 999,dosis=3,ta = 999,nsims=500)
    
    #b = bd[h_i]
    #ic = init_con[h_i]
    @everywhere ip = cv.ModelParameters(β=$b,fsevere = $fs,fmild = $fm,vaccinating = $vaccine,
    herd = $(h_i),start_several_inf=true,initialinf3=$ic,
    ins_sec_strain = true,third_strain_trans=$strain3_trans,
    fourth_strain_trans=$strain4_trans, strain_ef_red3 = $red,strain_ef_red4 = $red,
    time_back_to_normal = $when_,status_relax = $dosis, relax_after = $ta,file_index = $index)

    folder = create_folder(ip,"pfizer")

    #println("$v_e $(ip.vaccine_ef)")
    run(ip,nsims,folder)
   
end


function run_param_scen_cal(b,h_i = 0,ic1=1,ic2=1,ic3=1,ic4=1,strain2_trans=1.5,strain3_trans=1.5,strain4_trans=1.6,red = 0.0,index = 0,when_= 999,dosis=3,ta = 999,rc=[0.0],dc=[0],mt=500,nsims=500)
    
       
    #b = bd[h_i]
    #ic = init_con[h_i]
    @everywhere ip = cv.ModelParameters(β=$b,fsevere = 1.0,fmild = 1.0,vaccinating = true,
    herd = $(h_i),start_several_inf=true,initialinf3=$ic3,initialinf=$ic1,initialinf2=$ic2,initialinf4=$ic4,
    ins_sec_strain = true,third_strain_trans=$strain3_trans,sec_strain_trans=$strain2_trans,
    fourth_strain_trans=$strain4_trans, strain_ef_red3 = $red,strain_ef_red4 = $red,
    time_back_to_normal = $when_,status_relax = $dosis, relax_after = $ta,file_index = $index,
    modeltime=$mt,
    time_change_contact = $dc,
    change_rate_values = $rc)

    folder = create_folder(ip,"pfizer")

    #println("$v_e $(ip.vaccine_ef)")
    run(ip,nsims,folder)
   
end