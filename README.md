# MicroController-LED-Mission-Impossible
Assembly Language project with PIC18 Microcontroller

Project Overview: Develop an LED lighting sequence to sync with 40seconds of a music piece.
Mission Impossible Theme Music was used as it offered a variety of slow and fast music sequences so as to showcase strength of project

Time delays were achieved through a variety of ways. 
1) dupnop: duplication of nop functions
2) Timer function in PIC18

In both methods, calculations had to be done on how long the time delays were necessary. Certain short time delay subroutines were created
for code reusability and modularity.
