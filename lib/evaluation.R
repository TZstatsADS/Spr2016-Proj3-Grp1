
tm_feature_train <- system.time(dat_train <- feature(img_train_dir, "trainfilename"))
tm_train <- system.time(fit_train <- train(dat_train, label_train))
cat("Time for constructing training features=", tm_feature_train[1], "s \n")
cat("Time for training model=", tm_train[1], "s \n")

tm_feature_test <- system.time(dat_test <- feature(img_test_dir, "testfilename"))
tm_test <- system.time(pred_test <- test(fit_train, dat_test))
cat("Time for constructing testing features=", tm_feature_test[1], "s \n")
cat("Time for making prediction=", tm_test[1], "s \n")