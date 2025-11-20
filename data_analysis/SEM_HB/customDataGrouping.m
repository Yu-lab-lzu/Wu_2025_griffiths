function groups = customDataGrouping(x, lb, ub, N, method)
    % 输入参数：
    %   x: 输入数据（向量）
    %   lb: 下限值
    %   ub: 上限值
    %   N: 中间分组数量
    %   method: 分组方法 ('equal_width' 或 'equal_count')
    %
    % 输出：
    %   groups: 分组结果（1:低于下限, 2~N+1:中间组, N+2:高于上限）
    
    % 验证输入
    validateattributes(x, {'numeric'}, {'vector'}, mfilename, 'x', 1);
    validateattributes(lb, {'numeric'}, {'scalar'}, mfilename, 'lb', 2);
    validateattributes(ub, {'numeric'}, {'scalar'}, mfilename, 'ub', 3);
    validateattributes(N, {'numeric'}, {'scalar','integer','positive'}, mfilename, 'N', 4);
    
    if lb >= ub
        error('下限值必须小于上限值');
    end
    
    % 初始化分组结果
    groups = zeros(size(x));
    
    % 标记低于下限的数据（组1）
    groups(x < lb) = 1;
    
    % 标记高于上限的数据（组N+2）
    groups(x > ub) = N + 2;
    
    % 处理中间数据（lb <= x <= ub）
    idx_mid = (x >= lb) & (x <= ub);
    x_mid = x(idx_mid);
    
    % 如果没有中间数据则返回
    if isempty(x_mid)
        return;
    end
    
    % 根据选择的方法进行分组
    switch lower(method)
        case 'equal_width'  % 等间隔分组
            edges = linspace(lb, ub, N+1);
            
        case 'equal_count'  % 等数量分组
            sorted_x = sort(x_mid);
            n = numel(sorted_x);
            
            % 计算分位数位置
            quantiles = linspace(1, n, N+1);
            
            % 获取边界值（整数索引）
            idx = unique(round(quantiles));
            idx(idx < 1) = 1;
            idx(idx > n) = n;
            edges = sorted_x(idx);
            
            % 确保边界包含lb和ub
            edges(1) = lb;
            edges(end) = ub;
            
        otherwise
            error('未知分组方法: %s\n请选择 ''equal_width'' 或 ''equal_count''', method);
    end
    
    % 分配组号（组2到组N+1）
    [~, ~, bin] = histcounts(x_mid, edges);
    
    % 处理可能的NaN值（边界值处理）
    bin(isnan(bin)) = 0;
    valid_bins = bin > 0;
    
    groups(idx_mid) = bin + 1;  % 组号偏移
end