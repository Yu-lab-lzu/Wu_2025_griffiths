clc
clear
close all
module =  {1:68,69:124,125:162,163:174,175:188,189:210,211:246};
addpath("..\functions\")

datapath = '..\BOLD\';
addpath(datapath)
list = dir(datapath);
sublist = list(3:end);
% for i=1:length(sublist)
% subid(i)=sscanf(sublist(i).name,'%f')
% end
tic 
for  sub=1:length(sublist)

    load([datapath,sublist(sub,1).name])
    BOLD = [ zscore(rest1_LR);zscore(rest1_RL);zscore(rest2_LR);zscore(rest2_RL)]; 
    %syn_synEntropy Whole Brain   
    inputsignal =BOLD;
    inputTimeLength = size(inputsignal,1);
    inputCellNumber = size(inputsignal,2);
    numBin = 30;
    [syn,syn_entropy,syn_t] = syn_synEntropy2(inputsignal,inputTimeLength,inputCellNumber,numBin);

    syn_W(sub) = syn;
    syn_entropy_W(sub) = syn_entropy;
    %
    
    %syn_synEntropy sub system   
    for ii = 1:size(module,2)
    inputsignal = BOLD(:,module{ii}); 
    inputTimeLength = size(inputsignal,1);
    inputCellNumber = size(inputsignal,2);
    numBin = 30;
    [syn,syn_entropy,syn_t] = syn_synEntropy2(inputsignal,inputTimeLength,inputCellNumber,numBin);
    syn_sub(sub,ii) = syn;
    syn_entropy_sub(sub,ii)=syn_entropy;
    end
    var_sub(sub) = var(syn_sub(sub,:));

    % FC_data(:,:,sub)=extractMatrix(BOLD,246);
sub

end
