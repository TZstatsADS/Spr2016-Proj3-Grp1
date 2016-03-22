#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Author: Yuting Ma       edited: Zac
### Project 3
### ADS Spring 2016

feature <- function(img_dir, file_names,nR,nG,nB,data_name=NULL){
  library("EBImage")
#########temporary use
  #img_dir <- "/Users/zacwu/Downloads/"
  #img_name <- "img_zip_train"
######################
  n_files <- length(file_names)
  ### determine img dimensions
  #img0 <-  readImage(file_names[1])
  ### store vectorized pixel values of images
  dat <- array(dim=c(n_files,nR*nG*nB))
  for(i in 1:n_files){
        tryCatch({
                print("try!")
                img <- readImage(paste0(img_dir,file_names[i]))
                img <-resize(img,256,256)
                v<-color_hist_hsv(img,nR,nG,nB)
                dat[i,] <- v
                
                
        },error = function(err) {
                dat[i,] <- rep(NA,nR*nG*nB)
                print(err)
        })
         

        #print(i)
        if (i%%100 == 0){
                print(i)
        }
        
  }
  
  ### output constructed features
  #if(!is.null(data_name)){
  #  save(dat, file=paste0("./output/feature_", data_name, ".RData"))
  #}
  return(dat)
}

###color feature 
color_hist_rgb <- function(img,nR,nG,nB){
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
        return (rgb_feature)
}

color_hist_hsv <- function(img,nH,nS,nV){
        mat <- imageData(img)
        library(grDevices)
        # Convert 3d array of RGB to 2d matrix
        mat_rgb <- mat
        dim(mat_rgb) <- c(nrow(mat)*ncol(mat), 3)
        mat_hsv <- rgb2hsv(t(mat_rgb))
        # Caution: determine the bins using all images! The bins should be consistent across all images. The following code is only used for demonstration on a single image.
        hBin <- seq(0, 1, length.out=nH)
        sBin <- seq(0, 1, length.out=nS)
        vBin <- seq(0, 0.005, length.out=nV) 
        freq_hsv <- as.data.frame(table(factor(findInterval(mat_hsv[1,], hBin), levels=1:nH), 
                                        factor(findInterval(mat_hsv[2,], sBin), levels=1:nS), 
                                        factor(findInterval(mat_hsv[3,], vBin), levels=1:nV)))
        hsv_feature <- as.numeric(freq_hsv$Freq)/(ncol(mat)*nrow(mat))
        return(hsv_feature)
}
