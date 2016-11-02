%% Simulation code for parameter fitting and stability analysis

clear all, close all        
 
%% Import Hudson Bay Company's data
 
[~, ~, raw] = xlsread('/Users/matthew/Documents/MATLAB/SysMIC/Mini_project/Fur_Pelts_1900_to_1920.xlsx','Fur Pelts (1900 to 1920)');
raw = raw(2:end,:);
 
% Create output variable
data = reshape([raw{:}],size(raw));
 
% Allocate imported array to column variable names
Year = data(:,1);
Hare = data(:,2)/1000;
Lynx = data(:,3)/1000;
 
% Clear temporary variables
clearvars data raw;
 
%% Model parameter estimation
 
%------------------ Estimating k1 -----------------%
for i=1:19 
    Y(i) = (1/Hare(i+1))*(Hare(i+2)-Hare(i))/2; 
    X(i) = Lynx(i+1);
end
 
% q(2) = k1
q = polyfit(X,Y,1); % calculate linear regression
Yfit = polyval(q,X);
 
figure('Color',[1 1 1]), subplot(2,1,1)
plot(X,Y,'x','LineWidth',2), hold on
plot(X,Yfit,'LineWidth',2) 
ylabel('(1/Hare)*(dHare/dt)')
xlabel('Lynx population (x10^3)'),
title('Parameter Estimation')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
%-------------- Estimating k2 and k3 -------------%
for i=1:19 
    Y(i) = (1/Lynx(i+1))*(Lynx(i+2)-Lynx(i))/2; 
    X(i) = Hare(i+1);
end
 
% p(1) = k2, p(2) = k3
p = polyfit(X,Y,1); % calculate linear regression
Yfit = polyval(p,X);
 
subplot(2,1,2)
plot(X,Y,'x','LineWidth',2), hold on
plot(X,Yfit,'LineWidth',2) 
ylabel('(1/Lynx)*(dLynx/dt)')
xlabel('Hare population (x10^3)'),
set(gca, 'FontName', 'Arial','FontSize', 14)
 
%% Model simulation
 
global k1 k2 k3 
 
% Set parameter values 
k1 = abs(q(2));        % hare birth rate     
k2 = abs(p(1));        % predation/reproduction rate
k3 = abs(p(2));        % lynx death rate    
 
Timespan=[1900 1920];  % define simulation time range
InPop = [30 4];        % define initial populations
[t,x] = ode45(@lotka_volterra, Timespan, InPop); 
figure('Color',[1 1 1])
plot(t,x,'LineWidth',2), hold on
% Overlay Hudson Bay Company's data
plot(Year,Hare,'o','Color','b','LineWidth',2), hold on
plot(Year,Lynx,'x','Color','r','LineWidth',2)
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)','Hare (raw)','Lynx (raw)')
title('Lynx-Hare Dynamics: Parameter Fitting')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
%-------------- Steady state and perturbation -------------------%
 
% For steady state, dx(1)/dt = 0 and dx(2)/dt = 0
    %   The following will need to be satisfied:
    %   number of prey at equilibrium (n_Prey) = k3/k2
    %   number of predators (n_Predator) = k1/k2 
 
% Set equilibrium populations
n_Prey = k3/k2;
n_Predator = k1/k2;
 
% Run using n_Prey and n_Predator as initial populations
figure('Color',[1 1 1]);
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey n_Predator]);
subplot(2,2,1)
plot(t,x,'LineWidth',2); ylim([0 50])
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
title('Steady State')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
% n_Prey+10, n_Predator
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey+10 n_Predator]);
subplot(2,2,2)
plot(t,x,'LineWidth',2); ylim([0 50])
title('Prey+10, Predator');
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
% n_Prey, n_Predator+10
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey n_Predator+10]);
subplot(2,2,3)
plot(t,x,'LineWidth',2); ylim([0 50])
title('Prey, Predator+10');
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
% n_Prey+10, n_Predator+10
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey+10 n_Predator+10]);
subplot(2,2,4)
plot(t,x,'LineWidth',2); ylim([0 50])
title('Prey+10, Predator+10');
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
%-------- gradual increase in prey population ----------%
figure('Color',[1 1 1]);
 
% n_Prey+5
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey+10 n_Predator]);
subplot(3,2,1)
plot(t,x,'LineWidth',2); 
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
title('Prey+10')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
% n_Prey+100
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey+100 n_Predator]);
subplot(3,2,3)
plot(t,x,'LineWidth',2); 
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
title('Prey+100')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
% n_Prey+1000
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey+1000 n_Predator]);
subplot(3,2,5)
plot(t,x,'LineWidth',2); 
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
title('Prey+1000')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
%-------- gradual increase in predator population ----------%
 
% n_Predator+10
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey n_Predator+10]);
subplot(3,2,2)
plot(t,x,'LineWidth',2); 
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
title('Predator+10')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
% n_Predator+100
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey n_Predator+100]);
subplot(3,2,4)
plot(t,x,'LineWidth',2); 
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
title('Predator+100')
set(gca, 'FontName', 'Arial','FontSize', 14)
 
% n_Predator+1000
[t,x] = ode45(@lotka_volterra, Timespan, [n_Prey n_Predator+1000]);
subplot(3,2,6)
plot(t,x,'LineWidth',2); 
ylabel('Population (x10^3)'), xlabel('Year')
legend('Hare (model)','Lynx (model)')
title('Predator+1000')
set(gca, 'FontName', 'Arial','FontSize', 14)

