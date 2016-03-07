source("train.R")
source("feature.R")
labels <- read.table("../data/zip_train_label.txt")
dir_train <- "../data/zipcode_train/"
file_names <- list.files(dir_train)

n_files <- length(file_names)

dat <- array(dim=c(n_files, 256)) 
for(i in 1:n_files){
        img <- readImage(paste0(dir_train, file_names[i]))
        dat[i,] <- as.vector(img)
}

index<-sample(1:1289,1289)
train_X <- dat[index[1:1000],]
test_X <- dat[index[1001:1289],]

y <- tune(svm, labels~., data = remainDataSet, 
          ranges = list(gamma = 10^(-5),cost = seq(0.01, 1, 0.05),kernel = "radial")
)

fit_svm<- train(train_X,labels[index[1:1000],])

x_hat <- predict(fit_svm[[1]], test_X)

