library(lavaan)
library(psych)
library(semPlot)
library(car)
library(sirt)
library(dplyr)
library(ggplot2)

dat1<-read.table("9_task.csv", sep = ",",header = T)
head(dat1)


# all.csv segregation.csv integration.csv
dat2<-read.table("all.csv", sep = ",",header = T)

datb<- merge(dat1, dat2, by="Subject")

#z-score normalize the data columns.csv
dat <- as.data.frame(scale(datb[ ,1:10]))
colnames(dat) = c("Group","PMAT24_A_CRz", "VSPLOT_TCz", "PicSeq_Unadjz", "IWRD_TOTz", "PicVocab_Unadjz", 
                    "ReadEng_Unadjz", "CardSort_Unadjz", "Flanker_Unadjz", "ProcSpeed_Unadjz")
dat[,1]=datb[,36]

head(dat)

##==================================
## different ranges for HB=0
##==============================

## dat=dat*989/990

table(dat$Group)

#####################################################################
# Multigroup modeling HB
#brain measures are HB, Hse and dse
#####################################################################

ModelMG <- 'g =~ 
PMAT24_A_CRz + VSPLOT_TCz +
#cry
PicVocab_Unadjz  + ReadEng_Unadjz + 
#mem
PicSeq_Unadjz + IWRD_TOTz +
#speed
CardSort_Unadjz + Flanker_Unadjz + ProcSpeed_Unadjz 

cry =~ b*PicVocab_Unadjz  + b*ReadEng_Unadjz 
mem =~ c*PicSeq_Unadjz + c*IWRD_TOTz 
spd =~ CardSort_Unadjz + Flanker_Unadjz + ProcSpeed_Unadjz

PMAT24_A_CRz~0*1
PicVocab_Unadjz~0*1
PicSeq_Unadjz~0*1
CardSort_Unadjz~0*1

g~1
cry~1
mem~1
spd~1

g~~g
cry~~cry
mem~~mem
spd~~spd
'

fitMG <- sem(model = ModelMG, data = dat, missing='ML',orthogonal=TRUE, std.lv=F, group = "Group")
summary(fitMG, fit.measures=TRUE, standardized=TRUE)

# null model with constrain of equal group means  潜在变量截距/均值相等
fitMGeM <- sem(model = ModelMG, data = dat, missing='ML',orthogonal=TRUE, std.lv=F, group = "Group",group.equal = c("means"))
summary(fitMGeM, fit.measures=TRUE, standardized=TRUE)

# test difference with null model
anova(fitMG, fitMGeM)

# visualize to SEM model structure with estimated parameters
# semPaths(fitMG, intercept = FALSE, whatLabel = "est", layout='tree',
#         edge.label.cex=0.8, label.cex=1.5, edge.width=1,
#         sizeMan=7,residuals = FALSE)


biScores    = lavPredict(fitMG)

biScoreseM    = lavPredict(fitMGeM)

 #write.table(biScores$'1','sup2.csv',sep=',')
 #write.table(biScores$'75','gri1.csv',sep=',')
 #write.table(biScores$'50','gri2.csv',sep=',')
 #write.table(biScores$'25','gri3.csv',sep=',')
 #write.table(biScores$'10','sub.csv',sep=',')

# ... [原始代码保持不变] ...

# 在获取因子分数后添加以下代码

# 1. 获取所有分组标签
group_labels <- names(biScores)

# 2. 循环输出每个分组的CSV文件
for (group_label in group_labels) {
  # 构建文件名：groupX.csv，其中X是分组标签
  filename <- paste0("group", group_label, ".csv")
  
  # 使用原始代码的方法输出当前分组
  write.table(biScores[[group_label]], 
              file = filename, 
              sep = ",", 
              row.names = FALSE)
  
  # 添加被试编号（如果可用）
  if (exists("dat") && "Subject" %in% names(dat)) {
    # 获取当前组的被试编号
    group_subjects <- dat$Subject[dat$Group == as.numeric(group_label)]
    
    # 读取刚刚保存的文件
    group_data <- read.csv(filename)
    
    # 添加被试编号列
    group_data$Subject <- group_subjects[1:nrow(group_data)]
    
    # 重新保存文件（包含被试编号）
    write.csv(group_data, filename, row.names = FALSE)
  }
  
  cat("已保存分组", group_label, "到文件:", filename, "\n")
}

