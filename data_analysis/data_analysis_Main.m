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
    chimera_index(sub) = chimera_index_246(BOLD,246);
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
toc
%% 
% t 1.5  max 0.7
clear;clc

load data_analysis.mat syn_W
[A,B]=sort(syn_W);


group = 20;
remainder = mod(size(B,2),group);
last_group = B(end-remainder+1:end);
B(end-remainder+1:end)=[];
B = reshape(B,group,[]);
ii = 0;
for scale_group = 1:size(B,2)
    x_plot = [];
    t_plot = [];
    S_T = [];
    % if scale_group == size(B,2)+1
    %     sublist = last_group;
    % else
    % sublist = B(:,scale_group);
    % end
    sublist = B(:,scale_group);
    for sub = 1:length(sublist)
        load(['avadet+lv\threshold=2\ava',num2str(sublist(sub)),'.mat'])

        x_plot = [x_plot;x];
        t_plot = [t_plot;t];

    end
    ii = ii+1;
    SYN_plot(ii) = mean(syn_W(sublist));
    x = x_plot;
    x_max = floor( max(x)*0.65 );
    a(ii)=x_max;
    [tau, ~, ~, ~] = plmle(x,'xmin',2,'xmax',x_max);
    alpha = tau;
    Alpha(ii) = tau;

    t = t_plot;
    x_max = floor( max(t)*0.65);
    b(ii)=x_max;
    [tau, ~, ~, ~] = plmle(t,'xmin',2,'xmax',x_max);
    Tau(ii) = tau;

    % gamma
    for tt = 1:max(t_plot)
        S_T(tt) = mean(x_plot(find(t_plot==tt)));
    end
    g = polyfit(log(2:7),log(S_T(2:7)),1);
    
    G(ii)=g(1);
end
mean((Tau-1)./(Alpha-1))
std((Tau-1)./(Alpha-1))
mean(G)
std(G)
% 
% 
% 
% % plot(Alpha,Tau,'.',MarkerSize=20)
% % 
% % x = 1.4:0.01:2;
% % y = 1.36*(x-1)+1;
% % plot(x,y,'k--',LineWidth=4)
% 
figure
subplot(4,1,1)
plot(SYN_plot)
subplot(4,1,2)
plot(Alpha)
subplot(4,1,3)
plot(Tau)
subplot(4,1,4)
plot(G)
hold on
plot((1-Tau)./(1-Alpha))
%

figure
c = flipud(jet(size(Alpha,2)));
for II = 1:size(Alpha,2)
    plot(Alpha(II),Tau(II),'p',Color=c(II,:),MarkerSize=20,LineWidth=3)
    hold on
end

figure
c = flipud(jet(size(Alpha,2)));
for II = 1:size(Alpha,2)
    plot(Alpha(II),Tau(II),'p',Color=c(II,:),MarkerSize=20,LineWidth=3)
    hold on
end
hold on
x = 1:0.01:1.8;
y = mean((Tau-1)./(Alpha-1))*(x-1)+1;
plot(x,y,'k--',LineWidth=4)
save('sr.mat',"Alpha","Tau","G","SYN_plot");


a = 1:20
x = log(a)
y = log(S_T(a))

loglog(1:29,log(S_T))
