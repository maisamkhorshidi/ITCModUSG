function ss=D_Scanning_Index_From_LPF(fldr,fldm)
%% Some Folder Movements
if exist([fldr '\Results\D_Scanning_Index_From_LPF.mat'],'file')
    delete([fldr '\Results\D_Scanning_Index_From_LPF.mat'])
end
%% Loading Data
load([fldr '\Results\B_Material_Data_for_Detection.mat'])
load([fldr '\Results\C_Scanning_Header_Data_Lines.mat'])
%% Indexing Read LPF File
fileinput=filename;
indexi=cell(numel(datalines),1);
indexj=cell(numel(datalines),1);
lpfd1=cell(numel(datalines),1);
lpfh1=cell(numel(datalines),1);
for ii=1:numel(datalines)
    eval(['aa=import_data_1("' [fldm '\' fileinput] '",[' num2str(datalines{ii}(1)),...
        ',' num2str(datalines{ii}(2)) ']);' ]);
    for k=1:size(aa,1)
        for h=1:size(aa,2)
            if ismissing(aa(k,h))
                aa(k,h)="";
            end
        end
    end
    lpfd1{ii}=aa;
    eval(['bb=import_header_1("' [fldm '\' fileinput] '",' num2str(headerlines{ii}(1)) ',' num2str(headerlines{ii}(2)) ');']);
    lpfh1{ii}=bb;
    indexi{ii}=cell(size(datacode));
    indexj{ii}=cell(size(datacode));
    for k=1:numel(datacode)
        str=datacode{k};
        for i=1:size(aa,1)
            for j=1:size(aa,2)
                disp(['part=' num2str(ii) ' of ' num2str(numel(datalines)) ', var=',num2str(k),' , i=',num2str(i),' of ',num2str(size(aa,1)),...
                    ' , j=', num2str(j),' of ',num2str(size(aa,2))]);
                data=aa(i,j);
                if strcmp(data,str)
                    indexi{ii}{k}=[indexi{ii}{k},i];
                    indexj{ii}{k}=[indexj{ii}{k},j];
                end
            end
        end
    end
end
%% Saving
ss=true;
save([fldr '\Results\D_Scanning_Index_From_LPF.mat','lpfd1','lpfh1','indexi','indexj','fileinput')
return