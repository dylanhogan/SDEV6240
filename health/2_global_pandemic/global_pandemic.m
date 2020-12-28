clear
close all
rng(1216)

b0 = [1 0 0 1 0].'

A = [0 1 1 0 0 ;
     1 0 1 0 0 ;
     1 1 0 1 0 ;
     0 0 1 0 1 ;
     0 0 0 1 0 ]

A * b0

T = 10;

ds = zeros(T, 5)
ds(1, :) = b0
for t = 2:T
    for i = 1:5
        for j = 1:5
            ds(t, i) = ds(t, i) + A(i,j)*ds(t-1, j)*(1 - ds(t, i))
        end
    end
end

% Part two

load network.mat
N = size(network, 1);
R = 1000
T = 30;

ny = 23:34;
ny_infected = (rand(size(ny, 2), R) > 2/3);
b0 = zeros(N, R);
b0(ny, :) = ny_infected;


ds = zeros(T, N, R);
ds(1, :, :) = b0;
for r = 1:R
    for t = 2:T
        for i = 1:N
            for j = 1:N
                ds(t, i, r) = ds(t, i, r) + network(i,j)*ds(t-1, j, r)*(1 - ds(t, i, r));
            end
        end
    end
end

tokyo = 1:14
johannesburg = 15:19
kathmandu = 20:22

average_risk = mean(ds, [2 3]);
plot(average_risk,'LineWidth',2)
hold on
plot(mean(ds(:, ny, :), [2 3]), 'LineWidth',2)
plot(mean(ds(:, tokyo, :), [2 3]), 'LineWidth',2)
plot(mean(ds(:, johannesburg, :), [2 3]), 'LineWidth',2)
plot(mean(ds(:, kathmandu, :), [2 3]), 'LineWidth',2)
legend('Average', 'NY', 'Tokyo','Johannesburg','Kathmandu', 'Location', 'best')
ylabel('Risk');
xlabel('Year from beginning of simulation');
title('Risk of infection, average over simulations and individuals');
hold off
saveas(gcf, 'PS5_2_F1', 'png');

load network.mat
N = size(network, 1);
R = 1000
T = 30;

ny = 23:34;
ny_infected = (rand(size(ny, 2), R) > 2/3);
b0 = zeros(N, R);
b0(ny, :) = ny_infected;

vacc = [ 33 26 ;
         14 33 ;
         12 33 ]

leg = {}

for v = 1:size(vacc,1)
    ds = zeros(T, N, R);
    ds(1, :, :) = b0;
    for r = 1:R
        for t = 2:T
            for i = 1:N
                if (i == vacc(v, 1) | i == vacc(v, 2) )
                    ds(t, i, r) = 0;
                else
                    for j = 1:N
                        ds(t, i, r) = ds(t, i, r) + network(i,j)*ds(t-1, j, r)*(1 - ds(t, i, r));
                    end
                end
            end
        end
    end
    average_risk = mean(ds, [2 3]);
    plot(average_risk,'LineWidth',2)
    hold on
    leg{v} = mat2str(vacc(v, :));
end
hold off
legend(leg,'Location', 'best')
ylabel('Risk');
xlabel('Year from beginning of simulation');
title('Risk of infection with two vaccination doses');

saveas(gcf, 'PS5_2_F2', 'png')
