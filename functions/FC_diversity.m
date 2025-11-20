function [FD,m,entropy] = FC_diversity(FC,bin)
%FC_DIVERSITY 此处显示有关此函数的摘要
%   此处显示详细说明
M=30; 
FC=abs(FC(1:210,1:210));
vector=squareform(tril(FC,-1));
bins=linspace(0,1,M+1); 
m=mean(vector);
pi=histcounts(vector,bins)/length(vector);
FD=1-M/2/(M-1)*sum(abs(pi-1/M));

pi(pi==0)=[];
entropy=-1*sum(pi.*log2(pi));
end


