% Number of time periods
T = 30;

% Vector of initial conditions
inits = [1000];
% inits = [2000];
hold on
for N_0 = inits

    % Initialize vector for T time periods.
    N = zeros([T 1]);

    % Set initial population
    N(1) = N_0;

    % This is where mu goes
    mu_b = 2;

    % This is where the carrying capacity K goes
    K_b = 125000;

    % Iterate over time periods, calculating the new population
    % at time i
    for i = 2:T
       N(i) = N(i-1) + mu*N(i-1)*(1 - N(i-1)/K);
    end

    plot(N)
end

xlabel('Time period')
ylabel('Beetle population')
title('Beetle population over time for various initial conditions')
legend(string(inits), 'Location', 'best')
saveas(gcf, './PS4_F4', 'png');
disp('simulation complete!')
hold off