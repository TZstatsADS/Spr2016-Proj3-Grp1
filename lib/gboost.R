#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Author: Yuting Ma       edited: Zac
### Project 3
### ADS Spring 2016

#setwd("F:/CU Textbooks And Related Stuff/STAT W4249/Project3")
library(png)
library(BBmisc)
library(readbitmap)
library(xgboost)
library(methods)
library(data.table)
library(magrittr)

feature <- function(img_dir, file_names,feature_method ,data_name=NULL){
  ### Construct process features for training/testing images
  ### Sample simple feature: Extract raw pixel values os features
  
  ### Input: a directory that contains images ready for processing
  ###img_dir the path
  ###img_name name of picture 
  ###feature_method c(names, parameters)
  ### Output: an .RData file contains processed features for the images
  
  ### load libraries
  library("EBImage")
  
  #img_dir <- "../data/zipcode_train/"
  #img_name <- "img_zip_train"
  ######################
  
  n_files <- length(file_names)
  image_name<-0
  ### determine img dimensions
  #img0 <-  readImage(file_names[1])
  
  ### store vectorized pixel values of images
  dat <- array(dim=c(n_files,feature_method[1]*feature_method[2]*feature_method[3]+1))
  for(i in 1:n_files){
    if (sum(grep(".jpg",file_names[i]))==0){
      dat[i,] <- NA
    }
    else{
      
      if(!is.na(image_type(paste0(img_dir,file_names[i])))){
        ImageTp<-image_type(paste0(img_dir,file_names[i]))
        if(ImageTp=="png"){
          img <- readPNG(paste0(img_dir,file_names[i]))
        }
        else{
          img <- readImage(paste0(img_dir,file_names[i]))
        }
        img <-resize(img,256,256)
        img_name<-file_names[i]
        v<-color_hist(img,img_name,feature_method[1],feature_method[2],feature_method[3])
        if (i%%100 == 0){
          print(i)
        }
        
        dat[i,] <- v
        
      }
    }
  }
  
  ### output constructed features
  if(!is.null(data_name)){
    save(dat, file=paste0("./output/feature_", data_name, ".RData"))
  }
  return(dat)
}

###color feature 
color_hist <- function(img,img_name,nR,nG,nB){
  mat <- imageData(img)
  # Caution: the bins should be consistent across all images!
  rBin <- seq(0, 1, length.out=nR)
  gBin <- seq(0, 1, length.out=nG)
  bBin <- seq(0, 1, length.out=nB)
  
  if (length(dim(mat))==3){
    
    freq_rgb <- as.data.frame(table(factor(findInterval(mat[,,1], rBin), levels=1:nR), 
                                    factor(findInterval(mat[,,2], gBin), levels=1:nG), 
                                    factor(findInterval(mat[,,3], bBin), levels=1:nB)))
  }else {
    freq_rgb <- as.data.frame(table(factor(findInterval(mat, rBin), levels=1:nR), 
                                    factor(findInterval(mat, gBin), levels=1:nG), 
                                    factor(findInterval(mat, bBin), levels=1:nB)))
  }
  rgb_feature <- as.numeric(freq_rgb$Freq)/(ncol(mat)*nrow(mat)) # normalization
  rgb_feature<-c(img_name,rgb_feature)
  return (rgb_feature) 
} 

##get features##
dir_train<-"~/Desktop/ADS/proj 3/data/images/"
file_names<-list.files(dir_train)
data.feature<-feature(dir_train, file_names,c(10,10,10),data_name=NULL)
feature<-na.omit(data.feature)
feature<-data.frame(feature)
names(feature)[1]<-"name"


##get label and merge##
label<-read.csv(file = "/Users/Qiner/Desktop/ADS/proj 3/cycle3cvd-team1/data/label.csv",header = T)
data.all<-merge(feature,label,by="name")

##get 1000 data##
data<-data.all[sample(nrow(data.all), 1000), ]

##get train & test data##
sample<-sample(nrow(data), 800)
train<-data[as.numeric(sample),]
test<-data[-as.numeric(sample),]



train.label<-train$label
test.label<-test$label
drops <- c("name","label")
train<-train[, !(names(train) %in% drops)]
test<-test[, !(names(test) %in% drops)]

mat.train<-as.matrix(train)
mat.test<-as.matrix(test)

g.train<-matrix(nrow=800,ncol=1000,0)
for(i in 1:800){
  for(j in 1:1000){
    g.train[i,j]<-as.numeric(mat.train[i,j])
  }
}

g.test<-matrix(nrow=200,ncol=1000,0)
for(i in 1:200){
  for(j in 1:1000){
    g.test[i,j]<-as.numeric(mat.test[i,j])
  }
}

##begin train##
numberOfClasses <- max(train.label) + 1

param <- list("objective" = "multi:softprob",
              "eval_metric" = "mlogloss",
              "num_class" = numberOfClasses)

cv.nround <- 5
cv.nfold <- 3
bst.cv = xgb.cv(param=param, data = g.train, label = train.label, 
                nfold = cv.nfold, nrounds = cv.nround)

nround = 50
bst = xgboost(param=param, data =g.train, label = train.label, nrounds=nround,objective = "binary:logistic")

##begin test##
pred<-predict(bst,newdata=g.test)
err <- mean(as.numeric(pred > 0.5) != test.label)
print(paste("test-error=", err))
