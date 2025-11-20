clc
clear
close all
addpath("..\functions\")
addpath("..\functions\CritAnalysisSoftwarePackage\")
% cluster = {1:14,15:28,29:40,41:52,53:68,69:80,81:88,89:102,103:124,125:134,135:146,147:162,163:174,175:188,189:210,211:246};
cluster = {[1:68],[69:124],[125:162],[163:174],[175:188],[189:210],[211:246]};
datestr (now)

nloop = 50;
for iloop = 1:nloop
    mkdir(['avalanche_analysis\loop',num2str(iloop)])
    for K1 = 0:0.2:16
        K2 = K1;
        parfor a=70:150
            b = a/50;
            load_file_name = ['GHsignals\loop',num2str(iloop),'\k=',num2str(K1),'b=',num2str(b)];
            save_file_name = ['avalanche_analysis\loop',num2str(iloop),'\k=',num2str(K1),'b=',num2str(b)];
            Avalance_detect(load_file_name,save_file_name)
            % datestr (now)
        end
    end
    iloop
    datestr (now)
end
datestr (now)

%%
mkdir('Griffith_analysis')
CME = NaN(81)
ii = 0;
for K1 = 0:0.2:16
    K2 = K1;
    ii = ii + 1;
    jj = 0;
    for a=70:150
        jj = jj + 1;
        b = a/50;
        x_plot = [];
        t_plot = [];

        if ~exist(['avalanche_analysis\loop1\k=',num2str(K1),'b=',num2str(b),'.mat'],"file")
            continue
        end
        for iloop = 1:nloop
            
            load(['avalanche_analysis\loop',num2str(iloop),'\k=',num2str(K1),'b=',num2str(b)])

            x_plot = [x_plot;x];
            t_plot = [t_plot;t];
        end

        x = t_plot;
        x_max = floor( max(x)*0.66 );
        [T, ~, ~, ~] = plmle(x,'xmin',3,'xmax',x_max);
        % gama
        for tt = 1:max(t_plot)
            S_T(tt) = mean(x_plot(find(t_plot==tt)));
        end
        gamma_fit = polyfit(log(1:5),log(S_T(1:5)),1);

        x = x_plot;
        x_max = floor( max(x)*0.66 );
        [tau, xmin, xmax, ~] = plmle(x,'xmin',3,'xmax',x_max);


        fitParams = struct; fitParams.tau = tau;
        fitParams.xmin=xmin;fitParams.xmax=xmax;
        plotParams = struct; plotParams.dot = 'on';

        data = plplottool(x,'plotParams',plotParams,'fitParams',fitParams);
        fit_max = length(data.fit{1,1}(end,:));
        CDF_mean = mean((cumsum(data.x{1,1}(end,xmin:fit_max+xmin-1))-cumsum(data.fit{1,1}(end,1:end))).^2);
        CME(jj,ii)=CDF_mean;
        A = tau;
        save(['Griffith_analysis\k=',num2str(K1),'b=',num2str(b),'.mat'],"T","A","gamma_fit","CDF_mean")
        close all
        K1
        b
    end
end
close all

imagesc(0:0.2:16,1.4:0.02:3,CME)
set(gca,'colorscale','log')
