library(png)
library(BBmisc)
library(readbitmap)
library(xgboost)
library(methods)
library(data.table)
library(magrittr)

##read features##
sift<-read.table(file="/Users/Qiner/Desktop/ADS/proj 3/cycle3cvd-team1/data/feature200.txt",header = F)
names(sift)[1]<-"name"

##get label and merge##
label<-read.csv(file = "/Users/Qiner/Desktop/ADS/proj 3/cycle3cvd-team1/data/label.csv",header = T)
data.all<-merge(sift,label,by="name")
num<-length(data.all)-2
train.num<-round(0.8*nrow(data.all))
test.num<-nrow(data.all)-train.num

##get train & test data##
sample<-sample(nrow(data.all),train.num)
train<-data.all[sample,]
test<-data.all[-sample,]

train.label<-train$label
test.label<-test$label
drops <- c("name","label")
train<-train[, !(names(train) %in% drops)]
test<-test[, !(names(test) %in% drops)]


mat.train<-as.matrix(train)
mat.test<-as.matrix(test)

g.train<-matrix(nrow=train.num,ncol=num,0)
for(i in 1:train.num){
  for(j in 1:num){
    g.train[i,j]<-as.numeric(mat.train[i,j])
  }
}

g.test<-matrix(nrow=test.num,ncol=num,0)
for(i in 1:test.num){
  for(j in 1:num){
    g.test[i,j]<-as.numeric(mat.test[i,j])
  }
}

##begin train##
numberOfClasses <- max(train.label) + 1

param <- list("objective" = "multi:softprob",
              "eval_metric" = "mlogloss",
              "num_class" = numberOfClasses)

cv.nround <- 5
cv.nfold <- 5
bst.cv = xgb.cv(param=param, data = g.train, label = train.label, 
                nfold = cv.nfold, nrounds = cv.nround)

nround = 50
bst = xgboost(param=param, data =g.train, label = train.label, nrounds=nround,objective = "binary:logistic")

##begin test##
pred<-predict(bst,newdata=g.test)
err <- mean(as.numeric(pred > 0.5) != test.label)
print(paste("test-error=", err))
