clc
clear
%% Inputs
Npop=1;
NDis=20;
NumGen=1;
Nbin=10;
close all
fclose('all');
%% Initializing
[fldr,fldm,fldl,fldpl,fldpo,fldop,fldt]=Initialization();
addpath(genpath(fldr))
%% Executing
% Latin Hyper Cube Sampling
ss1=A_LatinHyperCubeSampling(NDis,Npop,fldr,fldl);
% Preparing LPF Writer
ss2=B_Material_Data_for_Detection(fldr);
ss3=C_Scanning_Header_Data_Lines(fldr,fldm);
ss4=D_Scanning_Index_From_LPF(fldr,fldm);
% Preparing Output Reader
ss5=E_Reading_Output(fldr,fldm);
% Running NSGA-II Optimization
ss6=NSGAII(Npop,NumGen,Nbin,fldr,fldm,fldt,fldop);

