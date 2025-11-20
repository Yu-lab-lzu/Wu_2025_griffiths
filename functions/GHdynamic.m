function simGH = GHdynamic(networkMatrix,Threshold,nNode,nTimeStep)

%% 说明
% Greenberg-Hastings cellular automaton model
% Q-Quiescent 静息态 (数值表示:0) 
% Q→E规则: 
% {0 + 1 = 1}
% 1)自发激活:一定概率进入
% 2)被其他节点激活:连接中的发放期节点超过阈值(ΣWij > Threshold)
% E-Excited 发放期 (数值表示:1) 
% E→R规则:T(E)→T+1(R)
% {1 - 56 = -55}
% 下一步必然进入不应期 
% R-Refractory 不应期 (数值表示:[-55,-1]) 
% R→Q规则：T(R)→T+55(Q)
% {-55 + 1 +1…… = 0}
% 不应期持续55步后，转为静息态并可重新被激活
%% Parameter
P_activationRate = 0.001;%Q → E,自发激活概率 {0 → 1}
P_refractory = 0.01;     %R → Q,不应期结束概率{-1 → 0}
RefractoryPeriod = -55;  %R态，不应期持续期 55步
W = networkMatrix;
T = Threshold;
%% variate $ Initial conditon
simGH = zeros(nNode,nTimeStep + 1);     %状态向量 每个节点四种状态{0,1,-1,RefractoryPeriod}
simGH(:,1) = randi([0,1],[nNode,1]);%初始为随机01二值



%% GH loop

for iTimeStep = 1:1:nTimeStep
    for iNode = 1:1:nNode 

        

        switch simGH(iNode,iTimeStep)
        % Q → E {0 → 1} 
            case 0
                ActivationNode = simGH(:,iTimeStep);
                ActivationNode(ActivationNode<0) = 0; %判断激活节点数
                if W(iNode,:) * ActivationNode   > T(iNode) %ΣWij 激活节点与连接矩阵内积
                    simGH(iNode,iTimeStep + 1) = 1;
                elseif rand < P_activationRate
                    simGH(iNode,iTimeStep + 1) = 1 ;
                else
                    simGH(iNode,iTimeStep + 1) = 0 ;
                end
        
    
       
        % E → R {1 → RefractoryPeriod}
            case 1
                simGH(iNode,iTimeStep + 1) = RefractoryPeriod;
        
        
        % R → Q {-1 → 0}
            case -1
                if rand < P_refractory
                    simGH(iNode,iTimeStep + 1) = 0;
                else
                    simGH(iNode,iTimeStep + 1) = -1;
                end

        % R → R {RefractoryPeriod → -1}
            otherwise
                simGH(iNode,iTimeStep + 1) = simGH(iNode,iTimeStep) + 1;

        end
    end
end

simGH(simGH<0) = 0;
simGH = simGH(:,10001:nTimeStep);







