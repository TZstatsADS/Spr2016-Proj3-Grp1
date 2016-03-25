#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016


train <- function(train_X, labels, par=NULL){

        library(e1071)
        names(labels) <- c("labels")
        traindata = cbind(labels,train_X)
        svm_fit <- svm(labels~.,kernel = "linear",data = traindata,gamma=0,cost = 0.27,type="C") 
        ### Train with gradient boosting model
  

  return(list(fit=svm_fit))
}
