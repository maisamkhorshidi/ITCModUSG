function [fldr,fldm,fldl,fldpl,fldpo,fldop,fldt]=Initialization()
%% Some Folder Movements
fldr=pwd;
fldm=[fldr '\00. Modflow USG Files'];
fldl=[fldr '\01. Latin Hyper Cube Sampling'];
fldpl=[fldr '\02. Preparing LPF Writer'];
fldpo=[fldr '\03. Preparing Output Reader'];
fldop=[fldr '\04. Optimization'];
fldt=[fldr '\Temporary'];
%% Deleting Previous Files
if exist(fldt,'dir')
    rmdir(fldt,'s')
end
dir1=dir([fldr '\Results']);
for i=3:size(dir1,1)
    delete([fldr '\Results\' dir1(i).name])
end
return