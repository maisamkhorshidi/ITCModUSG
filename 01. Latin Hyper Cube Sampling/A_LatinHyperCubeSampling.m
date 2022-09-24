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
function ss=A_LatinHyperCubeSampling(NDis,Npop,fldr,fldl)
%% Inputs
% numd=20;
% sz_smpl=48;
numd=NDis;
npop=Npop;
%% Some Folder Movements
copyfile([fldr '\If_Clause.m'],[fldl '\bin'])
if exist([fldr '\Results\A_LatinHyperCubeSampling.mat'],'file')
    delete([fldr '\Results\A_LatinHyperCubeSampling.mat'])
end
%% Reading Data
data=xlsread([fldr '\01. Hydrodynamic properties RANGE.xlsx'],1);
hk_lb=data(:,2);
hk_ub=data(:,3);
ss_lb=data(:,5);
ss_ub=data(:,6);
sy_lb=data(:,8);
sy_ub=data(:,9);
%% Calculation
nvar=3*size(hk_lb,1);
sz_smpl=npop.*nvar;
lb=[hk_lb',ss_lb',sy_lb'];
ub=[hk_ub',ss_ub',sy_ub'];
hcvars=zeros(numd,nvar);
hclb=zeros(numd,nvar);
hcub=zeros(numd,nvar);
for j=1:nvar
    aa=lb(j):((ub(j)-lb(j))/numd):ub(j);
    for i=1:numd
        hclb(i,j)=aa(i);
        hcub(i,j)=aa(i+1);
        hcvars(i,j)=(aa(i)+aa(i+1))/2;
    end
end
Rand_S=[];
flag=0;
inda=[];
checka=[];
smpl=sz_smpl;
j=0;
while size(Rand_S,1)<sz_smpl
    j=j+1;
    disp(['Iteration # ' num2str(j)])
    aa=randi([1,numd],smpl,nvar);
    inda1=[inda;aa];
    checka=[checka;zeros(size(aa,1),1)];
    [au,ia,ic]=unique(inda1,'rows');
    checkau=checka(ia,:);
    vu=zeros(size(au,1),size(au,2));
    for k=1:size(vu,2)
        vu(:,k)=hcvars(au(:,k),k);
    end
    for k=1:size(vu,1)
        accept=If_Clause(vu(k,:));
        if accept==1
            disp(['Iteration # ' num2str(j) ' , Sample # ' num2str(k) ' Accpted.'])
            inda=[inda;au(k,:)];
            Rand_S=[Rand_S;vu(k,:)];
        else
            disp(['Iteration # ' num2str(j) ' , Sample # ' num2str(k) ' Rejected.'])
        end
    end
    checka=ones(size(Rand_S,1),1);
    if size(Rand_S,1)==sz_smpl
        disp('Maximum Number of Samples is reached: Terminate!')
        break
    else
        disp('More Samples are needed: Continue...')
        smpl=sz_smpl-size(Rand_S,1);
    end
end
%% Saving Data
save([fldr '\Results\A_LatinHyperCubeSampling.mat'],'Rand_S','hcvars','lb','ub','hclb','hcub')
ss=true;
return