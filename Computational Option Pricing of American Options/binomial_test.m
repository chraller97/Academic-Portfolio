function [S, V, t] = binomial_test(r, sigma, S0, K, T, putcall, M)
% binomial calculates the value of an American option given the input
% arguments using the binomial method

gamma = exp(2/M * log(K / S0));
M = M + 1; % Since MatLab is 1 indexed, we need to make space for S(0)
deltaT = T/(M-1);
beta = 1/2 * (gamma * exp(-r * deltaT) + exp((r + sigma^2)*deltaT));
u = beta + sqrt(beta^2 - gamma);
d = gamma / u;
p = (exp(r*deltaT) - d) / (u - d);
disc = exp(-r * deltaT);

t = 0:deltaT:T;

% First construct the evolution of asset values
S = zeros(M);
S(1, 1) = S0;
for i = 2:M
    S(1:i, i) = S0 .* u.^(0:(i-1)) .* d^((i-1):-1:0);
end

% Calculate the option values at time of maturity T
V = zeros(M);
if putcall == 1 % Call option
    V(:, M) = max(S(:, M) - K, 0);
else % Put option
    V(:, M) = max(K - S(:, M), 0);    
end

% Using backwards recursion we calculate the option values for t_m < T
for i = (M-1):-1:1
    Vcont = 




    for j = i:-1:1
        Vcont = disc * (p*V(j+1, i+1) + (1-p)*V(j, i+1)); % Continuation value = value of european option
        if putcall == 1
            V(j, i) = max(max(S(j, i) - K, 0), Vcont); % Test if the payoff is larger than the european option value
        else
            V(j, i) = max(max(K - S(j, i), 0), Vcont); % Same test for put option
        end
    end
end


end

