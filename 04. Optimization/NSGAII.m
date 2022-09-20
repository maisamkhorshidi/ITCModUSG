function ss=NSGAII(Npop,NumGen,Nbin,fldr,fldm,fldt,fldop)
%% Inputs
% npop=1;
% gen=1;
% numb=10;
npop=Npop;
gen=NumGen;
numb=Nbin;
%% Creating Temporary Folder
if exist(fldt,'dir')
    rmdir(fldt,'s')
end
mkdir(fldt)
dir1=dir(fldm);
for i=3:size(dir1,1)
    copyfile([fldm '\' dir1(i).name],fldt)
end
if exist([fldr '\Results\NSGA_II.mat'],'file')
    delete([fldr '\Results\NSGA_II.mat'])
end
%% Finding Executable File
dir1=dir(fldm);
for i=3:size(dir1,1)
    aa=dir1(i).name(end-2:end);
    cond=(strcmp(aa,'exe') || strcmp(aa,'EXE') || strcmp(aa,'Exe') || strcmp(aa,'eXe') ||...
            strcmp(aa,'exE') || strcmp(aa,'EXe') || strcmp(aa,'ExE') ||...
            strcmp(aa,'eXE'));
    if cond
        filename=dir1(i).name;
        break
    elseif ~cond && i==size(dir1,1)
        error('EXE File Not Found in: \00. Modflow USG Files')
    end
end
fileexe=filename;
%% Loading Data
load([fldr '\Results\A_LatinHyperCubeSampling.mat']);
load([fldr '\Results\D_Scanning_Index_From_LPF.mat'])
load([fldr '\Results\E_Reading_Output.mat'])
%% Initializing NSGA-II
nvars=numel(lb);
init_pop=Rand_S;
pop=npop.*nvars;
%% Running NSGA-II
fit=@(x)fittness(x,indexi,indexj,...
    lpfd1,lpfh1,fileinput,fileoutput,obsh,obsind,well_row,well_col,...
    obsnum,numb,hclb,fldt,fldop,fileexe);
options = optimoptions('gamultiobj','PopulationSize',pop,'Generations',gen,...
    'StallGenLimit',50,'Display','iter','UseVectorized',true,...
    'PlotFcn',@gaplotpareto,'InitialPopulation',init_pop);
[x,fval,exitflag,output,population,scores]=...
    gamultiobj(fit,nvars,[],[],[],[],lb,ub,[],options);
%% Post Calculation
[y,simcal,simall,simobs,mi,vi,pen,param]=fittness(x,indexi,indexj,...
    lpfd1,lpfh1,fileinput,fileoutput,obsh,obsind,well_row,well_col,...
    obsnum,numb,hclb,fldt,fldop,fileexe);
%% Removing Temporary Folder
rmdir(fldt,'s')
%% Saving Results
ss=true;
save([fldr '\Results\NSGA_II.mat'])
return
