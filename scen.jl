
vc = [1;map(y->47+y,0:(5));map(y->81+y,0:(5));map(y->93+y,0:4);map(y->111+y,0:8);map(y->125+y,0:15);map(y-> 190+y,0:6);map(y-> 219+y,0:27)]
vr = [1;map(y->1.0+0.01*y,1:6);map(y->1.06-0.01*y,1:6);map(y->1.0-(0.03/5)*y,1:5);map(y->0.97+(0.075/9)*y,1:9);map(y->1.045-(0.215/16)*y,1:16);map(y-> 0.83+(0.03/7)*y,1:7);map(y-> 0.86-(0.15/28)*y,1:28)]    
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,true,0.2,1,999,2,14,vc,vr,303)
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,false,0.2,2,999,2,14,vc,vr,303)
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,true,0.2,3,999,2,14,vc,vr,303,"half")



##calibrate the scenario where everybody acts in the same way
vc = [1;map(y->47+y,0:(5));map(y->81+y,0:(5));map(y->93+y,0:4);map(y->111+y,0:8);map(y->125+y,0:15);map(y-> 190+y,0:6);map(y-> 219+y,0:27)]
vr = [1;map(y->1.0+0.01*y,1:6);map(y->1.06-0.01*y,1:6);map(y->1.0-(0.03/5)*y,1:5);map(y->0.97+(0.075/9)*y,1:9);map(y->1.045-(0.215/16)*y,1:16);map(y-> 0.83+(0.03/7)*y,1:7);map(y-> 0.86-(0.1/28)*y,1:28)]    
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,true,0.2,4,999,3,14,vc,vr,303)
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,false,0.2,5,999,3,14,vc,vr,303)
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,true,0.2,6,999,3,14,vc,vr,303,"half")


### New calibration with non-vaccinated slowly increasing the contact pattern
vc = [1;map(y->47+y,0:(5));map(y->81+y,0:(5));map(y->93+y,0:4);map(y->111+y,0:8);map(y->125+y,0:15);map(y-> 190+y,0:6);map(y-> 214+y,0:48)]
vr = [1;map(y->1.0+0.01*y,1:6);map(y->1.06-0.01*y,1:6);map(y->1.0-(0.03/5)*y,1:5);map(y->0.97+(0.075/9)*y,1:9);map(y->1.045-(0.215/16)*y,1:16);map(y-> 0.83+(0.03/7)*y,1:7);map(y-> 0.86-(0.43/49)*y,1:49)]    
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,true,0.2,7,215,2,14,vc,vr,303,"statuscuo",1)
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,false,0.2,8,215,2,14,vc,vr,303,"statuscuo",1)
run_param_scen(0.109,10,1,1.0,1.0,1.6,1.3,true,0.2,9,215,2,14,vc,vr,303,"half",1)

