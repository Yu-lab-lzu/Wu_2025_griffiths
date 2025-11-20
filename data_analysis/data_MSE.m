clear;clc;close all;
addpath ../functions/CritAnalysisSoftwarePackage/
threshold=1.7
load data_analysis.mat syn_W
%% 
[A,B]=sort(syn_W);
group = 30;
remainder = mod(size(B,2),group);
last_group = B(end-remainder+1:end);
B(end-remainder+1:end)=[];
B = reshape(B,group,[]);
ii = 0;
for scale_group = 1:size(B,2)
    x_plot = [];
    t_plot = [];
    S_T = [];

    sublist = B(:,scale_group);
    for sub = 1:length(sublist)
        load(['avadet+lv\threshold=',num2str(threshold),'\ava',num2str(sublist(sub)),'.mat'])

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
    xmax = x_max;xmin=2;
        fitParams = struct; fitParams.tau = tau;
        fitParams.xmin=2;fitParams.xmax=x_max;
        plotParams = struct; plotParams.dot = 'on';

        data = plplottool(x,'plotParams',plotParams,'fitParams',fitParams);
        fit_max = length(data.fit{1,1}(end,:));
        CDF_mean = mean((cumsum(data.x{1,1}(end,xmin:fit_max+xmin-1))-cumsum(data.fit{1,1}(end,1:end))).^2);

        PDF_mean = mean((data.x{1,1}(end,xmin:fit_max+xmin-1)-data.fit{1,1}(end,1:end)).^2);
        PME(ii)=PDF_mean;
        CME(ii)=CDF_mean;
        
        [p(ii), ks, sigmaTau(ii)]=pvcalc(x, tau,'xmin',2,'xmax',x_max);
        KSD(ii)=ks{1,1};

    t = t_plot;
    x_max = floor( max(t)*0.66);
    b(ii)=x_max;
    [tau, ~, ~, ~] = plmle(t,'xmin',2,'xmax',x_max);
    Tau(ii) = tau;
    
    % % gamma
    fit_range = 3:20;
    for tt = 1:max(t_plot)
        S_T(tt) = mean(x_plot(t_plot==tt));
    end
     %[liner_method,direct_method] = sr_curvefit(fit_range,S_T(fit_range));
    g = polyfit(log(fit_range),log(S_T(fit_range)),1);

    G(ii)=g(1);
    %G_liner(ii) = liner_method;
    %G_dir(ii) = direct_method;
    close;
end


%% MSE
subplot(1,2,2)
semilogy(SYN_plot,CME,LineWidth=4)
xlabel('g-MS');ylabel('MSE')
grid on

yline(2e-5,'r--',linewidth=4)
xline(0.39,'g--',linewidth=4)
xline(0.53,'g--',linewidth=4)
set(gca,'LineWidth',2,fontname='Arial',fontsize=16)

subplot(1,2,1)
semilogy(SYN_plot,PME,LineWidth=4)
xlabel('g-MS');ylabel('MSE')
grid on

yline(2e-5,'r--',linewidth=2)
set(gca,'LineWidth',2,fontname='Arial',fontsize=16)


leg=legend;
leg.ItemTokenSize=[50,40];
