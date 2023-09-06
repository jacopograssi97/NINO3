function [Pred,omred]=redbckg(x,N_f)
% Compute red-noise-background power spectrum (Pred) 
% with parameter alpha estimated from data series (x)
% and corresponding  frequencies omega (omred)  over N_f points from 0 to pi.

alpha=AR1_param(x);
num=1-(alpha*alpha);
k=0:1:N_f/2;
omred=2*pi*k/N_f;
arg=(2*pi/N_f)*k;
den=1+alpha*alpha-2*alpha*cos(arg);
p=num./den;
s2=var(x);
Pred=s2*p';