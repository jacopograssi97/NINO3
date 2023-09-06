%% ---Importazione dati----------------------------------------------------
clear all
clc

load Dati/a_sst_nino3_s.dat
load Dati/time_nino3_s.dat

z = a_sst_nino3_s;
time = time_nino3_s;

clear a_sst_nino3_s time_nino3_s

file_name = 'Grafici/wawelet_Morlet'
mother = 'Morlet';
param = 6;

[consts]=w_parameters(mother,param);
a_0 = 2;

nino_sigma = std(z);
nino_variance = var(z);

z_norm = (z - mean(z))/nino_sigma;
N = length(z_norm);

Ts = 0.25;

dj = 0.05;
j = 160;

[wave,period,a,coi,power,xcheck] = ...
w_transform(z_norm,1,dj,a_0,j,1,mother,param);

[rholag1]=AR1_param(z_norm);

[signif] = ...
w_significance(1,a,0,rholag1,0.95,-1,mother,param);

sig = (signif')*(ones(1,N));

global_ws=sum(power')/N;


sig=power./sig;

dof=N-consts(7)*a;

[global_signif] = ...
w_significance(1,a,1,rholag1,0.95,dof,mother,param);

coi = coi.*Ts;
period = period.*Ts;

save w_nino3_Morlet.mat

plot_w_nino3

print(file_name,'-dpng')
