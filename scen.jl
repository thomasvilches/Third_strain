
red = 0.0:0.05:0.5
trans = 1.0:0.05:1.5
 
for r in red,tr in trans
    run_param_scen(0.109,10,1,1.0,1.0,1.6,tr,true,r,1,999,2,14)
end

#= 
v1 = [1;map(y->47+y,0:(5));map(y->81+y,0:(5));map(y->93+y,0:4);map(y->111+y,0:8);map(y->125+y,0:12)]
v2 = [1;map(y->1.0+0.01*y,1:6);map(y->1.06-0.01*y,1:6);map(y->1.0-(0.03/5)*y,1:5);map(y->0.97+(0.084/9)*y,1:9);map(y->1.054-(0.22/13)*y,1:13)]
    

v1 = [1;map(y->47+y,0:(5));map(y->81+y,0:(5));map(y->93+y,0:4);map(y->111+y,0:8);map(y->125+y,0:15);map(y-> 190+y,0:6);map(y-> 218+y,0:21)]
v2 = [1;map(y->1.0+0.01*y,1:6);map(y->1.06-0.01*y,1:6);map(y->1.0-(0.03/5)*y,1:5);map(y->0.97+(0.084/9)*y,1:9);map(y->1.054-(0.225/16)*y,1:16);map(y-> 0.834+(0.03/7)*y,1:7);map(y-> 0.864-(0.11/22)*y,1:22)]
    


v1 = [1;map(y->47+y,0:(5));map(y->81+y,0:(5));map(y->93+y,0:4);map(y->111+y,0:8);map(y->125+y,0:15);map(y-> 218+y,0:21)]
v2 = [1;map(y->1.0+0.01*y,1:6);map(y->1.06-0.01*y,1:6);map(y->1.0-(0.03/5)*y,1:5);map(y->0.97+(0.084/9)*y,1:9);map(y->1.054-(0.225/16)*y,1:16);map(y-> 0.829-(0.08/22)*y,1:22)]
    
run_param_scen_cal(0.109,10,1,1.0,1.0,1.5,1.7,1.3,0.2,3,999,2,14,v2,v1,400) =#