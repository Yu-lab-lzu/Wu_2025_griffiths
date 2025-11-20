clc
clear
close all
addpath ..\functions\
% cluster = {1:14,15:28,29:40,41:52,53:68,69:80,81:88,89:102,103:124,125:134,135:146,147:162,163:174,175:188,189:210,211:246};
cluster = {[1:68],[69:124],[125:162],[163:174],[175:188],[189:210],[211:246]};
[subsys_1,subsys_2] = demarcate_threshold(cluster,'..\HCPdata\BOLDdet+lv\');
datestr (now)

nloop = 50;
simulation_step = 200000;


for iloop = 1:nloop
    mkdir(['GHsignals\loop',num2str(iloop)])
    for K1 = 0:0.2:16
        K2 = K1;
        parfor a=70:150
            b = a/50;
            save_file_name = ['GHsignals\loop',num2str(iloop),'\k=',num2str(K1),'b=',num2str(b)];
            GHloop(simulation_step,subsys_1,subsys_2,K1,K2,b,save_file_name);
            % datestr (now)

        end
    end
    iloop
    datestr (now)
end
datestr (now)