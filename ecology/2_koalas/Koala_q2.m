% Number of time periods
T = 30;

% Vector of initial conditions
inits = [1, 100, 250, 500, 750, 1000, 1500];
% inits = [2000];
hold on
for N_0 = inits

    % Initialize vector for T time periods.
    N = zeros([T 1]);

    % Set initial population
    N(1) = N_0;

    % This is where mu goes
    mu = 0.16;

    % This is where the carrying capacity K goes
    K = 1000;

    % Iterate over time periods, calculating the new population
    % at time i
    for i = 2:T
       N(i) = N(i-1) + mu*N(i-1)*(1 - N(i-1)/K);
    end

    plot(N)
end

xlabel('Time period')
ylabel('Koala population')
title('Koala population over time for various initial conditions')
legend(string(inits), 'Location', 'best')
saveas(gcf, './PS4_F3', 'png');
disp('simulation complete!')
hold off