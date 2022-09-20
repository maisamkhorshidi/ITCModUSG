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
%% Reading Index from OUT File
fileoutput=filename;
[~,~,raw]=xlsread([fldr '\03. Observation Wells.xlsx'],1);
well_row=raw(3:end,4);
well_col=raw(3:end,5);
obsnum=cell2mat(raw(3:end,7:end));
obsh=cell(size(obsnum,1),1);
obsind=cell(size(obsnum,1),1);
for i=1:size(obsnum,1)
    obsh{i}=obsnum(i,~isnan(obsnum(i,:)));
    obsind{i}=find(~isnan(obsnum(i,:)));
end
%% Saving
ss=true;
save([fldr '\Results\E_Reading_Output.mat'],'obsh','obsind','well_row','well_col',...
    'fileoutput','obsnum')
return