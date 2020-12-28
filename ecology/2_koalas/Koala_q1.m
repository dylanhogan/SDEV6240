% Number of time periods
T = 30;

% Initialize vector for T time periods.
N = zeros([T 1]);

% Set initial population
N_0 = 1;
N(1) = N_0;

% This is where mu goes
mu = 0.16;

% Iterate over time periods, calculating the new population
% at time i
for i = 2:T
   N(i) = N(i-1) + mu*N(i-1);
end

plot(N)
xlabel('Time period')
ylabel('Koala population')
title('Koala population over time')
saveas(gcf, './PS4_F2', 'png');
disp('simulation complete!') 
