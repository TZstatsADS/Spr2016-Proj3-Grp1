# Project CatsDogs: Predictive analytics-model evaluation and selection

Ziyue Wu, Qiner Shi, Yanran Wang, Mengying Liu

#### - for cats versus dogs image data

Read [full project description](doc/project3_desc.md)

In this project, we will carry out model evaluation and selection for predictive analytics on image data. As data scientists, we often need to evaluate different modeling/analysis strategies and decide what is the best. Such decisions need to be supported with sound evidence in the form of model assessment, validation and comparison. In addition, we also need to communicate our decision and supporting evidence clearly and convincingly in an accessible fashion.

![image](https://i.ytimg.com/vi/8Ryo8Pf4NNE/hqdefault.jpg)

##Quick Summary 

##Data Cleaning
1. Format preprocessing
⋅⋅* selected pictures with right JPG format from 7390 pictures
⋅⋅* Deleted pictures with format that triggered error with approximately 10 pictures
⋅⋅* Matching dogs and cats labels with each pictures

2. Resized the images for CNN


##Feature Extraction 
1. HSV Color Features (as our baseline model) 

2. Root SIFT

3. Hog

4. HSV Color Features + Root SIFT

5. Convolutional Neural Networks 


##Classification Models 

1. Linear SVM (with Cross Validated parameter cost = 1)

2. Extreme Gradient Boosting (with Cross Validated parameter 50)

##Performance and Results

###Accuracy 

###Imbalance data set (train with 6000 pictures randomly sampled from the tree ) 
Pictures of dog are 1.5 times more than cats.

| Correct Rate     | HSV color (6*6*10)| Root SIFT with 1000 bins| Hog |HSV+SIFT|CNN(Vgg-Net 21st layer)|
| -----------------|:-----------------:| :----------------------:|:---:|:------:|:---------------------:|
| Linear SVM       | 69.8%			   | 57.8% 				     |59.7%| N/A	|94.5%					|		
| Gradient Boosting| 70.3% 			   | 65.4%					 |65.6%| 77.1%	|N/A     				|

For the imbalance data set, our baseline model predicted test set pictures as all dogs and obtained almost 70% of correct rate. Therefore, we decided to train out model with a balance data set to see if that matters a lot.

###balance data set 

| Correct Rate     | HSV color (6*6*10)| Root SIFT with 1000 bins| Hog |HSV+SIFT|CNN(Vgg-Net 21st layer)|
| -----------------|:-----------------:| :----------------------:|:---:|:------:|:---------------------:|
| Linear SVM       | 55.4%			   | 55.3% 				     |56.4%| N/A	|95.3%					|		
| Gradient Boosting| 70.1% 			   | 67.3%					 |64.3%| 77.1%	|N/A     				|

###Cost of training time

| Time (s)    	   | HSV color (10*10*10)| Root SIFT with 1000 bins|CNN(Vgg-Net 21st layer)|
| -----------------|:-------------------:| :----------------------:|:---------------------:|
| Linear SVM       | 71.737		   	  	 | 162.368				   |49.492				   |		
| Gradient Boosting| 28.3   	 		 | 30.2 				   |N/A     			   |


##Conclusion
In order to reduce the influence from overfitting. 
we have the following approaches.
1.	cross validation for classifier
2.	reduce noise for feature extraction. 

e.g.
![image](https://raw.githubusercontent.com/TZstatsADS/cycle3cvd-team1/master/lib/1.pic.jpg)

For example, when we have SIFT feature extraction, background noise has a significant influence for our model training.
The model tried to fit with tht noise. Therefore, we cropped most of the pictures for feature extraction, which improve the performance around 5%.












---
Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.

