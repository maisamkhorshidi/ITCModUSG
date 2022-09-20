function [y,simcal,simall,simobs,mi,vi,pen,param]=fittness(x,indexi,indexj,...
    lpfd1,lpfh1,fileinput,fileoutput,obsh,obsind,well_row,well_col,...
    obsnum,numb,hclb,fldt,fldop,fileexe)
param=x;
y=zeros(size(param,1),2);
simcal=cell(size(param,1),1);
simall=cell(size(param,1),1);
simobs=cell(size(param,1),1);
mi=zeros(size(param,1),numel(obsh));
vi=zeros(size(param,1),numel(obsh));
pen=zeros(size(param,1),1);
%% Assigning Penalty
hcind=zeros(size(param));
for i=1:size(param,1)
    for j=1:size(param,2)
        ind=find(hclb(:,j)>=param(i,j),1,'first');
        if isempty(ind)
            hcind(i,j)=size(hclb,1);
        else
            hcind(i,j)=ind-1;
        end
    end
end
[~,~,ia]=unique(hcind,'rows');
for i=1:max(ia)
    if sum(ia==i)>1
        pen(ia==i)=1;
    end
end
for iii=1:size(param,1)
    %% Preparing Strings
    strdata=cell(size(param(iii,:)));
    for i=1:numel(strdata)
        aa=sprintf('%5.9f',param(iii,i));
        strdata{i}=aa;
    end
    %% Contructing LPF
    lpfd=cell(size(lpfd1));
    lpfh=cell(size(lpfh1));
    for ii=1:numel(indexi)
        aa=lpfd1{ii};
        for k=1:numel(indexi{ii})
            rplc=strdata{k};
            if ~isempty(indexi{ii}{k})
                for j=1:numel(indexi{ii}{k})
                    aa(indexi{ii}{k}(j),indexj{ii}{k}(j))=rplc;
                end
            end
        end
        maxc=maxchar(aa);
        space=cell(maxc,1);
        for hh=1:maxc
            if hh==1
                space{hh}=" ";
            else
                space{hh}=space{hh-1}+" ";
            end
        end
        aa1=aa;
        for hh=1:size(aa,1)
            for kk=1:size(aa,2)
                lna=strlength(aa(hh,kk));
                if kk==size(aa,2) && ~strcmp(aa(hh,kk),"")
                    if (maxc-lna)==0
                        aa1(hh,kk)=aa(hh,kk);
                    else
                        aa1(hh,kk)=space{maxc-lna}+aa(hh,kk);
                    end
                elseif kk==size(aa,2) && strcmp(aa(hh,kk),"")
                    % do nothing
                elseif kk<size(aa,2) && ~strcmp(aa(hh,kk),"")
                    if (maxc-lna)==0
                        aa1(hh,kk)=aa(hh,kk)+" ";
                    else
                        aa1(hh,kk)=space{maxc-lna}+aa(hh,kk)+" ";
                    end
                elseif kk<size(aa,2) && strcmp(aa(hh,kk),"")
                    % do nothing
                end
            end
        end
        lpfd{ii}=cell(size(aa1,1),1);
        for hh=1:size(aa1,1)
            lpfd{ii}{hh}=aa1(hh,1);
            for kk=2:size(aa1,2)
                lpfd{ii}{hh}=lpfd{ii}{hh}+aa1(hh,kk);
            end
        end
        lpfh{ii}=cell(size(lpfh1{ii},1),1);
        for hh=1:size(lpfh1{ii},1)
            lpfh{ii}{hh}=lpfh1{ii}(hh);
        end
    end
    %% Writing LPF
    fid01=fopen([fldt '\' fileinput],'w');
    for hh=1:size(lpfd,1)
        for kk=1:size(lpfh{hh},1)
            fprintf(fid01,'%s \r\n',lpfh{hh}{kk});
        end
        for jj=1:size(lpfd{hh},1)
            fprintf(fid01,'%s \r\n',lpfd{hh}{jj});
        end
    end
    fclose('all');
    %% Running MODFLOW
    cd(fldt)
    dos([fileexe ' ' fileinput(1:end-4) '.mfn'])
    cd(fldop)
    status=ans;
    if status~=0
        warning('MFN RUN not Successful!')
        y(iii,1)=-1e8;% MI
        y(iii,2)=1e8;% VI
        simobs{iii}=nan;
        simall{iii}=nan;
        mi(iii,:)=nan;
        vi(iii,:)=nan;
    else
        %% Reading Results
        result = import_result([fldt '\' fileoutput]);
        indw=zeros(size(obsh,1),1);
        simall{iii}=zeros(size(obsnum));
        for j=1:size(result,1)
            if ismissing(result(j,1))
                continue
            else
                for w=1:numel(well_row)
                    wr=well_row{w};
                    wc=well_col{w};
                    if strcmp(result{j,1},wr)
                        indw(w)=indw(w)+1;
                        if str2double(result(j,wc+1))==-888
                            simall{iii}(w,indw(w))=nan;
                        else
                            simall{iii}(w,indw(w))=str2double(result(j,wc+1));
                        end
                    end
                end
            end
        end
        simcal{iii}=cell(size(obsh));
        for i=1:numel(obsh)
            simcal{iii}{i}=simall{iii}(i,obsind{i});
            mino=min(obsh{i})-0.0001.*(max(obsh{i})-min(obsh{i}));
            maxo=max(obsh{i})+0.0001.*(max(obsh{i})-min(obsh{i}));
            diso=mino:(maxo-mino)/(numb):maxo;
            bino=zeros(numel(obsh{i}),1);
            bins=zeros(numel(obsh{i}),1);
            for j=1:numel(obsh{i})
                indo=find(diso>=obsh{i}(j),1,'first')-1;
                bino(j)=indo;
                inds=find(diso>=simcal{iii}{i}(j),1,'first');
                if isempty(inds)
                    bins(j)=nan;
                elseif inds==1
                    bins(j)=nan;
                else
                    bins(j)=inds-1;
                end
            end
            Ho=Entropy(bino);
            mi(iii,j)=MutualInformation([bins,bino])/Ho;
            vi(iii,j)=VariationInformation([bins,bino])/Ho+pen(iii);
        end
        for i=1:numel(obsh)
            simobs{iii}=[simobs{iii};[obsh{i}',simcal{iii}{i}']];
        end
        %% Objective Function
        y(iii,:)=[-mi(iii,j)+pen(iii),vi(iii,j)+pen(iii)];
    end
end
return