%% ---Importazione dati----------------------------------------------------
clear all
clc

load Dati/a_sst_nino3_m.dat
load Dati/time_nino3_m.dat


%% ---Calcolo dei tre periodogrammi----------------------------------------

nino_serie = normalize(a_sst_nino3_m,'zscore');

N = length(nino_serie);
nfft = 1024;
f_s = 12; % Doppio della frequenza di Nyquist

% Divisione in tre segmenti consecutivi
segmento1 = nino_serie(1:ceil(N/3));
segmento2 = nino_serie(ceil(N/3)+1:2*ceil(N/3));
segmento3 = nino_serie(2*ceil(N/3)+1:N);
N1 = length(segmento1);
N2 = length(segmento2);
N3 = length(segmento3);

% Periodogrammi
[Pxx1, f_1] = periodogram(segmento1, [], nfft, f_s, 'twosided'); % Le parentesi quadre indicano la finestra rettangolare
Pxx1 = Pxx1*f_s; % Normalizzazione spettrale
[Pxx2, f_2] = periodogram(segmento2, [], nfft, f_s, 'twosided'); % Le parentesi quadre indicano la finestra rettangolare
Pxx2 = Pxx2*f_s; % Normalizzazione spettrale
[Pxx3, f_3] = periodogram(segmento3, [], nfft, f_s, 'twosided'); % Le parentesi quadre indicano la finestra rettangolare
Pxx3 = Pxx3*f_s; % Normalizzazione spettrale


% Noise 1 - Livello di significatività per rumore rosso
[Prosso1, nurosso1] = redbckg(segmento1, nfft);
fac_signif95_1 = chi2inv(.95, 2)/2; % 95% di significatività
fac_signif99_1 = chi2inv(.999, 2)/2; % 99.9% di significatività
signif95_1 = fac_signif95_1*Prosso1;
signif99_1 = fac_signif99_1*Prosso1;

% Noise 2 - Livello di significatività per rumore rosso
[Prosso2, nurosso2] = redbckg(segmento2, nfft);
fac_signif95_2 = chi2inv(.95, 2)/2; % 95% di significatività
fac_signif99_2 = chi2inv(.999, 2)/2; % 99.9% di significatività
signif95_2 = fac_signif95_2*Prosso2;
signif99_2 = fac_signif99_2*Prosso2;

% Noise 3 - Livello di significatività per rumore rosso
[Prosso3, nurosso3] = redbckg(segmento3, nfft);
fac_signif95_3 = chi2inv(.95, 2)/2; % 95% di significatività
fac_signif99_3 = chi2inv(.999, 2)/2; % 99.9% di significatività
signif95_3 = fac_signif95_3*Prosso3;
signif99_3 = fac_signif99_3*Prosso3;


%%
period1 = 1./f_1;
period2 = 1./f_2;
period3 = 1./f_3;


f1 = figure;
f1.Position = [90 90 800 1500];
t = tiledlayout(3,1);
t.TileSpacing = 'compact';

nexttile
hold on
for i=1:(nfft/2)-1
    patch(log2([period1(i) period1(i+1) period1(i+1) period1(i)]), [Prosso1(i) Prosso1(i+1) 10000 10000],[0.85 0.96 0.8],'EdgeColor','none','HandleVisibility','off')
    hold on
    patch(log2([period1(i) period1(i+1) period1(i+1) period1(i)]), [signif95_1(i) signif95_1(i+1) 10000 10000],[0.83 0.91 1],'EdgeColor','none','HandleVisibility','off')
    hold on
    patch(log2([period1(i) period1(i+1) period1(i+1) period1(i)]), [signif99_1(i) signif99_1(i+1) 10000 10000],[1 0.86 0.84],'EdgeColor','none','HandleVisibility','off')
    hold on
