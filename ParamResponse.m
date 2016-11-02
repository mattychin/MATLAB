%% Mini Project: Predator Prey Dynamics

clear all, close all        

%% Model simulation: prey-/predator-only parameter response

% define original parameters
k1 = 0.47;
k2 = 0.02;
k3 = 0.76;

param = [k1 k2 k3;
         k1*2 k2 k3;
         k1*4 k2 k3;
         k1 k2 k3;
         k1 k2*2 k3;
         k1 k2*4 k3;
         k1 k2 k3;
         k1 k2 k3*2;
         k1 k2 k3*4];   % define different sets of input parameters
Timespan=[0 50];        % define simulation time range
InPop = [50 50];        % define initial populations

% parameter-response simulations
figure('Color',[1 1 1])
for i=1:length(param)
    [t,x] = ode45(@lotka_volterra_param, Timespan, InPop, [], param(i,:)); 
    subplot(3,3,i)
    plot(t,x,'LineWidth',2); ylabel('Population'), xlabel('Time')
    title(['k1=',num2str(param(i,1)),', k2=',num2str(param(i,2)),...
           ', k3=',num2str(param(i,3))]);
    legend('Hare (model)','Lynx (model)')
    set(gca, 'FontName', 'Arial','FontSize', 14)
end

% predator-only and prey-only simulations
InPop = [0  50;
         50 0]; 
     
figure('Color',[1 1 1])     
for i=1:length(InPop)
    [t,x] = ode45(@lotka_volterra_param, Timespan, InPop(i,:), [], param(1,:)); 
    subplot(2,1,i)
    plot(t,x,'LineWidth',2); ylabel('Population'), xlabel('Time')
    legend('Hare (model)','Lynx (model)')
    set(gca, 'FontName', 'Arial','FontSize', 14)
end
