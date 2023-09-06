%% ---Importazione dati----------------------------------------------------
clear all
load Dati/a_sst_nino3_m.dat;
load Dati/time_nino3_m.dat;

sst_nino3_m = a_sst_nino3_m;

%% ---Parametri necessari per analisi statistica---------------------------

%Media, std e massimo/minimo
[nino_mean nino_sigma] = normfit(sst_nino3_m);
mi = min(sst_nino3_m);
ma = max(sst_nino3_m);

%Operazioni per istogramma con gaussiana
nbins=ceil(sqrt(length(sst_nino3_m)));          %Numero di bins per istogramma
[Nx,xout]=hist(sst_nino3_m,nbins);              %Nx->altezza bin corrispondente al valore xout
ampbin=(ma-mi)/nbins;
limbins=NaN(nbins,2);
for k=1:nbins
    limbins(k,1)=xout(k)-ampbin/2;
    limbins(k,2)=xout(k)+ampbin/2;
end
for k=1:nbins
    area(k)=(limbins(k,2)-limbins(k,1))*Nx(k);
end
are=sum(area);
ny=10^3;
y=linspace(limbins(1,1),limbins(nbins,2),ny);
ga=are*(1/(nino_sigma*sqrt(2*pi)))*...
exp(-(y-nino_mean).*(y-nino_mean)/(2*nino_sigma*nino_sigma));
hwhm=nino_sigma*sqrt(2*log(2));

%Skewness e Kurtosi
Sk = skewness(sst_nino3_m)
Ku = kurtosis(sst_nino3_m)

%% ---Plot serie temporale e istogramma------------------------------------

% TIME SERIE PLOT

% General figure settings
f1 = figure;
f1.Position = [90 90 800 500];

% General settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
ax.FontSize = 15;
ax.FontName = 'Calibri';

patch([1870 2014 2014 1870],[nino_mean-nino_sigma nino_mean-nino_sigma nino_mean+nino_sigma nino_mean+nino_sigma],[0.85 0.96 0.8],'EdgeColor','none')
patch([1870 2014 2014 1870],[nino_mean-2*nino_sigma nino_mean-2*nino_sigma nino_mean-nino_sigma nino_mean-nino_sigma],[0.83 0.91 1],'EdgeColor','none')
patch([1870 2014 2014 1870],[nino_mean+nino_sigma nino_mean+nino_sigma nino_mean+2*nino_sigma nino_mean+2*nino_sigma],[0.83 0.91 1],'EdgeColor','none')
patch([1870 2014 2014 1870],[nino_mean+2*nino_sigma nino_mean+2*nino_sigma nino_mean+3*nino_sigma nino_mean+3*nino_sigma],[1 0.88 0.84],'EdgeColor','none')
patch([1870 2014 2014 1870],[nino_mean-3*nino_sigma nino_mean-3*nino_sigma nino_mean-2*nino_sigma nino_mean-2*nino_sigma],[1 0.86 0.84],'EdgeColor','none')
hold on

%Principal plot in y-axis left
yyaxis left
plot(time_nino3_m,sst_nino3_m,'LineWidth',0.8,'Color','k','HandleVisibility','off');
ylim([nino_mean-3*nino_sigma-1.2 nino_mean+3*nino_sigma+1.2]);
ylabel('SST $[^{\circ}C]$', 'Interpreter','latex','FontSize',19,'FontName','Calibri')

%Std in parameters in y-axis right
yyaxis right
yline(nino_mean,'LineWidth',1.7,'Color',[0.64 0.08 0.18]);
yticks([nino_mean-3*nino_sigma nino_mean-2*nino_sigma nino_mean-nino_sigma nino_mean nino_mean+nino_sigma nino_mean+2*nino_sigma nino_mean+3*nino_sigma])
yticklabels({'\mu-3\sigma','\mu-2\sigma','\mu-\sigma','\mu','\mu+\sigma','\mu+2\sigma','\mu+3\sigma'})
ylim([nino_mean-3*nino_sigma-1.2 nino_mean+3*nino_sigma+1.2]);

%X-axis settings
xlim([1870 2014]);
xlabel('\it Tempo $[yr]$', 'Interpreter','latex','FontSize',19,'FontName','Calibri')
hold off

print('Grafici/elementary_plot_wht','-dpng')

%HISTOGRAM PLOT 

f2 = figure;
f2.Position = [90 90 800 500];

% General settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
ax.FontSize = 15;
ax.FontName = 'Calibri';