end
patch(log2([period1(nfft/2) period1(nfft/2+1) period1(nfft/2+1) period1(nfft/2)]), [Prosso1(nfft/2) Prosso1(nfft/2+1) 10000 10000],[0.85 0.96 0.8],'EdgeColor','none', 'DisplayName', 'P rosso')
hold on
patch(log2([period1(nfft/2) period1(nfft/2+1) period1(nfft/2+1) period1(nfft/2)]), [signif95_1(nfft/2) signif95_1(nfft/2+1) 10000 10000],[0.83 0.91 1],'EdgeColor','none', 'DisplayName', '95%')
hold on
patch(log2([period1(nfft/2) period1(nfft/2+1) period1(nfft/2+1) period1(nfft/2)]), [signif99_1(nfft/2) signif99_1(nfft/2+1) 10000 10000],[1 0.86 0.84],'EdgeColor','none', 'DisplayName', '99%')
hold on
plot(log2(period1(2:nfft/2+1)), Pxx1(2:nfft/2+1), 'k', 'LineWidth', 1.5,'HandleVisibility','off')
hold on
plot(log2(period1(2:nfft/2+1)), Prosso1(2:nfft/2+1),'-','LineWidth',1,'Color',[0.17 0.23 0.09], 'HandleVisibility','off');
hold on
plot(log2(period1(2:nfft/2+1)), signif95_1(2:nfft/2+1),'-','LineWidth',1,'Color',[0.09 0.28 0.41], 'HandleVisibility','off');
hold on
plot(log2(period1(2:nfft/2+1)), signif99_1(2:nfft/2+1),'-','LineWidth',1,'Color',[0.64 0.08 0.18], 'HandleVisibility','off');


Xticks = 2.^( fix(log2(min(period1(2:end)))):fix(log2(max(period1(2:end)))) );
set(gca,'XDir','reverse');
set(gca,'Xlim',log2([min(period1),max(period1)]));
set(gca,'XTick',log2(Xticks(:)));
set(gca,'XTickLabel',Xticks);

ylim([-3 60])

% Grid Settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off
set(gca,'box','off')

set(gca,'Fontsize',13,'ytick',[0 15 30 45 60])
set(gca,'Fontsize',13,'xtick',log2([0.125 0.25 0.5 1 2 4 8 16 32 64]),'xticklabel',{[]},'box','off','xcolor','none')

%%

nexttile

hold on
for i=1:(nfft/2)-1
    patch(log2([period2(i) period2(i+1) period2(i+1) period2(i)]), [Prosso2(i) Prosso2(i+1) 10000 10000],[0.85 0.96 0.8],'EdgeColor','none','HandleVisibility','off')
    hold on
    patch(log2([period2(i) period2(i+1) period2(i+1) period2(i)]), [signif95_2(i) signif95_2(i+1) 10000 10000],[0.83 0.91 1],'EdgeColor','none','HandleVisibility','off')
    hold on
    patch(log2([period2(i) period2(i+1) period2(i+1) period2(i)]), [signif99_2(i) signif99_2(i+1) 10000 10000],[1 0.86 0.84],'EdgeColor','none','HandleVisibility','off')
    hold on
end
patch(log2([period2(nfft/2) period2(nfft/2+1) period2(nfft/2+1) period2(nfft/2)]), [Prosso2(nfft/2) Prosso2(nfft/2+1) 10000 10000],[0.85 0.96 0.8],'EdgeColor','none', 'DisplayName', 'P rosso')
hold on
patch(log2([period2(nfft/2) period2(nfft/2+1) period2(nfft/2+1) period2(nfft/2)]), [signif95_2(nfft/2) signif95_2(nfft/2+1) 10000 10000],[0.83 0.91 1],'EdgeColor','none', 'DisplayName', '95%')
hold on
patch(log2([period2(nfft/2) period2(nfft/2+1) period2(nfft/2+1) period2(nfft/2)]), [signif99_2(nfft/2) signif99_2(nfft/2+1) 10000 10000],[1 0.86 0.84],'EdgeColor','none', 'DisplayName', '99%')
hold on
plot(log2(period2(2:nfft/2+1)), Pxx2(2:nfft/2+1), 'k', 'LineWidth', 1.5,'HandleVisibility','off')
hold on
plot(log2(period2(2:nfft/2+1)), Prosso2(2:nfft/2+1),'-','LineWidth',1,'Color',[0.17 0.23 0.09], 'HandleVisibility','off');
hold on
plot(log2(period2(2:nfft/2+1)), signif95_2(2:nfft/2+1),'-','LineWidth',1,'Color',[0.09 0.28 0.41], 'HandleVisibility','off');
hold on
plot(log2(period2(2:nfft/2+1)), signif99_2(2:nfft/2+1),'-','LineWidth',1,'Color',[0.64 0.08 0.18], 'HandleVisibility','off');


