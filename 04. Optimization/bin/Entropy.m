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
function Hf=Entropy(BinLabel)
BinLabel(isnan(BinLabel))=0;
szdata=size(BinLabel,1);
[~,ibin,iF]=unique(BinLabel,'rows');
histF=zeros(size(ibin,1),1);
pF=zeros(size(ibin,1),1);
hF=zeros(size(ibin,1),1);
for i=1:size(ibin,1)
    histF(i)=sum(iF==i);
    pF(i)=histF(i)/szdata;
    hF(i)=-pF(i).*log(pF(i));
end
Hf=sum(hF);
return