% Number of time periods
T = 80;

% This is where mu goes
mu = 0.16;
% mu for the beetles
mu_b = 5;

% This is where the carrying capacity K goes
K = 1000;
% K for the beetles
K_b = 1000000;

beta_b = 1000;
beta_k = 1/1000;

% Vector of initial conditions
inits = [60, 100, 250, 500, 750, 1000, 1500];

% Initial condition for the beetles
M_0 = 25;

hold on
for N_0 = inits

    % Initialize vector for T time periods.
    N = zeros([T 1]);
    M = zeros([T 1]);
    
    % Set initial population
    N(1) = N_0;
    M(1) = M_0;
    
    % Iterate over time periods, calculating the new population
    % at time i
    for i = 2:T
        % Beetles, gross
        M(i) = mu_b*M(i-1)*(1 - ((M(i-1) + beta_b*N(i-1))/K_b));
       
        % Koala
        N(i) = N(i-1) + mu*N(i-1)*(1 - ((N(i-1) + beta_k*M(i-1))/K));
    end

    plot(N)
end

xlabel('Time period')
ylabel('Koala population')
title('Koala population over time for various initial conditions')
legend(string(inits), 'Location', 'best')
saveas(gcf, './PS4_F6', 'png');
disp('simulation complete!')
hold off