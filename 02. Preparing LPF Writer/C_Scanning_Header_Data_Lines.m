function ss=C_Scanning_Header_Data_Lines(fldr,fldm)
%% Some Folder Movements
if exist([fldr '\Results\C_Scanning_Header_Data_Lines.mat'],'file')
    delete([fldr '\Results\C_Scanning_Header_Data_Lines.mat'])
end
%% Finding LPF File
dir1=dir(fldm);
for i=3:size(dir1,1)
    aa=dir1(i).name(end-2:end);
    cond=(strcmp(aa,'lpf') || strcmp(aa,'LPF') || strcmp(aa,'Lpf') || strcmp(aa,'lPf') ||...
            strcmp(aa,'lpF') || strcmp(aa,'LPf') || strcmp(aa,'LpF') ||...
            strcmp(aa,'lPF'));
    if cond
        filename=dir1(i).name;
        break
    elseif ~cond && i==size(dir1,1)
        error('LPF File Not Found in: \00. Modflow USG Files')
    end
end
%% Finding Header and Data Lines
lpf = importlpf([fldm '\' filename]);
datalines=[];
headerlines=[];
flagh=0;
flagd=0;
for i=1:size(lpf,1)
    if isempty(headerlines)
        for j=1:size(lpf,2)
            if strcmp(lpf(i,j),'#')
                break
            elseif j==size(lpf,2) && ~strcmp(lpf(i,j),'#')
                headerlines=[headerlines;{[1,i-1]}];
                flagh=0;
                flagd=1;
            end
        end
    else
        aa=str2double(lpf(i,1));
        if flagd==1 && ~isnan(aa) && i~=size(lpf,1)
            continue
        elseif flagd==1 && isnan(aa)
            datalines=[datalines;{[headerlines{end}(end)+1,i-1]}];
            h1=i;
            flagd=0;
            flagh=1;
            continue
        elseif flagd==1 && ~isnan(aa) && i==size(lpf,1)
            datalines=[datalines;{[headerlines{end}(end)+1,i]}];
        end
        h2=0;
        for j=1:size(lpf,2)
            if strcmp(lpf(i,j),'#') && flagh==1
                h2=i;
                break
            elseif j==size(lpf,2) && ~strcmp(lpf(i,j),'#') && flagh==1
                h2=i-1;
                headerlines=[headerlines;{[h1,h2]}];
                flagh=0;
                flagd=1;
                break
            end
        end
    end
end
%% Saving
ss=true;
save([fldr '\Results\C_Scanning_Header_Data_Lines.mat'],'headerlines','datalines','filename')
return