clear
close all
rng(1216)

% Set grid size
G = 10;

% Set end period.
T = 365;

% Initialize grid
[ X, Y ] = meshgrid(1:G, 1:G);
S = zeros(size(X));

% Buffer matrix with -infs at border
S_B = ones(size(X)+2);
S_B(1,:)=-inf;,S_B(end,:)=-inf;,S_B(:,1)=-inf;,S_B(:,end)=-inf;

% Two snow leopards
N_sl = 2;
sl_loc = [5 5];
trap_loc = [3 3];
runs = 1;
[capture, DS] = slsimulate(T, N_sl, sl_loc, trap_loc, runs, S_B)

for i=1:size(DS,3)
    subplot(1,2,1); 
    p1 = plot(DS(:, 1, i), DS(:, 2, i),'LineWidth',2); hold on;
    axis([1 10 1 10])
    p1.Color(4) = 0.25;
    ylabel('10 km grid centroid, vertical');
    xlabel('10 km grid centroid, horizontal');
    title('Simulated snow leopard migration between grid cells')
end
plot(trap_loc(1), trap_loc(2),'ko','MarkerFaceColor', 'k');
subplot(1,2,2)
plot(cumsum(capture),'LineWidth',2)
xlabel('Days from beginning of simulation');
ylabel('Cumulative number of trap triggers');
title('Camera trap encounters, cumulative')
hold off
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 30 15]);
saveas(gcf, 'PS4_SL_F1', 'png');

% One snow leopard, 1000 mc runs
N_sl = 1;
sl_loc = [5 5];
trap_loc = [3 3];
runs = 1000;
[capture, DS] = slsimulate(T, N_sl, sl_loc, trap_loc, runs, S_B);

j = histogram(sum(capture, 1),'Normalization','probability', 'BinWidth', 1);
M = j.Values(find(j.BinEdges == 7));
xlabel('Encounters');
ylabel('Probability');
title(strcat('Histogram of camera trap encounters, N=',num2str(N_sl), ...
    ', trap location=', mat2str(trap_loc)));
ylim=get(gca,'ylim'); xlim=get(gca,'xlim');
text(.7*xlim(2),.7*ylim(2),compose(strcat("var=", num2str(var(sum(capture,1))), ...
    '\n', 'Pr(M_7)=', num2str(M))), ...
    'Color','red','FontSize',14);
saveas(gcf, 'PS4_SL_F2', 'png');

% 2-5 snow leopards, 1000 mc runs
for N_sl = 2:5
    subplot(2, 2, N_sl-1)
    sl_loc = [5 5];
    trap_loc = [3 3];
    runs = 1000;
    [capture, DS] = slsimulate(T, N_sl, sl_loc, trap_loc, runs, S_B);

    j = histogram(sum(capture, 1),'Normalization','probability', 'BinWidth', 1);
    M = j.Values(find(j.BinEdges == 7));
    xlabel('Encounters');
    ylabel('Probability');
    title(strcat('Histogram of camera trap encounters, N=',num2str(N_sl), ...
        ', trap location=', mat2str(trap_loc)));
    ylim=get(gca,'ylim'); xlim=get(gca,'xlim');
    text(.7*xlim(2),.7*ylim(2),compose(strcat("var=", num2str(var(sum(capture,1))), ...
        '\n', 'Pr(M_7)=', num2str(M))), ...
        'Color','red','FontSize',14);
end
saveas(gcf, 'PS4_SL_F3', 'png');

% 3 snow leopards, alternate trap locations, 1000 mc runs
traps = [1 1 ;
        5 5];
for trap = 1:size(traps,1)
    subplot(1, 2, trap);
    N_sl = 3;
    sl_loc = [10 10];
    trap_loc = traps(trap, :);
    runs = 1000;
    [capture, DS] = slsimulate(T, N_sl, sl_loc, trap_loc, runs, S_B);

    j = histogram(sum(capture, 1),'Normalization','probability', 'BinWidth', 1);
    M = j.Values(find(j.BinEdges == 7));
    xlabel('Encounters');
    ylabel('Probability');
    title(strcat('Histogram of camera trap encounters, N=',num2str(N_sl), ...
        ', trap location=', mat2str(trap_loc)));
    ylim=get(gca,'ylim'); xlim=get(gca,'xlim');
    text(.7*xlim(2),.7*ylim(2),compose(strcat("var=", num2str(var(sum(capture,1))), ...
        '\n', 'Pr(M_7)=', num2str(M))), ...
        'Color','red','FontSize',14);
end
saveas(gcf, 'PS4_SL_F4', 'png');


