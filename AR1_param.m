function [rholag1]=AR1_param(x)
% Estimation of ``true'' lag 1 autocorrelation (rholag1) of data (x) 
% for red-noise-background spectrum 

rho=xcov(x,3,'coeff'); 
rho1=rho(3); % lag 1 autocorrelation from xcov
rho2=rho(2); % lag 2 autocorrelation from xcov

% If data are strongly anticorrelated at lag 1 OR 2, 
% then send a warning message
if ((rho1<0 && abs(rho1)>0.1)  || (rho2<0 && abs(rho2)>0.1)) 
             error('Data do not resemble white or red noise')
% If data are weakly anticorrelated  at lag 1 OR 2, 
% then ASSUME white noise             
elseif ((rho1<0 && abs(rho1)<=0.1) || (rho2<0 && abs(rho2)<=0.1)) 
             rholag1= 0;            % White noise 
else
% If data are uncorrelated or positively correlated at lag 1 AND 2,
% then estimate rolag1; if rolag1 turns out to be zero because ro1=ro2=0,
% then the noise is actually white       
             rholag1=(rho1+sqrt(rho2))/2;  
end
return
