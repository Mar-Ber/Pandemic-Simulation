classdef Person < handle
    
    properties
        id;
        pos_x;
        pos_y;
        state_q1;
        state_q2;
        move_prob;
        is_tested;
        tested_positive;
        lockdown;
        I_t;
        S_t;
        H_t;
        Q_t;
        R_t;
    end
    
    methods
        function obj = Person(pos_x_, pos_y_, q1, q2, id_)
            if nargin > 0
                obj.pos_x = pos_x_;
                obj.pos_y = pos_y_;
                obj.state_q1 = q1;
                obj.state_q2 = q2;
                obj.id = id_;
                obj.move_prob = Values.M1_prob;
                obj.I_t = Values.I_time;
                obj.S_t = Values.S_time;
                obj.H_t = Values.H_time;
                obj.Q_t = Values.Q_time;
                obj.R_t = Values.R_time;
                obj.is_tested = 0;
                obj.tested_positive = Values.healthy;
                obj.lockdown = 0;
            end
        end
        
        function DefineState(obj, AreaState, AreaTest)
            
            if obj.state_q2 == Values.infected
                obj.I_t = obj.I_t - 1;
                if obj.I_t == 0
                    if rand <= 1 - Values.infect_again_prob
                    	obj.state_q1 = Values.no_security_measures;
                    	obj.state_q2 = Values.recovered;
                        obj.R_t = Values.R_time;
                    else
                    	obj.state_q1 = Values.infecting;
                    	obj.state_q2 = Values.infected_and_sick;
                    end   
                end
                
            elseif obj.state_q2 == Values.sick
                obj.S_t = obj.S_t - 1;
                if obj.S_t == 0
                    if rand <= 1 - Values.covid_prob
                    	obj.state_q1 = Values.no_security_measures;
                    	obj.state_q2 = Values.healthy;
                    else
                    	obj.state_q1 = Values.infecting;
                    	obj.state_q2 = Values.infected_and_sick;
                    end   
                end
                
            elseif obj.state_q2 == Values.in_hospital
                obj.H_t = obj.H_t - 1;
                if obj.H_t == 0
                    if rand <= Values.recovery_prob
                    	obj.state_q1 = Values.no_security_measures;
                    	obj.state_q2 = Values.recovered;
                        obj.R_t = Values.R_time;
                    else
                    	obj.state_q1 = Values.protecting_others;
                    	obj.state_q2 = Values.dead;
                        obj.pos_x = nan;
                        obj.pos_y = nan;
                    end   
                end
                
            elseif obj.state_q2 == Values.in_quarantine
                obj.Q_t = obj.Q_t - 1;
                if obj.Q_t == 0
                    if obj.tested_positive == Values.infected || rand <= Values.true_quarantine_prob
                        obj.state_q1 = Values.no_security_measures;
                        obj.state_q2 = Values.recovered;
                        obj.R_t = Values.R_time;
                    else
                        obj.state_q1 = Values.no_security_measures;
                    	obj.state_q2 = Values.healthy;
                    end
                    obj.tested_positive = Values.healthy;
                end
                
            elseif obj.state_q2 == Values.recovered
                obj.R_t = obj.R_t - 1;
                if obj.R_t == 0
                    obj.state_q1 = Values.no_security_measures;
                    obj.state_q2 = Values.healthy;
                end
                
            elseif obj.state_q2 == Values.healthy && rand <= Values.sick_prob
                obj.state_q1 = Values.no_security_measures;
                obj.state_q2 = Values.sick;
                obj.S_t = Values.S_time;
                
            elseif obj.state_q2 == Values.infected_and_sick
                if rand <= Values.hospital_prob
                    obj.state_q1 = Values.protecting_others;
                    obj.state_q2 = Values.in_hospital;
                    obj.H_t = Values.H_time;
                else
                    obj.state_q1 = Values.no_security_measures;
                    obj.state_q2 = Values.recovered;
                    obj.R_t = Values.R_time;
                end
                
            elseif obj.state_q2 == Values.healthy
                for i = max(obj.pos_x-1, 1):min(obj.pos_x+1, Values.area_size)
                    for j = max(obj.pos_y-1, 1):min(obj.pos_y+1, Values.area_size)
                        if ~(i == obj.pos_x && j == obj.pos_y)
                            if AreaState(i,j) == Values.infecting 
                                if AreaTest(i,j) == 1
                                    obj.state_q1 = Values.protecting_others;
                                    obj.state_q2 = Values.in_quarantine;
                                    obj.Q_t = Values.Q_time;
                                elseif rand <= Values.infection_prob
                                    obj.state_q1 = Values.infecting;
                                    obj.state_q2 = Values.infected;
                                    obj.I_t = Values.I_time;
                                end
                            end
                        end
                    end
                end
            end    
            if obj.state_q1 == Values.infecting && obj.is_tested == 1
                obj.state_q1 = Values.protecting_others;
                obj.state_q2 = Values.in_quarantine;
                obj.Q_t = Values.Q_time;
                obj.tested_positive = Values.infected;
            end
            
            if obj.state_q1 == Values.no_security_measures 
                if rand <= Values.Q1_1_prob
                    obj.state_q1 = Values.self_protecting;
                end
                
            elseif obj.state_q1 == Values.self_protecting
                if rand <= Values.Q1_2_prob
                    obj.state_q1 = Values.no_security_measures ;
                end
            end
            
        end
        
        function AreaState = Move(obj, AreaState)
            if obj.state_q1 == Values.no_security_measures
                obj.move_prob = Values.M1_prob;
            elseif obj.state_q1 == Values.infecting
                if obj.lockdown == 1
                    obj.move_prob = Values.M5_prob;
                else
                    obj.move_prob = Values.M2_prob;
                end
            elseif obj.state_q1 == Values.protecting_others
                obj.move_prob = Values.M3_prob;
            elseif obj.state_q1 == Values.self_protecting
                obj.move_prob = Values.M4_prob;
            elseif obj.state_q1 == Values.organizing_protection
                obj.move_prob = Values.M5_prob;
            end
            
            if rand <= obj.move_prob
                new_positions = [];
                for i = max(obj.pos_x-1, 1):min(obj.pos_x+1, Values.area_size)
                    for j = max(obj.pos_y-1, 1):min(obj.pos_y+1, Values.area_size)
                        if ~(i == obj.pos_x && j == obj.pos_y)
                            if AreaState(i,j) == -1
                                new_positions = [new_positions; [i j]];
                            end
                        end
                    end
                end
                if ~isempty(new_positions)
                    AreaState(obj.pos_x, obj.pos_y) = -1;
                    new_position = randi(length(new_positions));
                    obj.pos_x = new_positions(new_position, 1);
                    obj.pos_y = new_positions(new_position, 2);
                    AreaState(obj.pos_x, obj.pos_y) = 1;
                end
            end
        end
        
        function Plot(obj)
            if obj.state_q2 == Values.healthy
                colour = [0.4660 0.6740 0.1880];
            elseif obj.state_q2 == Values.infected
                colour = [1 0 0];
            elseif obj.state_q2 == Values.infected_and_sick
                colour = [0.4940 0.1840 0.5560];
            elseif obj.state_q2 == Values.in_quarantine
                colour = [0.9290 0.6940 0.1250];
            elseif obj.state_q2 == Values.recovered
                colour = [0 0.4470 0.7410];
            elseif obj.state_q2 == Values.sick
                colour = [0.8500 0.3250 0.0980];
            elseif obj.state_q2 == Values.in_hospital
                colour = [0.3010 0.7450 0.9330];
            elseif obj.state_q2 == Values.dead
                %colour = [0 0 0];
                colour = -1;
            end
            if colour ~= -1
                plot(obj.pos_x, obj.pos_y, '.', 'MarkerSize', 5,...
                    'MarkerEdgeColor', colour, 'MarkerFaceColor', colour);
            end
        end
        
    end
    
end
