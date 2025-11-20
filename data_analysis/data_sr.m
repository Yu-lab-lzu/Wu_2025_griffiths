clc
clear
close all
addpath("..\functions\")
%% 
% % t 1.5  max 0.7
% clc
load data_analysis.mat syn_W
clearvars -except syn_W

[A,B]=sort(syn_W);


group = 45;
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
        load(['avadet+lv\threshold=1.7\ava',num2str(sublist(sub)),'.mat'])

        x_plot = [x_plot;x];
        t_plot = [t_plot;t];

    end
    ii = ii+1;
    SYN_plot(ii) = mean(syn_W(sublist));
    x = x_plot;
    x_max = floor( max(x)*0.7 );
    a(ii)=x_max;
    [tau, ~, ~, ~] = plmle(x,'xmin',2,'xmax',x_max);
    alpha = tau;
    Alpha(ii) = tau;

    t = t_plot;
    x_max = floor( max(t)*0.7);
    b(ii)=x_max;
    [tau, ~, ~, ~] = plmle(t,'xmin',2,'xmax',x_max);
    Tau(ii) = tau;

    % gamma
    for tt = 1:max(t_plot)
        S_T(tt) = mean(x_plot(find(t_plot==tt)));
    end
    g = polyfit(log(1:3),log(S_T(1:3)),1);
    G(ii)=g(1);
end
mean((Tau-1)./(Alpha-1))
std((Tau-1)./(Alpha-1))
mean(G)
std(G)



% plot(Alpha,Tau,'.',MarkerSize=20)
% 
% x = 1.4:0.01:2;
% y = 1.36*(x-1)+1;
% plot(x,y,'k--',LineWidth=4)

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
%%

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
