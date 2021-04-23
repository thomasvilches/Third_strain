
red = 0.2:0.05:0.8
trans = 1.0:0.05:1.5

#### on day 307, we allow people to "go nuts"... if you dont want that, just set it to 999
for r in red,tr in trans
    run_param_scen(0.109,10,1,1.0,1.0,tr,true,"moderna",r,0,307,1,14)
end