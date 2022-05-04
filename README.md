# RubbishDetectionProject
This repository contains code for identifying, locating and measuring in real-world units rubbish items on stony beaches. Code for image processing, image classification with convolutional neural networks and transfer learning in Matlab is available.
The code here comprises my final year project 'Developing Computer Vision Software to Identify and Locate Rubbish on Stony Beaches'. All algorithms developed are done in Matlab. In other words the vision system for WALL-E if it were cleaning stony beachs only and looking and avoiding organic things.

TACO waste in the wild dataset has 1500 images with +330,000 anotations. It has segmentation, bounding box and class data for images of waste in the wild.
Link to Kaggle download TACO dataset - https://www.kaggle.com/datasets/kneroma/tacotrashdataset

![WALL-E](https://user-images.githubusercontent.com/94704200/166167617-85e48ff0-a447-4aaa-a41a-ff1ce2cc9401.jpg)

There are three folders;
Ensure you have th ecorrect toolboxes dowloaded for the code to run. Image Processing and Computer Vision toolboxes are the most important but there are many more used in this work. Not all are required for each part.

# Image Processing
Functions for segmenting objects in different colour spaces are shown here. 

a. backgroundLab is generated in the Lab colourspace, the background region isolated and an inversted mask is created that will remove the background and segment an object.

b. bluestones is created for backgrounds with blue, cold pale stones.

c. clear bottle is created in the Lab colur space to identify clear bottles. Is not effective across a range of tints and backgrounds.

d. functiontester allows for multiple images to be run through a desired function so that the effectiveness of a function can be seen on multiple images as opposed to a single one at a time.

e. intensityHSV segments objects in the HSV colour space. It works of the understanding that plastics are often intensely coloured relative to their surroundings.

![image](https://user-images.githubusercontent.com/94704200/166587187-1c840858-561c-4c3a-bcf6-26db2cb46274.png)


# Image Classification

a. Before and after training results for efficientnetb0 classification neural network in 'Classified efficientnetb0 untrained' and '...trained' respectively.

![image](https://user-images.githubusercontent.com/94704200/166585954-b8f3045e-b42c-409e-b695-8d870e21c604.png)

b. ClassifyTests runs the test images through the selected neural network using a for loop and saves the result.
Toolboxes required
- Computer Vision Toolbox
- Deep Learning Toolbox for any Neural Network you want to use.

c. ResnetRetrain trains resnet50 neural network on a subset of TACO dataset.

Useful link - https://uk.mathworks.com/help/deeplearning/ug/transfer-learning-with-deep-network-designer.html

d. TransferLearningTACOsubset trains multpiple neural networks that are selected in the code on a subset of the TACO dataset. The toolbox for each networks to be trained must be downloaded for the code to run. Training options can be varied here.

e. iPhoneLink allows for your mobile phone to capture an image and classify it with the trained network or any network you desire.

d. Trained squeezenet neural network matlab file.


# RealWorldMeasurements

a. CentroidAlgorithmKinect uses an Xbox 360 Kinect sensor to generate a point cloud of a scene. Blob analysis is done to find the centroid of the object in a 2D scene. This 2D centroid is matched in the point cloud to find the x,y,z coordinates of the centroid relative to the RGB cmera on the kinect sensor. It also classifies the image using a googlenet neural network for image classification trained on a subset of TACO waste in the wild dataset.
Toollboxes required; 
- Image Acquisition Toolbox Support Package for Kinect for Windows Sensor
- Deep Learning Toolbox Model for GoogLeNet Network
- Computer Vision Toolbox
- Image Processing Toolbox
- Deep Learining Toolbox

![IMG_0145](https://user-images.githubusercontent.com/94704200/166576879-af8aa43c-fc8d-4d6e-87ec-0819dad87af2.jpg)
![image](https://user-images.githubusercontent.com/94704200/166577454-e9ce4c50-9cb1-49bb-a199-60bed9307d19.png)


b. ObjectMeasurements measures the major axis of items segmented from images taken from a calibrated camera. An iPhone X camera is calibrated using a checkerboard pattern in Matlab 'Camera Calibration' app. The checkerboard pattern can be found in this folder also. 
Toolboxes required;
- Computer Vision Toolbox
- Image Processing Toolbox

![image](https://user-images.githubusercontent.com/94704200/166577754-57280a37-a363-44e0-bbda-3e66dade9738.png)

See this youtube video for calibrating a camera in the app - https://www.youtube.com/watch?v=x6YIwoQBBxA

# Object Detection 
With great difficulty a mask r-cnn OD was set up to begin training on TACO however the time it would take for the code to code to train was infeasible with the hardware available. The example followed for mask r-cnn: https://github.com/matlab-deep-learning/mask-rcnn

The test images were run through on an SSD MobileNetv2 OD to inspect its classification accuracy relatively to the IC+IP seperately.
Trained SSD MobileNetv2 used for testing: https://www.kaggle.com/code/bouweceunen/training-ssd-mobilenet-v2-with-taco-dataset/data

![redwrap](https://user-images.githubusercontent.com/94704200/166655925-316e0222-71d2-4bf5-9553-983fd959f8ce.jpg)


