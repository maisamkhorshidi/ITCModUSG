function ss=B_Material_Data_for_Detection(fldr)
%% Some Folder Movements
if exist([fldr '\Results\B_Material_Data_for_Detection.mat'],'file')
    delete([fldr '\Results\B_Material_Data_for_Detection.mat'])
end
%% Converting numeric values of data indices to strings for LPF File
aa=xlsread([fldr '\02. Negative Values.xlsx'],1);
a1=aa(:,1);
a2=aa(:,2);
a3=aa(:,3);
datacodenum=[a1',a2',a3'];
datacode=cell(size(datacodenum));
for i=1:numel(datacode)
    aa=num2str(datacodenum(i));
    ind=strfind(aa,'.');
    inde=strfind(aa,'e');
    if isempty(ind) && isempty(inde)
        cc=[aa,'.0'];
    elseif ~isempty(ind) && isempty(inde)
        cc=aa;
    elseif ~isempty(inde)
        cc=[];
        for j=1:100
            num=datacodenum(i);
            ee=10^(-(j-8));
            rr=fix(num./ee);
            mm=mod(num,ee);
            if isempty(cc) && ee==0.1
                cc=[cc,'0.'];
            elseif ~isempty(cc) && ~contains(cc,'.') && ee==0.1
                cc=[cc,'.'];
            end
            if rr==0 && mm~=0
                cc=[cc,num2str(rr)];
            elseif rr~=0 && mm~=0
                hh=num2str(rr);
                cc=[cc,hh(end)];
            elseif rr==0 && mm==0
                break
            elseif rr~=0 && mm==0
                hh=num2str(rr);
                cc=[cc,hh(end)];
                break
            end
        end
    end
    inddot=strfind(cc,'.');
    dd=[];
    for j=1:inddot-2
        dd=[dd,'0'];
    end
    if strcmp(cc(1:inddot-2),dd)
        cc(1:inddot-2)=[];
    end
    datacode{i}=cc;
end
%% Saving
ss=true;
save([fldr '\Results\B_Material_Data_for_Detection.mat'],'datacode')
return
