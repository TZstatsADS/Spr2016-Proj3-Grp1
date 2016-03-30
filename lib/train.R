#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Yuting Ma    edited by: QS
### Project 3
### ADS Spring 2016



train <- function(train_X, labels, nround, par=NULL){
    
    package_need<-c("png","xgboost","data.table","e1071")
    for (i in 1:length(package_need)){
        if( package_need[i] %in% rownames(installed.packages()) == FALSE)
        install.packages(package_need[i])
    }
    library(png)
    library(xgboost)
    library(data.table)
    library(e1071)
    
    train.label<-labels
    
    length<-length(train_X)
    
    mat.train<-as.matrix(train_X)
    
    
    g.train<-apply(mat.train,2,as.numeric)
    g.train[is.na(g.train)]<-0
    
    
    
    ##begin train##
    numberOfClasses <- max(train.label) + 1
    
    param <- list("objective" = "multi:softprob",
    "eval_metric" = "logloss"
    )
    
    #cv.nround <- 50
    #cv.nfold <- 5
    #bst.cv = xgb.cv(param=param, data = g.train, label = train.label,
    #               nfold = cv.nfold, nrounds = cv.nround, max.depth=2)
    
    nround <- 48
    bst = xgboost(param=param, data =g.train[,1:1360], label = train.label, nrounds=nround,objective = "binary:logistic",max.depth=2)
    svm <- svm_train(g.train[,1001:1360],labels)
    
    return(list(svmfit=svm, gboostfit=bst))
    
}


svm_train <- function(train_X, labels, par=NULL){
    
    names(labels) <- c("labels")
    traindata = cbind(labels,train_X)
    svm_fit <- svm(labels~.,kernel = "linear",data = traindata,gamma=0,cost = 0.27,type="C")
    ### Train with gradient boosting model
    
    
    return(list(fit=svm_fit))
}