patch([nino_mean-nino_sigma nino_mean+nino_sigma nino_mean+nino_sigma nino_mean-nino_sigma],[0 0 160 160],[0.85 0.96 0.8],'EdgeColor','none', 'HandleVisibility', 'off')
patch([nino_mean-2*nino_sigma nino_mean-nino_sigma nino_mean-nino_sigma nino_mean-2*nino_sigma],[0 0 160 160],[0.83 0.91 1],'EdgeColor','none', 'HandleVisibility', 'off')
patch([nino_mean+nino_sigma nino_mean+2*nino_sigma nino_mean+2*nino_sigma nino_mean+nino_sigma],[0 0 160 160],[0.83 0.91 1],'EdgeColor','none', 'HandleVisibility', 'off')
patch([nino_mean+2*nino_sigma nino_mean+3*nino_sigma nino_mean+3*nino_sigma nino_mean+2*nino_sigma],[0 0 160 160],[1 0.88 0.84],'EdgeColor','none', 'HandleVisibility', 'off')
patch([nino_mean-3*nino_sigma nino_mean-2*nino_sigma nino_mean-2*nino_sigma nino_mean-3*nino_sigma],[0 0 160 160],[1 0.86 0.84],'EdgeColor','none', 'HandleVisibility', 'off')
hold on

histogram(sst_nino3_m,nbins,'FaceColor',[0 0 0],'EdgeAlpha',1,'HandleVisibility','off');
xlabel('SST $[^{\circ}C]$', 'Interpreter','latex','FontSize',19,'FontName','Calibri')
ylabel('N', 'Interpreter','latex','FontSize',19,'FontName','Calibri')


hold on;
plot(y,ga,'LineWidth',1.5,'Color','b','LineWidth',2,'DisplayName','Distribuzione normale');
plot([nino_mean nino_mean],[0 160],'Color',[0.64 0.08 0.18],'LineWidth',2,'DisplayName','\mu');
hold off;

xlim([nino_mean-3*nino_sigma-1.2 nino_mean+3*nino_sigma+1.2]);
ylim([0 160]);
hold off

legend('FontSize',15,'Orientation','vertical','Location','south');
print('Grafici/elementary_histogram_wht','-dpng')

%% ---Periodicità----------------------------------------------------------
[rho_cov,lags]=xcov(sst_nino3_m,'coeff');
[rho_corr,lags]=xcorr(sst_nino3_m,'coeff');

f2 = figure;
f2.Position = [90 90 800 500];

t = tiledlayout(2,8);

%General settings 
t.Padding = 'compact';
t.TileSpacing = 'compact';
ylabel(t,'Coefficiente ${\rho}$', 'Interpreter','latex','FontSize',19,'FontName','Calibri')
xlabel(t,'Lag $[months]$', 'Interpreter','latex','FontSize',19,'FontName','Calibri')

%AUTOCORRELATION PLOT
nexttile([1 5])
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
ax.FontSize = 15;
ax.FontName = 'Calibri';
hold on
plot(lags,rho_corr,'Color',[0.35,0.50,0.15],'LineWidth',1,'DisplayName','Autocorrelazione')
set(gca,'xticklabels',[])
xlim([-1800, 1800])
ylim([-0.3,1.2])
legend('FontSize',15,'Orientation','vertical','Location','northeast');
hold off

%AUTOCORRELATION FOCUS PLOT
nexttile([1 3])
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
ax.FontSize = 15;
ax.FontName = 'Calibri';
title('Ingrandimento dei picchi','FontSize',15,'FontName','Calibri','Color',[0.09,0.06,0.26],'FontWeight','normal');
hold on
plot(lags,rho_corr,'Color',[0.35,0.50,0.15],'LineWidth',1)
yyaxis left
set(gca,'xtick', [-48, -36, -24, -12, 0, 12, 24, 36, 48],'xticklabels',[],'yticklabels',[])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',13)
xlim([-50, 50])
ylim([-0.3,1.2])
yyaxis right
ylim([-0.3,1.2])
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off

% AUTOCOVARIANCE PLOT
nexttile([1 5])
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
ax.FontSize = 15;
ax.FontName = 'Calibri';
hold on
plot(lags,rho_cov,'Color','b','LineWidth',0.1,'DisplayName','Autocovarianza')
xlim([-1800, 1800])
ylim([-0.3,1.2])
legend('FontSize',15,'Orientation','vertical','Location','northeast');
hold off

% AUTOCOVARIANCE FOCUS PLOT
nexttile([1 3])
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
ax.FontSize = 15;
ax.FontName = 'Calibri';
hold on
plot(lags,rho_cov,'Color','b','LineWidth',1)
yyaxis left
set(gca,'yticklabels',[],'xtick',[-48, -36, -24, -12, 0, 12, 24, 36, 48])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',11)
xlim([-50, 50])
ylim([-0.3,1])
yyaxis right
ylim([-0.3,1])
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off


print('Grafici/elementary_periodicity_wht','-dpng')