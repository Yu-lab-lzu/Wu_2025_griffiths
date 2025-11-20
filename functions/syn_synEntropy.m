function [syn,syn_entropy,syn_t] = syn_synEntropy(inputsignal,inputTimeLength,inputCellNumber,numBin)
%this function calculate the synchrony and synchrony entropy of a system
% [syn,syn_entropy,syn_t] = syn_synEntropy(inputsignal,inputTimeLength,inputCellNumber,numBin)
% inputsignal is the system time serise
% inputTimeLength is the number of time points for the system time serise
% inputCellNumber is the number of the system units
% numBin is the hist bin number
% syn is the output return of system's syschronization
% syn_entropy is the output return  
theROITimeCoursesTotal=inputsignal;
    %the hilbert transform in performed to have the analytical signals
    %then have their instaneouse phases
    SIZE=size(theROITimeCoursesTotal);
    Num_vox=SIZE(2);
    if Num_vox~=inputCellNumber
       error('参数错误，程序终止') 
    end
    Time_Point=SIZE(1);
    if Time_Point~=inputTimeLength
       error('参数错误，程序终止') 
    end
    a=zeros(Time_Point,Num_vox);theta=a;
    for vox=1:Num_vox
        a(:,vox)=hilbert(theROITimeCoursesTotal(:,vox));
        theta(:,vox)=angle(a(:,vox));
    end
    % calculate the Kurumoto order parameteres (r_t) at each time point
    ang=exp(theta*1i);
    for jj=1:1:Time_Point
        syn_t(jj)=abs(sum(ang(jj,1:Num_vox)))./Num_vox;
    end    
    syn=mean(syn_t);%同步程度
    
    %syn_t_normalized = (syn_t-min(syn_t))/max(syn_t-min(syn_t)); %%%%%%%%%%%%%%%%%%%%%变的情况(与之前不同)
    
    bins=linspace(0,1,numBin+1);
    
    b=histcounts(syn_t,bins);
    p=b./Time_Point;
    p(p==0)=[];
    Entropy_rt=0;
    for kk=1:1:length(p)
        Entropy_rt=Entropy_rt-p(kk).*log2(p(kk));
    end
    syn_entropy=Entropy_rt;
end

