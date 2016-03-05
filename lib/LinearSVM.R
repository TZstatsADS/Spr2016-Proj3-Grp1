#========================================================================
#This R script is for calculating linear SVM Error Rate
#========================================================================

#Library
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("EBImage")
library("EBImage")

#SVM training function
FindBestModel<-function(train.x,train.y,cost,k){
    tc<-tune.control(cross=k)
    tuneresult <- tune(svm, train.y=train.y, train.x = train.x, 
                   ranges = list(cost,kernel = "linear"),tunecontrol = tc)
    return(tuneresult)
}

CalErrorRate<-function(y1,y2){
    E = length(y2)
    E[y1==y2] = 0 
    E[y1!=y2] = 1
    return (sum(E)/length(E))
}

#Input Image Matix and corresponding labels. Also input parameter space cost & K.
x
y
cost
k

# Start Training Process
n=length(y)
n.train<-round(0.8*n)
train.ind<-sort(sample(1:n,n.train))
train.x<-x[train.ind,]
test.x<-x[-train.ind,]
train.y<-y[train.ind]
test.y<-y[-train.ind]

obj<-FindBestModel(train.x,train.y,cost,k)
BestModel<-obj$best.parameters
BestCost<-BestModel$cost
y_fit<- svm(train.y=train.y,train.x=train.y,kernel = "linear",gamma=0,cost = BestCost,scale=T)
y_hat<-predict(y_fit,test.x)
CalErrorRate(y_hat,test.y)
    



