classdef Area < handle
    
    properties
        area_size;
        population_size;
        population;
        population_tested;
        
        healthy_nr;
        infected_nr;
        infandsick_nr;
        inquarantine_nr;
        recovered_nr;
        sick_nr;
        inhospital_nr;
        dead_nr;
        lockdown_period;
    end
    
    methods
        function obj = Area(area_size,population_size)
            obj.area_size = area_size;
            obj.population_size = population_size;
            obj.lockdown_period =[];
        end
        
        function InitArea(obj,infected_number)
            for i = 1:obj.population_size
                pos = randi([1 obj.area_size],1,2);
                if i <= infected_number
                    Population(i) = Person(pos(1), pos(2), ...
                        Values.infecting, Values.infected, i);
                else
                    Population(i) = Person(pos(1), pos(2), ...
                        Values.no_security_measures, Values.healthy, i);
                end
            end
            obj.population = Population;
        end
        
        function TestPopulation(obj)
            obj.population_tested = [];
            for i = 1:(Values.test_amount)
                tested_person = randi(obj.population_size);
                while (any(obj.population_tested(:) == tested_person) || (obj.population(tested_person).state_q2 == Values.dead)) 
                    tested_person = randi(obj.population_size);
                end
                obj.population_tested = [obj.population_tested; tested_person];
            end
        end
        
        function SimIteration(obj)
            AreaState = -ones(obj.area_size);
            AreaTest = zeros(obj.area_size);
            obj.TestPopulation();
            for i = 1:obj.population_size
                if obj.population(i).state_q2 ~= Values.dead 
                    AreaState(obj.population(i).pos_x,obj.population(i).pos_y) = ...
                        obj.population(i).state_q1;
                    if any(obj.population_tested(:) == i)
                        obj.population(i).is_tested = 1;
                    else
                        obj.population(i).is_tested = 0;
                    end
                    AreaTest(obj.population(i).pos_x,obj.population(i).pos_y) = ...
                        obj.population(i).is_tested;
                end
            end
            
            for i = 1:obj.population_size
                if obj.population(i).state_q2 ~= Values.dead
                    obj.population(i).DefineState(AreaState, AreaTest);
                end
            end
            
            if rand <= Values.Q1_3_prob
                for i = 1:obj.population_size
                    if (obj.population(i).state_q1 == Values.no_security_measures) || (obj.population(i).state_q1 == Values.self_protecting)
                        obj.population(i).state_q1 = Values.organizing_protection;
                    end
                    obj.population(i).lockdown = 1;
                end
            elseif rand <= Values.Q1_4_prob
                for i = 1:obj.population_size
                    if obj.population(i).state_q1 == Values.organizing_protection
                        obj.population(i).state_q1 = Values.no_security_measures;
                    end
                    obj.population(i).lockdown = 0;
                end
            end 
            obj.lockdown_period = [obj.lockdown_period, obj.population(1).lockdown];
            
            for i = 1:obj.population_size
                if obj.population(i).state_q2 ~= Values.dead
                    AreaState = obj.population(i).Move(AreaState);
                end
            end
            
            obj.healthy_nr = 0;
            obj.infected_nr = 0;
            obj.infandsick_nr = 0;
            obj.inquarantine_nr = 0;
            obj.recovered_nr = 0;
            obj.sick_nr = 0;
            obj.inhospital_nr = 0;
            obj.dead_nr = 0;
            
            for i = 1:obj.population_size
                if obj.population(i).state_q2 == Values.healthy
                    obj.healthy_nr = obj.healthy_nr + 1;
                end
                if obj.population(i).state_q2 == Values.infected
                    obj.infected_nr = obj.infected_nr + 1;
                end
                if obj.population(i).state_q2 == Values.infected_and_sick
                    obj.infandsick_nr = obj.infandsick_nr + 1;
                end
                if obj.population(i).state_q2 == Values.in_quarantine
                    obj.inquarantine_nr = obj.inquarantine_nr + 1;
                end
                if obj.population(i).state_q2 == Values.recovered
                    obj.recovered_nr = obj.recovered_nr + 1;
                end
                if obj.population(i).state_q2 == Values.sick
                    obj.sick_nr = obj.sick_nr + 1;
                end
                if obj.population(i).state_q2 == Values.in_hospital
                    obj.inhospital_nr = obj.inhospital_nr + 1;
                end
                if obj.population(i).state_q2 == Values.dead
                    obj.dead_nr = obj.dead_nr + 1;
                end
            end
            disp(['Healthy: ' num2str(obj.healthy_nr) ...
                 '   Infected: ' num2str(obj.infected_nr) ...
                 '   Infected and sick: ' num2str(obj.infandsick_nr) ...
                 '   In quarantine: ' num2str(obj.inquarantine_nr) ...
                 '   Recovered: ' num2str(obj.recovered_nr) ...
                 '   Sick: ' num2str(obj.sick_nr) ...
                 '   In hospital: ' num2str(obj.inhospital_nr) ...
                 '   Dead: ' num2str(obj.dead_nr) ...
                 ]);
        end
        
        function PlotArea(obj)
            figure(1);
            clf
            set(gcf,'color','w');
            xlim([0 obj.area_size]);
            ylim([0 obj.area_size]);
            hold on;
            grid minor;
            for i = 1:obj.population_size
                obj.population(i).Plot();
            end
        end
 
    end
    
end
