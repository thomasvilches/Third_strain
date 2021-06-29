
red = 0.0:0.05:0.5
trans = 1.5:0.05:2.0
 
#### on day 999, we allow people to "go nuts"... if you dont want that, just set it to 999
for r in red,tr in trans
    run_param_scen(0.109,10,1,1.0,1.0,1.1,tr,r,1,999,2,14)
end


for r in red,tr in trans
    run_param_scen(0.109,10,1,1.0,1.0,1.3,tr,r,2,999,2,14)
end

for r in red,tr in trans
    run_param_scen(0.109,10,1,1.0,1.0,1.5,tr,r,3,999,2,14)
end
#= 
#### on day 307, we allow people to "go nuts"... if you dont want that, just set it to 999
for r in red,tr in trans
    run_param_scen(0.109,10,1,1.0,1.0,tr,true,"pfizer",r,3,307,2,14)
end =#
