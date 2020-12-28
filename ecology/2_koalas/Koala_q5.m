% Number of time periods
T = 30;

% This is where mu goes
mu = 0.16;
mu_s = (1/8)*(1/4);

% This is where the carrying capacity K goes
K = 1000;

N_0 = 1000;
% Vector of initial conditions
inits = [0, 1, 2, 3, 4];
% inits = [2000];
hold on
for S_0 = inits

    % Initialize vector for T time periods.
    N = zeros([T 1]);
    S = zeros([T 1]);
    % Set initial population
    N(1) = N_0;
    S(1) = S_0;
    % Iterate over time periods, calculating the new population
    % at time i
    for i = 2:T
       K_s = N(i-1)/12;
       S(i) = S(i-1) + mu_s*S(i-1)*(1 - S(i-1)/K_s);
       N_temp = N(i-1)- 12*S(i-1);
       N(i) = N_temp + mu*N_temp*(1 - N_temp/K);
    end

    plot(N)
end

xlabel('Time period')
ylabel('Koala population')
title('Koala population over time for various initial snake populations')
legend(string(inits), 'Location', 'best')
saveas(gcf, './PS4_F7', 'png');
disp('simulation complete!')
hold off