function [Clus_num,Clus_size,cluster_id,FC] = Functional_HP(data,N)
%%%%%%%%%%%%%%
%%此函数通过分析每一个特征值对应特征向量的正负号来划分模块
%%OUTPUT：Clus_num, 每层模块数量与节点数的比值
%         Clus_size  每一层包含的节点个数
%         cluster_id 各层节点id;

cluster_id = cell(N,N);

%data=abs(data);

[V,D]=eig(data); %FEC特征向量，FE特征值
[~,ind] = sort(diag(D),'descend'); %将特征值按降序排列，并返回索引
FE = D(ind,ind);
FEC = V(:,ind);

H1_1=find(abs(FEC(:,1))<0);
H1_2=find(abs(FEC(:,1))>=0);
eval(['cluster_id{1,1}','=', 'H1_1', ';'])
eval(['cluster_id{1,2}','=', 'H1_2', ';'])
%%%%==============================================================
Clus_num=[1];%% number of cluster size
Clus_size=cell(N,1);
for mode=2:N
    x=find(FEC(:,mode)>=0);
    y=find(FEC(:,mode)<0);
    H={};
    for j=1:2*Clus_num(mode-1)
        H{j}=eval(['H',num2str(mode-1),'_',num2str(j)]);%% assume the number of cluster in j-1 level is 2^(mode-1) %eval 函数表示执行文本中的Matlab表达式
    end
    id = cellfun('length',H);%% length of each cluster in H
    H(id==0)=[];%% delete the cluster with 0 size
    id(id==0)=[];
    Clus_size{mode-1}=id;
    Clus_num=[Clus_num,length(H)];%% number of cluster
    k=1;
    for j=1:2:2*Clus_num(mode)%模块数量
        Positive_Node=intersect(H{k},x);
        Negtive_Node=intersect(H{k},y);
        k=k+1;
        eval(['H',num2str(mode),'_',num2str(j+1), '=', 'Positive_Node', ';'])
        eval(['H',num2str(mode),'_',num2str(j), '=', 'Negtive_Node', ';'])
        eval(['cluster_id{',num2str(mode),',',num2str(j+1), '}=', 'Positive_Node', ';'])
        eval(['cluster_id{',num2str(mode),',',num2str(j), '}=', 'Negtive_Node', ';'])
    end
    for j=1:2*Clus_num(mode-1)%模块数量
        eval(['clear',' H',num2str(mode-1),'_',num2str(j),'']);
    end
    Z=[];
    if (Clus_num(end)==N)
        for j=1:2*Clus_num(mode)
            Z=[Z;eval(['H',num2str(mode),'_',num2str(j)])];
        end
        break;
    end
end
Clus_num(1)=[];
Clus_num=[Clus_num/N,ones(1,N-length(Clus_num))];
FC=zeros(N,N);
for i=1:N
    for j=1:N
        FC(i,j)=data(Z(i),Z(j));
    end
end
end