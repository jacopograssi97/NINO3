% plot_w_nino3
% Plot results of w_nino3

% Chose mother wavelet
prompt= 'Mother wavelet?  (1 = Morlet, 2 = Paul(m=4), 3 = DOG(m=2), 4= DOG(m=6))';
flagmother = input(prompt);

% Load computation results from mat file
if flagmother==1
    load w_nino3_Morl.mat
    l0=6
elseif flagmother==2
    load w_nino3_Paul.mat
    l0=9
elseif flagmother==3
    load w_nino3_DOG2.mat
    l0=30
else
    load w_nino3_DOG6.mat
    l0=20
end

label1y='Anomalia [$^{\circ}$C]';
title1='NINO3 SST seasonal anomalies';
label2x='Tempo [yr]';
label2y='Periodo [yr]';
title2='Wavelet spectrum';
label3x='Potenza';
title3='GWS';
xlim = [time(1),time(end)];  
ylim1= [min(z) max(z)];
xti=1880:20:2000;
gws_lim1=0.05;
gws_lim2=50;
xti_gws=[10^(-1) 10^0 10^1 10^2];
levels=linspace(log2(min(power(:)))+l0,log2(max(power(:))),64);


f1 = figure;
f1.Position = [90 90 1200 700];
%--- Plot time series
subplot('position',[0.1 0.73 0.62 0.18])
plot(time,z,'k')
set(gca,'XLim',xlim(:))
set(gca,'YLim',ylim1(:))
set(gca,'XTick',xti)
set(gca,'YTick',[-2:4])
hlabely=get(gca,'Ylabel');
set(gca,'FontSize',14,'FontName','Calibri')
set(hlabely,'String',label1y, 'Interpreter','latex','FontSize',16,'FontName','Calibri')
%title(title1,'FontSize',19,'FontWeight','Bold','FontName','Calibri')
grid on

%--- Contour plot wavelet power spectrum
subplot('position',[0.1 0.12 0.62 0.48])
pow_lev=2.^levels
nlev=length(pow_lev)
[c,H]=contourf(time,log2(period),log2(power),levels);
colormap(jet)
set(H,'LineStyle','none')
set(gca,'XLim',xlim(:))
set(gca,'XTick',xti)
set(gca,'FontSize',14,'FontName','Calibri')
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
set(gca,'YLim',log2([min(period),max(period)]),'YDir','reverse','YTick',log2(Yticks(:)),'YTickLabel',num2str(Yticks'),'layer','top')
hlabelx=get(gca,'Xlabel');
set(hlabelx,'String',label2x,'Interpreter','Latex','FontSize',19,'FontName','Calibri')
hlabely=get(gca,'Ylabel');
set(hlabely,'String',label2y,'Interpreter','Latex','FontSize',19,'FontName','Calibri')
%title(title2,'FontSize',17,'FontWeight','Bold','FontName','Calibri')
hold on
% significance contour, levels at -99 (fake) and 1 (signif)
[c,h] = contour(time,log2(period),sig,[-99,1],'k','LineWidth',1.5);%95%
% cone-of-influence, anything "below" is dubious
plot(time,log2(coi),'w','LineWidth',1.5)
hold off

%--- Plot global wavelet spectrum
subplot('position',[0.74 0.12 0.23 0.48])
semilogx(global_signif,log2(period),'r','LineWidth',1.5)%95%
hold on
semilogx(global_ws,log2(period),'k','LineWidth',1.5)
hold off
set(gca,'FontSize',14,'FontName','Calibri')
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
set(gca,'YLim',log2([min(period),max(period)]),'YDir','reverse','YTick',log2(Yticks(:)),'YTickLabel','')
set(gca,'XLim',[gws_lim1,gws_lim2])
set(gca,'XTick',xti_gws)
hlabelx=get(gca,'Xlabel');
set(hlabelx,'String',label3x,'Interpreter','Latex','FontSize',19,'FontName','Calibri')
%title(title3,'FontSize',17,'FontWeight','Bold','FontName','Calibri')
grid on
