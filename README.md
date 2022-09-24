"# ITCModUSG" 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2022, Khorshidi et al. (2022)                             %
% All rights reserved. Please read the "license.txt" for license terms.   %
%                                                                         %
% Project Code: ITCModUSG                                                 %
% Project Title: Information Theory Diagnostic Calibration of MODFLOW-USG %
% Publisher: Khorshidi et al. (2022)                                      %
%                                                                         %
% Developer: Mohammad Sadegh Khorshidi                                    %
%                                                                         %
% Contact Info: msadegh.khorshidi.ak@gmail.com                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Instructions:
The first step requires the user to develop the case study’s hydro-geological 
model using MODFLOW-USG and place the native text files in “00. Modflow USG Files” 
folder of the software. Then, three excel files are required to prepare as inputs 
for the program. In “01. Hydrodynamic properties RANGE.xlsx” spreadsheet, the 
minimum, maximum and average values for any given hydro-geologic transport 
parameters should be determined. In order to make the input parameters detectable 
for ITCModUSG, unique (and preferably negative) values for transport parameters 
should be used in the development of the native MODFLOW-USG model, while those 
unique values should be entered in “02. Negative Values.xlsx” spreadsheet 
correspondingly. The Cell IDs of the observation wells and the observed heads 
should be entered into the “03. Observation Wells.xlsx” spreadsheet. One last 
step before the execution of ITCModUSG is to impose parameters’ constraints. 
To do so, “If_Clause.m” should be modified. By “ITCModUSG_Script.m”, first the 
program executes its Latin Hypercube Sampling module.  Then, it reads and prepares 
the necessary input parameters for the connection of MODFLOW to MATLAB®. Finally, 
the program executes the NSGA-II optimization module to obtain a set of paramters.