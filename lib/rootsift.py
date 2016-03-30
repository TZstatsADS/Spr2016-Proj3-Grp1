#rootsift
import numpy as np
import cv2
import os
import scipy.cluster.vq as vq
from sklearn.cluster import MiniBatchKMeans, KMeans

mypath = '/Users/MengyingLiu/Documents/stat4249/project3/images'
pppath = '/Users/MengyingLiu/Documents/stat4249/project3/cropimage'
sift = cv2.xfeatures2d.SIFT_create()
eps = 1e-7
n_cluster=1000
sift = cv2.xfeatures2d.SIFT_create()
n = 0
feature = np.empty((0,n_cluster))
descs =np.empty((0,128))
start = 0
for y in range(1,len(os.listdir(pppath))/500+1):
    descs =np.empty((0,128))
    tail = y*500
    if tail > (len(os.listdir(pppath))/500+1):
        tail = (len(os.listdir(pppath))/500+1)
    for x in range(start,tail):
        if '.jpg' in os.listdir(pppath)[x]:  # this could be more correctly done with os.path.splitext
            image = cv2.imread(os.path.join(pppath, os.listdir(pppath)[x]))
            if (type(image) is np.ndarray):
                print x
                gray= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
                (kps,des) = sift.detectAndCompute(gray, None)
                des /= (des.sum(axis=1, keepdims=True) + eps)
                des = np.sqrt(des)
                descs=np.concatenate((descs,des),axis = 0)
    start = tail+1
    np.savetxt('rootsift_crop'+str(y)+'.txt', descs, delimiter=" ", fmt="%s")





descs =np.empty((0,128))
for y in range(1,len(os.listdir(pppath))/500+1):
    print y
    r = np.loadtxt('/Users/MengyingLiu/Documents/stat4249/project3/rootsift_crop'+str(y)+'.txt')
    descs=np.concatenate((descs,r),axis = 0)

mbk = MiniBatchKMeans(init='k-means++', n_clusters=n_cluster, batch_size=100,
                      n_init=10, init_size = 3*n_cluster,max_no_improvement=20, verbose=0,compute_labels= False)
mbk.fit(descs)
codebook = mbk.cluster_centers_
np.savetxt('rootsift_crop_codebook.txt', codebook, delimiter=" ", fmt="%s")
codebook =np.loadtxt('rootsift_crop_codebook.txt')
#descs=np.float32(descs)
#ret,label,center=cv2.kmeans(descs,200,None,criteria,10,cv2.KMEANS_RANDOM_CENTERS)
#codebook, distortion = vq.kmeans(descs,
#                                n_cluster,
#                                thresh=1)

def computeHistograms(codebook, descriptors):
    code, dist = vq.vq(descriptors, codebook)
    histogram_of_words, bin_edges = np.histogram(code,
                                                 bins=range(codebook.shape[0] + 1),
                                                 normed=True)
    return histogram_of_words


mypath = '/Users/MengyingLiu/Documents/stat4249/project3/validate'
feature = np.empty((0,n_cluster))
image_name =[]
for x in range(1,len(os.listdir(mypath))+1):
    item = os.listdir(mypath)[x]
    if '.jpg' in item:  # this could be more correctly done with os.path.splitext
        image = cv2.imread(os.path.join(mypath, item))
        if (type(image) is np.ndarray):
            print x
            image_name.append(item)
            gray= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
            (kps,des) = sift.detectAndCompute(gray, None)
            des /= (des.sum(axis=1, keepdims=True) + eps)
            des = np.sqrt(des)
            result = computeHistograms(codebook,des)
            feature =np.vstack((feature,result))

np.savetxt('rootcrop.txt', np.column_stack((image_name, feature)), delimiter=" ", fmt="%s")

