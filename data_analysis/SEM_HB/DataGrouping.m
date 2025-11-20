function groups = DataGrouping(x, lb, ub, N)
    % 初始化组别向量（1: 低于下限, N+2: 高于上限）
    groups = zeros(size(x));
    
    % 标记低于下限的数据（组1）
    idx_low = x < lb;
    groups(idx_low) = 1;
    
    % 标记高于上限的数据（组N+2）
    idx_high = x > ub;
    groups(idx_high) = N + 2;
    
    % 处理中间数据（lb <= x <= ub）
    idx_mid = (x >= lb) & (x <= ub);
    x_mid = x(idx_mid);
    
    % 创建N个等宽区间（包含lb和ub）
    edges = linspace(lb, ub, N + 1);
    
    % 将中间数据分配到组2到组N+1
    group_mid = discretize(x_mid, edges);
    groups(idx_mid) = group_mid + 1; % 组号偏移（原1->N变为2->N+1）
end