% fig6
clear; clc;
load 3mean210.mat
%% divide
lb = 0.39;ub = 0.58;N = 3;

groups = customDataGrouping(syn, lb, ub, N, 'equal_count');

%%
colors = [
    86  129  239;   % 淡蓝 → 明亮宝蓝色（大幅提升蓝色通道亮度，降低红/绿）
    255  80   74;   % 淡粉 → 明亮珊瑚粉（保留红色最大值，进一步压低绿/蓝）
    78  223   48;    % 原淡绿色 → 调整为浓郁亮绿色
    160 160 160
    ] / 255;


%% multi-group SEM
% write groups in csv

dataTable = readtable("all.csv");
    
if ~any(strcmp(dataTable.Properties.VariableNames, 'Group'))
    error('CSV文件中未找到"Group"列');
end
       
% 更新groups列
dataTable.Group = groups';
writetable(dataTable, "all.csv");
        
% run R script
r_script = 'multi_group_SEM.R';
system(['Rscript ' r_script]);


%% plot

a=700*ones(1,5);
X_fit=-0.5+min(syn):0.01:max(syn)+0.5;
C = [0 0 1 ;
     0 1 0 ;
     0 1 0 ;
     0 1 0 ;
     1 0 0 ];
%% hist
subplot(3,3,1)
% 假设 gMS_values 是你的 g-MS 数据列向量
gMS_values=syn; % 假设你已经加载了数据

% Step 1: 绘制直方图
edges = 0.25:0.01:0.75; % 自定义 bin 的边界
h = histogram(gMS_values, edges, 'FaceColor', [0.7 0.7 0.7]);
hold on;

% Step 2: 设置分段阈值
thresholds=[];
group_counts=[];
group_positions=[];
for igroup = 1:max(groups)
    group_counts = [group_counts,length(syn(groups==igroup))];
    group_positions = [group_positions,mean(syn(groups==igroup))];
    thresholds = [thresholds,max(syn(groups==igroup))];
end

colors = {[0.6 0.8 1], [0.9 0.9 0.9], [1 0.8 0.8]}; % 蓝灰红背景

% Step 3: 绘制背景色区域
yl = ylim;
fill([0.25 thresholds(1) thresholds(1) 0.25], [yl(1) yl(1) yl(2) yl(2)], colors{1}, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
fill([thresholds(end-1) 0.75 0.75 thresholds(end-1)], [yl(1) yl(1) yl(2) yl(2)], colors{3}, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Step 4: 添加虚线
for t = thresholds
    xline(t, '--k', 'LineWidth', 1.2);
end

% Step 5: 添加标签文字
text(0.28, yl(2)*0.9, 'Subcritical', 'Color', 'blue', 'FontSize', 12, 'FontWeight', 'bold');
text(0.62, yl(2)*0.9, 'Supercritical', 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');

% 添加组标签
group_labels = {'Subcritical','GP3', 'GP2', 'GP1','Supercritical'};

for i = 2:length(group_counts)
    text(group_positions(i), yl(2)*0.85, group_labels{i}, 'Color', 'green', ...
        'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    text(group_positions(i), yl(2)*0.75, num2str(group_counts(i)), 'Color', 'green', ...
        'HorizontalAlignment', 'center');
end


% Step 6: 设置标签和美化
xlabel('g-MS');
ylabel('Number of subjects');
box on;
%% g
subplot(3,3,4)
g_5=[];
for igroup = 1:N+2
    factor = readtable(['group',num2str(igroup),'.csv']);
    mean_factor(igroup)=mean(factor.g);
    mean_syn(igroup)=mean(syn(groups==igroup));
    g_5=[g_5;factor.g];
end

scatter(mean_syn,mean_factor,a,C,'^','filled')
set(gca,'XTick',mean_syn,'XTickLabel',{'Subcrit.','GP1','GP2','GP3','Supcrit.'})
hold on
box on;xlim([min(mean_syn)-0.05 max(mean_syn)+0.05])
ylabel('Latent mean');title('g');set(gca,'LineWidth',2,'FontSize',15,'FontName','Arial');grid on
p=polyfit(mean_syn,mean_factor,3);
y_fit = polyval(p,X_fit);
plot(X_fit,y_fit,'k--','LineWidth',2)

%% cry
subplot(3,3,5)
cry_5=[];
for igroup = 1:N+2
    factor = readtable(['group',num2str(igroup),'.csv']);
    mean_factor(igroup)=mean(factor.cry);
    mean_syn(igroup)=mean(syn(groups==igroup));
    cry_5=[cry_5;factor.cry];
end

scatter(mean_syn,mean_factor,a,C,'^','filled')
set(gca,'XTick',mean_syn,'XTickLabel',{'Subcrit.','GP1','GP2','GP3','Supcrit.'})
hold on
box on;xlim([min(mean_syn)-0.05 max(mean_syn)+0.05])
ylabel('Latent mean');title('cry');set(gca,'LineWidth',2,'FontSize',15,'FontName','Arial');grid on
p=polyfit(mean_syn,mean_factor,3);
y_fit = polyval(p,X_fit);
plot(X_fit,y_fit,'k--','LineWidth',2)

%% spd
subplot(3,3,7)
spd_5=[];
syn_5=[];
for igroup = 1:N+2
    factor = readtable(['group',num2str(igroup),'.csv']);
    mean_factor(igroup)=mean(factor.spd);
    mean_syn(igroup)=mean(syn(groups==igroup));
    spd_5=[spd_5;factor.spd];
    syn_5=[syn_5;syn(groups==igroup)'];
end

scatter(mean_syn,mean_factor,a,C,'^','filled')
set(gca,'XTick',mean_syn,'XTickLabel',{'Subcrit.','GP1','GP2','GP3','Supcrit.'})
hold on
box on;xlim([min(mean_syn)-0.05 max(mean_syn)+0.05])
ylabel('Latent mean');title('spd');set(gca,'LineWidth',2,'FontSize',15,'FontName','Arial');grid on
p=polyfit(mean_syn,mean_factor,3);
y_fit = polyval(p,X_fit);
plot(X_fit,y_fit,'k--','LineWidth',2)

%% mem
subplot(3,3,8)
mem_5=[];
for igroup = 1:N+2
    factor = readtable(['group',num2str(igroup),'.csv']);
    mean_factor(igroup)=mean(factor.mem);
    mean_syn(igroup)=mean(syn(groups==igroup));
    mem_5=[mem_5;factor.mem];
end

scatter(mean_syn,mean_factor,a,C,'^','filled')
set(gca,'XTick',mean_syn,'XTickLabel',{'Subcrit.','GP1','GP2','GP3','Supcrit.'})
hold on
box on;xlim([min(mean_syn)-0.05 max(mean_syn)+0.05])
ylabel('Latent mean');title('mem');set(gca,'LineWidth',2,'FontSize',15,'FontName','Arial');grid on
p=polyfit(mean_syn,mean_factor,3);
y_fit = polyval(p,X_fit);
plot(X_fit,y_fit,'k--','LineWidth',2)



% % FCd
% subplot(3,3,3)
% for igroup = 1:N+2
%     factor = readtable(['group',num2str(igroup),'.csv']);
%     mean_factor(igroup)=mean(factor.mem);
%     mean_syn(igroup)=mean(syn(groups==igroup));
% end
% % Hin Hse
% subplot(3,3,6)
% 
% % Hb
% subplot(3,3,9)
save("cog5.mat","mem_5","syn_5","spd_5","cry_5","g_5");