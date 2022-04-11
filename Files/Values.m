classdef Values
    properties (Constant)

    %Simulation parameters
    sim_delay = 0.000000001;
    sim_steps = 541;
    
    %Entry data
    area_size = floor(3519/4);
    population = 8704;    
    init_infected = 4*13;
    test_amount = 17;
    
    %Probability
    M1_prob = 0.5;%ok
    M2_prob = Values.M1_prob;%ok
    M3_prob = 0; %ok
    M4_prob = 0.5*Values.M1_prob;%ok
    M5_prob = 0.25*Values.M1_prob;%ok
    
    Q1_1_prob = 0.739/2;%ok
    Q1_2_prob = 0.261/2;%ok
    Q1_3_prob = 0.3544/2;%ok
    Q1_4_prob = 0.6456/2;%ok
    
    infection_prob = 0.95;
    infect_again_prob = 0.45; %ok
    sick_prob = 2/365; %ok
    covid_prob = 0.1; %ok
    hospital_prob = 0.33; %ok
    recovery_prob = 0.982;
    true_quarantine_prob = Values.infection_prob;%ok
    
    %Times
    I_time = 16;%ok
    Q_time = 10;%ok
    S_time = 7;%ok
    H_time = 7;%ok
    R_time = 210;%ok
    
    %States Q1
    no_security_measures = 0;
    infecting = 1;
    protecting_others = 2;
    self_protecting = 3;
    organizing_protection = 4;
    
    %States Q2
    healthy = 0;
    in_quarantine = 1;
    infected = 2;
    sick = 3;
    infected_and_sick = 4;
    in_hospital = 5;
    recovered = 6;
    dead = 7;

    end
end