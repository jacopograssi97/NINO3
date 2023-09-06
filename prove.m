% Dati
load Dati/a_sst_nino3_s.dat;
% load time_nino3_s.dat;
asst = a_sst_nino3_s;
asst = asst - mean(asst);
dev_std = std(asst);
asst = asst/dev_std;
N = length(asst);
nfft = 2^(nextpow2(N));
f_s = 4; % anni^(-1)

% Periodogramma
[Pxx, f] = periodogram(asst, [], nfft, f_s, 'twosided'); % Le parentesi quadre indicano la finestra rettangolare
Pxx = Pxx*f_s; % Normalizzazione spettrale
period_f = 1./f;


f1 = figure;
f1.Position = [90 90 1600 1000];

t = tiledlayout(2,2);
t.TileSpacing = 'compact';

nexttile

hold on
plot(log2(period), global_ws, 'color','r', 'LineWidth', 1.5, 'HandleVisibility','off')
plot(log2(period_f(2:nfft/2+1)), movmean(Pxx(2:nfft/2+1),3), 'color','k', 'LineWidth', 2, 'LineStyle','-.', 'HandleVisibility','off')

set(gca,'FontSize',14,'FontName','Calibri');

Xticks = 2.^( fix(log2(min(period_f(2:end)))):fix(log2(max(period_f(2:end)))) );
set(gca,'XDir','reverse');
set(gca,'Xlim',log2([min(period_f),max(period_f)]));
set(gca,'XTick',log2(Xticks(:)));
set(gca,'XTickLabel',Xticks);

ylabel('$[{|x[k]|}^2/N\sigma^2]$', 'Interpreter','latex','FontSize',19,'FontName','Calibri')

% Grid Settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off

set(gca,'box','off')



nexttile

hold on
plot(log2(period), global_ws, 'color','r', 'LineWidth', 1.5, 'DisplayName','GWS')
plot(log2(period_f(2:nfft/2+1)), movmean(Pxx(2:nfft/2+1),7), 'color','k', 'LineWidth', 2, 'LineStyle','-.', 'DisplayName','Fourier')

set(gca,'FontSize',14,'FontName','Calibri');

Xticks = 2.^( fix(log2(min(period_f(2:end)))):fix(log2(max(period_f(2:end)))) );
set(gca,'XDir','reverse');
set(gca,'Xlim',log2([min(period_f),max(period_f)]));
set(gca,'XTick',log2(Xticks(:)));
set(gca,'XTickLabel',Xticks);
legend('location','southeastoutside')

% Grid Settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off

set(gca,'box','off')

nexttile

hold on
plot(log2(period), global_ws, 'color','r', 'LineWidth', 1.5, 'HandleVisibility','off')
plot(log2(period_f(2:nfft/2+1)), movmean(Pxx(2:nfft/2+1),21), 'color','k', 'LineWidth', 2, 'LineStyle','-.', 'HandleVisibility','off')

set(gca,'FontSize',14,'FontName','Calibri');

Xticks = 2.^( fix(log2(min(period_f(2:end)))):fix(log2(max(period_f(2:end)))) );
set(gca,'XDir','reverse');
set(gca,'Xlim',log2([min(period_f),max(period_f)]));
set(gca,'XTick',log2(Xticks(:)));
set(gca,'XTickLabel',Xticks);

xlabel('$log_2$(Periodo $[yr^{-1}]$)', 'Interpreter','latex','FontSize',19,'FontName','Calibri')
ylabel('$[{|x[k]|}^2/N\sigma^2]$', 'Interpreter','latex','FontSize',19,'FontName','Calibri')

% Grid Settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off

set(gca,'box','off')


nexttile

hold on
plot(log2(period), global_ws, 'color','r', 'LineWidth', 1.5, 'HandleVisibility','off')
plot(log2(period_f(2:nfft/2+1)), movmean(Pxx(2:nfft/2+1),71), 'color','k', 'LineWidth', 2, 'LineStyle','-.', 'HandleVisibility','off')

set(gca,'FontSize',14,'FontName','Calibri');

Xticks = 2.^( fix(log2(min(period_f(2:end)))):fix(log2(max(period_f(2:end)))) );
set(gca,'XDir','reverse');
set(gca,'Xlim',log2([min(period_f),max(period_f)]));
set(gca,'XTick',log2(Xticks(:)));
set(gca,'XTickLabel',Xticks);

xlabel('$log_2$(Periodo $[yr^{-1}]$)', 'Interpreter','latex','FontSize',19,'FontName','Calibri')


% Grid Settings
grid on
ax=gca;
ax.Layer = 'top';
ax.GridAlpha = 0.2;
hold off

set(gca,'box','off')

print('Grafici/fourier_vs_GWS','-dpng')