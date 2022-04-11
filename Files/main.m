clear all
close all

area = Area(Values.area_size, Values.population);
area.InitArea(Values.init_infected);

healthy = [];
infected = [];
infandsick = [];
inquarantine = [];
recovered = [];
sick = [];
inhospital = [];
dead = [];

for i=1:Values.sim_steps
    disp('-=-=-=-=-=-=-=-=-=-=-=-');
    disp(['Iteration number: ' num2str(i)]);
    area.SimIteration();
    area.PlotArea();
    pause(Values.sim_delay);
    
    healthy = [healthy, area.healthy_nr];
    infected = [infected, area.infected_nr];
    infandsick = [infandsick, area.infandsick_nr];
    inquarantine = [inquarantine, area.inquarantine_nr];
    recovered = [recovered, area.recovered_nr];
    sick = [sick, area.sick_nr];
    inhospital = [inhospital, area.inhospital_nr];
    dead = [dead, area.dead_nr];
end

lockdown_period = area.lockdown_period;
x = 1:1:Values.sim_steps;
figure(2);
hold on; grid on;
plot(x, infected, 'color', [1 0 0]);
plot(x, infandsick, 'color', [0.4940 0.1840 0.5560]);
plot(x, inquarantine, 'color', [0.9290 0.6940 0.1250]);
plot(x, inhospital, 'color', [0.3010 0.7450 0.9330]);
plot(x, dead, 'color', [0 0 0]);
sum = infected + infandsick + inquarantine + inhospital;
plot(x, sum, 'color', [0.6350 0.0780 0.1840]);
xlabel('Day');
ylabel('Number of people');
title('The course of the COVID-19 epidemic');
legend('Infected','Infected and sick','In quarantine','In hospital','Dead','Sum of infected');

figure(3);
hold on; grid on;
plot(x, healthy, 'color', [0.4660 0.6740 0.1880]);
plot(x, recovered, 'color', [0 0.4470 0.7410]);
plot(x, sick, 'color', [0.8500 0.3250 0.0980]);
for i=1:Values.sim_steps
    if lockdown_period(i) == 1
        plot(i, 0, 's', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r')
    end
end
xlabel('Day');
ylabel('Number of people');
title('The course of the COVID-19 epidemic');
legend('Healthy','Recovered','Sick','Lockdown');




