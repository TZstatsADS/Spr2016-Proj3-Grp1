source("train.R")
source("feature.R")

names <- list.files()
set.seed(1)

color_features <- feature("",names,10,6,6)
n<-dim(color_features)[1]
labels <- read.csv("../data/label.csv") 
labels_selected <- labels[match(names,labels[,1]),]

features_labeled<-cbind(labels_selected,color_features)


dog_index <- labels_selected[,2]==0
dogs <- features_labeled[dog_index,]
cats <- features_labeled[!dog_index,]

index<-sample(1:n,n,replace = FALSE)
features_labeled <- features_labeled[index,]

train_X <- features_labeled[1:6000,]
test_X <- features_labeled[6001:7387,]
        

fit_svm<- train(train_X[,c(-1,-2)],train_X[,2])

#data_train <- data.frame(train_X[index,])
#data_train$labels<-train_labels[index,2]

#x <- tune(svm, labels~., data = data_train, 
#          ranges = list(cost = 10^seq(-5, 5, 1),kernel = "linear")
#)


#index_Nna <- !is.na(color_features[,1])
#color_features_omitna <- color_features[index_Nna,]
#labels_selected_omitna <- labels_selected[index_Nna,]

#train_X <- color_features_omitna[,]
#train_y <- labels_selected_omitna[1:3600,]

#test_X <- color_features_omitna[3601:3989,]
#test_y <- labels_selected_omitna[3601:3989,]


x_hat <- predict(fit_svm[[1]], test_X)
table(x_hat,test_labels[,2])
sum(diag(table(x_hat,test_labels[,2])))/length(x_hat)