Xticks = 2.^( fix(log2(min(period2(2:end)))):fix(log2(max(period2(2:end)))) );
set(gca,'XDir','reverse');
set(gca,'Xlim',log2([min(period2),max(period2)]));
set(gca,'XTick',log2(Xticks(:)));
set(gca,'XTickLabel',Xticks);
ylim([-3 60])

% Grid Settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off
set(gca,'box','off')

set(gca,'Fontsize',13,'ytick',[0 15 30 45 60])
set(gca,'Fontsize',13,'xtick',log2([0.125 0.25 0.5 1 2 4 8 16 32 64]),'xticklabel',{[]},'box','off','xcolor','none')

ylabel('${|x[k]|}^2/N\sigma^2$', 'Interpreter','latex','FontSize',19,'FontName','Calibri')
legend('FontSize',15,'Orientation','vertical','Location','best');

%%

nexttile

hold on
for i=1:(nfft/2)-1
    patch(log2([period3(i) period3(i+1) period3(i+1) period3(i)]), [Prosso3(i) Prosso3(i+1) 10000 10000],[0.85 0.96 0.8],'EdgeColor','none','HandleVisibility','off')
    hold on
    patch(log2([period3(i) period3(i+1) period3(i+1) period3(i)]), [signif95_3(i) signif95_3(i+1) 10000 10000],[0.83 0.91 1],'EdgeColor','none','HandleVisibility','off')
    hold on
    patch(log2([period3(i) period3(i+1) period3(i+1) period3(i)]), [signif99_3(i) signif99_3(i+1) 10000 10000],[1 0.86 0.84],'EdgeColor','none','HandleVisibility','off')
    hold on
end
patch(log2([period3(nfft/2) period3(nfft/2+1) period3(nfft/2+1) period3(nfft/2)]), [Prosso3(nfft/2) Prosso3(nfft/2+1) 10000 10000],[0.85 0.96 0.8],'EdgeColor','none', 'DisplayName', 'P rosso')
hold on
patch(log2([period3(nfft/2) period3(nfft/2+1) period3(nfft/2+1) period3(nfft/2)]), [signif95_3(nfft/2) signif95_3(nfft/2+1) 10000 10000],[0.83 0.91 1],'EdgeColor','none', 'DisplayName', '95%')
hold on
patch(log2([period3(nfft/2) period3(nfft/2+1) period3(nfft/2+1) period3(nfft/2)]), [signif99_3(nfft/2) signif99_3(nfft/2+1) 10000 10000],[1 0.86 0.84],'EdgeColor','none', 'DisplayName', '99%')
hold on
plot(log2(period3(2:nfft/2+1)), Pxx3(2:nfft/2+1), 'k', 'LineWidth', 1.5,'HandleVisibility','off')
hold on
plot(log2(period3(2:nfft/2+1)), Prosso3(2:nfft/2+1),'-','LineWidth',1,'Color',[0.17 0.23 0.09], 'HandleVisibility','off');
hold on
plot(log2(period3(2:nfft/2+1)), signif95_3(2:nfft/2+1),'-','LineWidth',1,'Color',[0.09 0.28 0.41], 'HandleVisibility','off');
hold on
plot(log2(period3(2:nfft/2+1)), signif99_3(2:nfft/2+1),'-','LineWidth',1,'Color',[0.64 0.08 0.18], 'HandleVisibility','off');


Xticks = 2.^( fix(log2(min(period3(2:end)))):fix(log2(max(period3(2:end)))) );
set(gca,'XDir','reverse');
set(gca,'Xlim',log2([min(period3),max(period3)]));
set(gca,'XTick',log2(Xticks(:)));
set(gca,'XTickLabel',Xticks);


ylim([-3 60])

% Grid Settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off
set(gca,'box','off')
set(gca,'Fontsize',13,'ytick',[0 15 30 45 60])
xlabel('$log_2$(Periodo $[yr^{-1}]$)', 'Interpreter','latex','FontSize',19,'FontName','Calibri')

print('Grafici/periodogram_stazionarietà','-dpng')
