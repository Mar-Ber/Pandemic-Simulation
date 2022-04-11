## Pandemic Simulation

The aim of the project is to simulate a simple polymorphic cellular automaton modeling the development of an epidemic, in which cells are described as systems of events discrete with controls. The states in the network will be Q1 precaution levels and state infection of members of the population at risk of the Q2 epidemic.

The simulator is a polymorphic automaton with double control in the form of tests on the presence of the coronavirus as well as mobility restrictions and other restrictions by the authorities. Calibration of the model is based on the actual data collected. Datastatistics were for Switzerland.

Cell states are defined with Q = Q1 x Q2, where:
* The Q1 state affects the cell moving and infecting others

    Q1 = {no_security_measures, infecting, self_protecting, protecting_others, organizing_protection}
![state_Q1](https://github.com/Mar-Ber/Pandemic-Simulation/blob/main/images/q2_state.PNG)
* Status Q2 is the health of the individual

    Q2 = {healthy, in_quarantine, infected, sick, infected_and_sick, in_hospital, recovered, dead}
    

