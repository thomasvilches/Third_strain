
red = 0.0:0.05:0.5
trans = 1.0:0.05:1.5
 
for r in red,tr in trans
    run_param_scen(0.109,10,1,1.0,1.0,1.6,tr,true,r,1,999,2,14)
end
