clc
clear
close all
addpath("..\functions\")
% cluster = {1:14,15:28,29:40,41:52,53:68,69:80,81:88,89:102,103:124,125:134,135:146,147:162,163:174,175:188,189:210,211:246};
cluster = {[1:68],[69:124],[125:162],[163:174],[175:188],[189:210],[211:246]};
datestr (now)
% parpool('Processes',4)  
nloop = 50;
for iloop = 1:nloop
    mkdir(['simulation_analysis\loop',num2str(iloop)])
    for K1 = 0:0.02:16
        K2 = K1;
        parfor a=70:150
            b = a/50;
            load_file_name = ['GHsignals\loop',num2str(iloop),'\k=',num2str(K1),'b=',num2str(b)];
            save_file_name = ['simulation_analysis\loop',num2str(iloop),'\k=',num2str(K1),'b=',num2str(b)];
            GHanalysis(cluster,load_file_name,save_file_name)
            % datestr (now)
        end
    end
    iloop
    datestr (now)
end
datestr (now)

%%