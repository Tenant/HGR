# Hand Gesture Recognition Project.

## Project Introduction

## File Description

### Script:

### Function:
- bgdSub.m: 基于Background Subtraction算法实现前景背景分割，分割在RGB色彩空间进行.

- bgdSub_hsv.m: 基于Background Subtraction算法实现前景背景分割，分割在HSV色彩空间进行.

- bgdSub_Intensity.m: 基于Background Subtraction算法实现前景背景分割，分割参数为图像灰度值.

- calCircul.m: 计算输入BW图像的圆度.

- createPalmMask.m: 创建手掌蒙版.

- eigenExtract.m: 提取手势的角度特征向量.

- extract_Skincolor_Background_Model.m: 提取背景中的类肤色区域.

- imCluster.m: 对图像中RGB参数相近区域进行聚类.

- imDiff.m: 基于Image Difference算法提取图像中的运动区域.

- invmoments.m: 计算图像的7阶Hu不变矩.

- mark.m: 基于输入的蒙版在原图像上添加彩色标签.

- medfilt_RGB.m: 对RGB图像进行中值滤波.

- Region_based_Combination.m: 整合多种图像分割算法的结果.

### Data:
- SPM_off.mat: Off-line SPM traing results.

- SPM_Data_Set: Skincolor Probability Map offline training dataset, Retrieved from http://sun.aei.polsl.pl/~mkawulok/gestures/

- test1.jpg:
 
- test2.jpg:

- test3.jpg:

- test4.jpg:

### Reference:

- SkinColourDetection-master: SPM Reference Project, Retrived from git@github.com:neEverett/SkinColourDetection

- Support-Vector-Machine-master: SVM Reference Project, Retrieved from git@github.com:martinarjovsky/Support-Vector-Machine.git

### GUI.fig

GUI Interface

### GUI.m

GUI supporting code



### SPM_test.m

function, to label the skin-color area in the input image

### SPM_test_batch.m

The batch version of SPM_test.m

### SPM_train.m

function, to train Skin-color Probability Map.

### bgdSub.m

function, extract ROI using Background Substraction Algorithm.

### calCircul.m

function, calculating the circularity of the input BW image.

### createPalmMask.m

function, extract ROI by setting skin-color threshold.

### eigenExtract.m

function, calculate the vector descriptor of hand gesture.

### imDiff.m

function, extract ROI using Image Differecing Algorithm.


