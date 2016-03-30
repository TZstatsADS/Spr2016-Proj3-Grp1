######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Yuting Ma  edited by: QS
### Project 3
### ADS Spring 2016


test <- function(fit_train, dat_test){
    package_need<-c("png","xgboost","data.table","e1071")
    for (i in 1:length(package_need)){
        if( package_need[i] %in% rownames(installed.packages()) == FALSE)
        install.packages(package_need[i])
    }
    library(png)
    library(xgboost)
    library(data.table)
    library(e1071)
    
    
    mat.test<-as.matrix(dat_test)
    g.test<-apply(mat.test,2,as.numeric)
    g.test[is.na(g.test)]<-0
    color<-g.test[,1001:1360]
    sift<-g.test[,1:1360]
    pred_baseline <- predict(fit_train$svmfit[[1]],newdata=color)
    pred_ad <- predict(fit_train$gboostfit,newdata=sift)
    return (list(baseline=pred_baseline, adv=as.numeric(pred_ad>0.5)))
    
}