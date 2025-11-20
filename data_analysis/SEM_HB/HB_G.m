clear;clc;
parpool("Processes",96)
N=210;
% functionpath = '/public5/home/t6s009451/Task/flexibility/';
addpath /public5/home/t6s009451/Task/flexibility/
datapath = '/public5/home/t6s009451/Task/HCP_data_resting/';        %the path of the wm-fMRI data from HCP      WM任务的被试编号
sub_num = dir(datapath);
sub_num = sub_num(3:end);
%% stable-FC
sBOLD = [];
for isub =1:1%length(sub_num)
    load([sub_num(isub).folder,'/',sub_num(isub).name]);
    sBOLD = [sBOLD;zscore(rest1_RL);zscore(rest1_LR);zscore(rest2_RL);zscore(rest2_LR)];
    isub
end
sFC = corr(sBOLD);
sFC = abs(sFC);
sFC=sFC(1:N,1:N);
[R_IN,R_IM] =Balance(sFC,N);

%% individual _ Hb

parfor isub =1:length(sub_num)
    fmri = load([sub_num(isub).folder,'/',sub_num(isub).name]);    
    BOLD = [zscore(fmri.rest1_RL);zscore(fmri.rest1_LR);zscore(fmri.rest2_RL);zscore(fmri.rest2_LR)];
    isub

    eFC = corr(BOLD);
    %eFC(eFC<0)=0;
    eFC = abs(eFC);
    eFC=eFC(1:N,1:N);
    [IN(isub),IM(isub)] =Balance(eFC,N);
    
end
Hin = individual_correction(IN,R_IN);
Hse = individual_correction(IM,R_IM);
save("inse.mat","Hse","Hin",'-mat')
%parsave('corrected',Hin,Hse,'_HB.mat')

