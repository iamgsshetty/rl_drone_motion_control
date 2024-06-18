function [reward,r_p,v] = fcn(des, u, weights,cp,len)
desired_pos = [des(1); des(2); des(3)];
desired_vel = des(4);

w_p = weights(1);

p = [u(1); u(2); u(3)];
v = norm(u(4:6));

r_p = w_p + (1 * exp(-1* norm(p-desired_pos)));

if weights(2) == len+1
    reward = (1 * exp(-1* norm(p-cp))) * (r_p);
else
    reward = (1 * exp(-1* norm(p-cp))) * (1 * exp(-1 * abs(v - desired_vel))) * (r_p);
end
