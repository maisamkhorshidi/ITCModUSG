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
function lpf = importlpf(filename)
opts = delimitedTextImportOptions("NumVariables", 15);
opts.DataLines = [1, Inf];
opts.Delimiter = " ";
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "b", "ILPFCB", "HDRY", "NPLPF", "IKCFLAG", "Options", "VarName12", "VarName13", "VarName14", "VarName15"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";
opts = setvaropts(opts, ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "b", "ILPFCB", "HDRY", "NPLPF", "IKCFLAG", "Options", "VarName12", "VarName13", "VarName14", "VarName15"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "b", "ILPFCB", "HDRY", "NPLPF", "IKCFLAG", "Options", "VarName12", "VarName13", "VarName14", "VarName15"], "EmptyFieldRule", "auto");
lpf = readmatrix(filename, opts);
return