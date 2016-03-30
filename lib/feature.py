import numpy as np
import cv2
import os
import scipy.cluster.vq as vq
from sklearn.cluster import MiniBatchKMeans, KMeans


mypath = '/Users/MengyingLiu/Documents/stat4249/project3/images'
pppath = '/Users/MengyingLiu/Documents/stat4249/project3/cropimage'
descs =np.empty((0,128))
n_cluster=1000
sift = cv2.xfeatures2d.SIFT_create()
n = 0
feature = np.empty((0,n_cluster))
start = 0
for y in range(1,len(os.listdir(pppath))/500+1):
    descs =np.empty((0,128))
    tail = y*500
    if tail > len(os.listdir(pppath)):
        tail =len(os.listdir(pppath))
    for x in range(start,tail):
        if '.jpeg' in os.listdir(pppath)[x]:  # this could be more correctly done with os.path.splitext
            image = cv2.imread(os.path.join(pppath, os.listdir(pppath)[x]))
            if (type(image) is np.ndarray):
                print x
                gray= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
                (kps,des) = sift.detectAndCompute(gray, None)
                descs=np.concatenate((descs,des),axis = 0)
    start = tail+1
    np.savetxt('sift_crop'+str(y)+'.txt', descs, delimiter=" ", fmt="%s")

descs =np.empty((0,128))
for y in range(1,len(os.listdir(pppath))/500+1):
    print y
    r = np.loadtxt('/Users/MengyingLiu/Documents/stat4249/project3/sift_crop'+str(y)+'.txt')
    descs=np.concatenate((descs,r),axis = 0)
    
mbk = MiniBatchKMeans(init='k-means++', n_clusters=n_cluster, batch_size=100,
                      n_init=10, init_size = 3*n_cluster,max_no_improvement=20, verbose=0,compute_labels= False)
mbk.fit(descs)
codebook = mbk.cluster_centers_
np.savetxt('sift_crop_codebook.txt', codebook, delimiter=" ", fmt="%s")
codebook =np.loadtxt('sift_crop_codebook.txt')
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

feature = np.empty((0,n_cluster))
image_name =[]
for x in range(1,7388):
    item = os.listdir(mypath)[x]
    if '.jpg' in item:  # this could be more correctly done with os.path.splitext
        image = cv2.imread(os.path.join(mypath, item))
        if (type(image) is np.ndarray):
            print x
            image_name.append(item)
            gray= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
            (kps,des) = sift.detectAndCompute(gray, None)
            result = computeHistograms(codebook,des)
            feature =np.vstack((feature,result))

np.savetxt('sift_crop.txt', np.column_stack((image_name, feature)), delimiter=" ", fmt="%s")



#skew
def deskew(img):
    m = cv2.moments(img)
    if abs(m['mu02']) < 1e-2:
        return img.copy()
    skew = m['mu11']/m['mu02']
    M = np.float32([[1, skew, -0.5*SZ*skew], [0, 1, 0]])
    img = cv2.warpAffine(img,M,(SZ, SZ),flags=affine_flags)
    return img








#hog
winSize = (64,64)
blockSize = (16,16)
blockStride = (8,8)
cellSize = (8,8)
nbins = 9
derivAperture = 1
winSigma = 4.
histogramNormType = 0
L2HysThreshold = 2.0000000000000001e-01
gammaCorrection = 0
nlevels = 64
hog = cv2.HOGDescriptor(winSize,blockSize,blockStride,cellSize,nbins,derivAperture,winSigma,
                        histogramNormType,L2HysThreshold,gammaCorrection,nlevels)
winStride = (8,8)
padding = (8,8)
locations = ((10,20),)
deshog= np.empty((0,1764))
image_name =[]

for x in range(1,7388):
    item = os.listdir(mypath)[x]
    if '.jpg' in os.listdir(mypath)[x]:  # this could be more correctly done with os.path.splitext
        image = cv2.imread(os.path.join(mypath, os.listdir(mypath)[x]))
        if (type(image) is np.ndarray):
            image_name.append(item)
            hist = hog.compute(image,winStride,padding,locations)
            deshog=np.vstack((deshog,hist.flatten()))


np.savetxt('hog.txt', np.column_stack((image_name, deshog)), delimiter=" ", fmt="%s")




#rootsift
import numpy as np
import cv2
import os
import scipy.cluster.vq as vq
from sklearn.cluster import MiniBatchKMeans, KMeans


mypath = '/Users/MengyingLiu/Documents/stat4249/project3/images'
pppath = '/Users/MengyingLiu/Documents/stat4249/project3/cropimage'
txt = open('/Users/MengyingLiu/Documents/stat4249/project3/images/cropinfo.txt')
descs =np.empty((0,128))
sift = cv2.xfeatures2d.SIFT_create()
n = 0
feature = np.empty((0,n_cluster))
start = 0
eps = 1e-7
n_cluster=1000
sift = cv2.xfeatures2d.SIFT_create()
n = 0
feature = np.empty((0,n_cluster))
descs =np.empty((0,128))
start = 0
for y in range(1,8):
    descs =np.empty((0,128))
    tail = y*500
    if tail > 3700:
        tail =3700
    for x in range(start,tail):
        if '.jpeg' in os.listdir(pppath)[x]:  # this could be more correctly done with os.path.splitext
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
for y in range(1,8):
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

feature = np.empty((0,n_cluster))
image_name =[]
for x in range(1,7388):
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

