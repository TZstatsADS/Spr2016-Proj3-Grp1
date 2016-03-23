source("train.R")
source("feature.R")
features <- read.table("../data/feature5000.txt")
labels <- read.csv("../data/label.csv") 
labels_selected <- labels[match(features[,1],labels[,1]),]
        
n<-dim(features)[1]

dog_index <- labels_selected[,2]==0
dog_labels <- labels_selected[dog_index,]
dog_features <- features[dog_index,]

cat_features <- features[!dog_index,]
cat_labels <- labels_selected[!dog_index,]

index<-sample(1:n,n,replace = FALSE)
train_X <- rbind(cat_features[1:2000,-1],dog_features[1:2000,-1])
test_X <- rbind(cat_features[2001:2394,-1],dog_features[2001:2394,-1])

train_labels <- rbind(cat_labels[1:2000,],dog_labels[1:2000,])
test_labels <-rbind(cat_labels[2001:2394,],dog_labels[2001:2394,])

index <- !is.na(train_labels[,2])

fit_svm<- train(train_X[index,],train_labels[index,2])

index <- !is.na(test_X[,2])

x_hat <- predict(fit_svm[[1]], test_X[index,])

table(x_hat,test_labels[index,2])
sum(diag(table(x_hat,test_labels[index,2])))/length(x_hat)
