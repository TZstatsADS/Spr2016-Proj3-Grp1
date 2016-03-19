import numpy as np
import cv2
import os
import scipy.cluster.vq as vq

mypath = '/Users/MengyingLiu/Documents/stat4249/project3/images'

images = list()
descs =np.empty((0,128))
n_cluster=50
sift = cv2.xfeatures2d.SIFT_create()
for item in os.listdir(mypath):
    if '.jpg' in item:  # this could be more correctly done with os.path.splitext
        print item
        image = cv2.imread(os.path.join(mypath, item))
        gray= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
        (kps,des) = sift.detectAndCompute(gray, None)
        images.append(image)
        descs=np.concatenate((descs,des),axis = 0)

#descs=np.float32(descs)
#ret,label,center=cv2.kmeans(descs,200,None,criteria,10,cv2.KMEANS_RANDOM_CENTERS)
codebook, distortion = vq.kmeans(descs,
                                 n_cluster,
                                 thresh=1)

def computeHistograms(codebook, descriptors):
    code, dist = vq.vq(descriptors, codebook)
    histogram_of_words, bin_edges = np.histogram(code,
                                              bins=range(codebook.shape[0] + 1),
                                              normed=True)
    return histogram_of_words

feature = np.empty((0,n_cluster))
image_name =[]
for item in os.listdir(mypath):
    if '.jpg' in item:  # this could be more correctly done with os.path.splitext
        image_name.append(item)
        image = cv2.imread(os.path.join(mypath, item))
        gray= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
        (kps,des) = sift.detectAndCompute(gray, None)
        result = computeHistograms(codebook,des)
        feature =np.vstack((feature,result))

savetxt('features.txt',features)
savetxt('names.txt',image_name)