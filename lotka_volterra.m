function dx = lotka_volterra(t,x)
% Function to simulate a 3-parameter Lotka-Volterra model with 
% exponential growth assumption

% Inputs: 
%   t - time: unused variable as the first derivatives in the system
%       are time independent
%   x - vector containing populations of predator x(1) and prey x(2) 
% Output:
%   dx - rate of change of the populations

%-------------- Grant access to global parameters--------------%
% k1 = prey birth rate
% k2 = predation/predator reproduction rate
% k3 = predator death rate
global k1 k2 k3

%------------------ ODEs ------------------%
% Definition of the ODEs
% x(1) = Number of hares 
% x(2) = Number of lynx

% define ODEs
dx = [0;0];
dx(1) = k1 * x(1) - k2 * x(1) * x(2);
dx(2) = k2 * x(1) * x(2) - k3 * x(2); 

end

