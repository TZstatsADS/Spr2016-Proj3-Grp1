library("EBImage")
library(grDevices)
setwd("~/Documents/MATLAB/images/")
dir_images <-"~/Documents/MATLAB/images/"
dir_names <- list.files(dir_images)


nH <- 10
nS <- 6
nV <- 6
data<-matrix(0, nrow = length(dir_names), ncol = 360)
for(i in 1:length(dir_names)){
        mat <- imageData(readImage(as.character(dir_names[i])))
        mat_rgb <- mat
        if(length(dim(mat_rgb))==3){
                dim(mat_rgb) <- c(nrow(mat)*ncol(mat), 3)
                
                mat_hsv <- rgb2hsv(t(mat_rgb))
                hBin <- seq(0, 1, length.out=nH)
                sBin <- seq(0, 1, length.out=nS)
                vBin <- seq(0, 0.005, length.out=nV) 
                freq_hsv <- as.data.frame(table(factor(findInterval(mat_hsv[1,], hBin), levels=1:nH), 
                                                factor(findInterval(mat_hsv[2,], sBin), levels=1:nS), 
                                                factor(findInterval(mat_hsv[3,], vBin), levels=1:nV)))
                hsv_feature <- as.numeric(freq_hsv$Freq)/(ncol(mat)*nrow(mat))
                data[i,]<-hsv_feature
        }
        print(i)
}

data<-data.frame(dir_names,data)
save(data,file = "hsv.Rda")