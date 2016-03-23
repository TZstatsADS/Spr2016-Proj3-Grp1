#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016


train <- function(train_X, labels, par=NULL){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  processed features from images 
  ###  -  class labels for training images
  ### Output: training model specification
  
  ### load libraries
  #library("gbm")
        library(e1071)
        names(labels) <- c("labels")
        traindata = cbind(labels,train_X)
        svm_fit <- svm(labels~.,kernel = "linear",data = traindata,gamma=0,cost = 0.27,type="C") 
  ### Train with gradient boosting model
  #if(is.null(par)){
  #  depth <- 3
  #} else {
  #  depth <- par$depth
  #}
  #fit_gbm <- gbm.fit(x=dat_train, y=label_train,
  #                   n.trees=2000,
  #                   distribution="bernoulli",
  #                   interaction.depth=depth, 
  #                   bag.fraction = 0.5,
  #                   verbose=FALSE)
  #best_iter <- gbm.perf(fit_gbm, method="OOB")

  return(list(fit=svm_fit))
}
