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
function ss=E_Reading_Output(fldr,fldm)
%% Some Folder Movements
if exist([fldr '\Results\E_Reading_Output.mat'],'file')
    delete([fldr '\Results\E_Reading_Output.mat'])
end
%% Finding LPF File
dir1=dir(fldm);
for i=3:size(dir1,1)
    aa=dir1(i).name(end-2:end);
    cond=(strcmp(aa,'out') || strcmp(aa,'OUT') || strcmp(aa,'Out') || strcmp(aa,'oUt') ||...
            strcmp(aa,'ouT') || strcmp(aa,'OUt') || strcmp(aa,'OuT') ||...
            strcmp(aa,'oUT'));
    if cond
        filename=dir1(i).name;
        break
    elseif ~cond && i==size(dir1,1)
        error('OUT File Not Found in: \00. Modflow USG Files')
    end
end
%% Reading Index from Excel File
fileoutput=filename;
[~,~,raw]=xlsread([fldr '\03. Observation Wells.xlsx'],1);
well_id=cell2mat(raw(3:end,2));
obsnum=cell2mat(raw(3:end,4:end));
obsh=cell(size(obsnum,1),1);
obsind=cell(size(obsnum,1),1);
for i=1:size(obsnum,1)
    obsh{i}=obsnum(i,~isnan(obsnum(i,:)));
    obsind{i}=find(~isnan(obsnum(i,:)));
end
%% Reading Index from OUT File
result = import_result1([fldm '\' filename]);
well_row=cell(numel(well_id),1);
well_col=cell(numel(well_id),1);
flag=0;
for i=1:size(result,1)
    disp(['Reading Output # ' num2str(i) ' of ' num2str(size(result,1))])
    if  ~ismissing(result(i,1))
        aa=char(result(i,1));
    end
    if ~ismissing(result(i,1)) && strcmp(result(i,1),'1..') && flag==0
        nn=0;
        for j=2:size(result,2)
            if ~ismissing(result(i,j))
                nn=nn+1;
            end
        end
        if sum((((well_id-str2double(aa(1:end-2))+1)<=nn).*((well_id-str2double(aa(1:end-2))+1)>0))==1)>0
            ind=find((((well_id-str2double(aa(1:end-2))+1)<=nn).*((well_id-str2double(aa(1:end-2))+1)>0))==1);
            for k=1:numel(ind)
                well_row{ind(k)}=[well_row{ind(k)},i];
                well_col{ind(k)}=[well_col{ind(k)},well_id(ind(k))-str2double(aa(1:end-2))+2];
            end
        end
        flag=1;
    elseif flag==1 && ~ismissing(result(i,1))
        if sum((((well_id-str2double(aa(1:end-2))+1)<=nn).*((well_id-str2double(aa(1:end-2))+1)>0))==1)>0
            ind=find((((well_id-str2double(aa(1:end-2))+1)<=nn).*((well_id-str2double(aa(1:end-2))+1)>0))==1);
            for k=1:numel(ind)
                well_row{ind(k)}=[well_row{ind(k)},i];
                well_col{ind(k)}=[well_col{ind(k)},well_id(ind(k))-str2double(aa(1:end-2))+2];
            end
        end
    end
end
%% Saving
ss=true;
save([fldr '\Results\E_Reading_Output.mat'],'obsh','obsind','well_row','well_col',...
    'fileoutput','obsnum')
return