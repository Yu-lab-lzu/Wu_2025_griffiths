function [Hin,Hse] =Balance(FC,N)  
%% This function calculates the integration and segregation component
%% input: FC-- functional matrix, N-- number of ROI
%% Clus_size-- modular size in each levfel, Clus_num-- modular number; 
%% Clus_size and Clus_num are calcuated from the functuon 'Functional_HP' 
%% output: Hin--integration component, Hse-- segregation component, p-- correction fator of modular size
FC=(FC+FC')/2;
%FC=abs(FC);
[Clus_num,Clus_size,~,~] = Functional_HP(FC,N);
FE=sort(eig(FC),'descend'); %特征值降序排序
FE(FE<0)=0;
FE=FE.^2;%% using the squared Lambda
%%======================
p=zeros(1,N);
for i=1:length(find(Clus_num<1))
      p(i)=sum(abs(Clus_size{i}-1/Clus_num(i)))/N;%% modular size correction
end
HF=(FE)'.*Clus_num.*(1-p);
Hin=sum(HF(1))/N; %% integration component
Hse=sum(HF(2:N))/N;%% segregation component
end

