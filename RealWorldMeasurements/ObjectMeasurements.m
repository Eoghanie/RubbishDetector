%% Object property measurements with camera
% Written by: Eoghan Mckay
% Date written: 10/04/2022
% Calibrate an iPhone X camera with Matlab 'Camrea Calibration' app. Pixel
% units can be converted to real world units using a checkerboard as
% a reference in the images.

% Auto-generated by cameraCalibrator app on 10-Apr-2022
%-------------------------------------------------------


% Define images to process
imageFileNames = {'C:\Users\emcka\MATLAB Drive\IMG_0159.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0160.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0161.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0162.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0163.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0164.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0166.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0167.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0170.jpg',...
    'C:\Users\emcka\MATLAB Drive\IMG_0171.jpg',...
    };
% Detect calibration pattern in images
detector = vision.calibration.monocular.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates for the planar pattern keypoints
squareSize = 22;  % in units of 'millimeters'
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters...
    (imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

magnification = 25;
imOrig = imread('IMG_0150.jpg');
figure; imshow(imOrig, 'InitialMagnification', magnification);
title('Input Image');

% Convert the image to the HSV color space.
imCoin = bot(imOrig);
filt = fspecial("disk",9);
imCoin = imfilter(imCoin,filt,'replicate');
figure; imshow(imCoin, 'InitialMagnification', magnification);
title('Segmented Shapes');

% Find connected components.
blobAnalysis = vision.BlobAnalysis('AreaOutputPort', true,...
    'CentroidOutputPort', true,...
    'BoundingBoxOutputPort', true,...
    'MajorAxisLengthOutputPort', true,...
    'ExcludeBorderBlobs', true);
[areas,centroid,boxes,major] = step(blobAnalysis, imCoin);

% Sort connected components in descending order by area
[~, idx] = sort(areas, 'Descend');

% Get the two largest components.
boxes = double(boxes(1, :));

% Reduce the size of the image for display.
scale = magnification / 100;
imDetectedCoins = imresize(imOrig, scale);

% Insert labels for the coins.
imDetectedCoins = insertObjectAnnotation(imDetectedCoins, 'rectangle', ...
    scale * boxes, 'Shape');
figure; imshow(imDetectedCoins);
title('Detected Shapes');

% Detect the checkerboard.
[im, newOrigin] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');
[imagePoints, boardSize] = detectCheckerboardPoints(imOrig);

% Adjust the imagePoints so that they are expressed in the coordinate system
% used in the original image, before it was undistorted.  This adjustment
% makes it compatible with the cameraParameters object computed for the original image.
imagePoints = imagePoints + newOrigin; % adds newOrigin to every row of imagePoints

% Compute rotation and translation of the camera.
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);

% Adjust upper left corners of bounding boxes for coordinate system shift 
% caused by undistortImage with output view of 'full'. This would not be
% needed if the output was 'same'. The adjustment makes the points compatible
% with the cameraParameters of the original image.
boxes = boxes + [newOrigin, 0, 0]; % zero padding is added for width and height
numbox = numel(areas);


% Get the top-left and the top-right corners.
box2 = double(boxes(1, :));
imagePoints2 = [box2(1:2); ...
                box2(1) + box2(3), box2(2)];

% Apply the inverse transformation from image to world            
worldPoints2 = pointsToWorld(cameraParams, R, t, imagePoints2);            

% Compute the diameter of the coin in millimeters.
d = worldPoints2(2, :) - worldPoints2(1, :);
diameterInMillimeters = hypot(d(1), d(2));
fprintf('Major axis of bottle = %0.2f mm\n', diameterInMillimeters);

%% If more than one object in image
box3 = double(boxes(3, :));
imagePoints2 = [box3(1:2); ...
                box3(1) + box3(3), box3(2)];

% Apply the inverse transformation from image to world            
worldPoints2 = pointsToWorld(cameraParams, R, t, imagePoints2);            

% Compute the diameter of the coin in millimeters.
d = worldPoints2(2, :) - worldPoints2(1, :);
diameterInMillimeters = hypot(d(1), d(2));
fprintf('Major axis 3 = %0.2f mm\n', diameterInMillimeters);

box4 = double(boxes(4, :));
imagePoints2 = [box4(1:2); ...
                box4(1) + box4(3), box4(2)];

% Apply the inverse transformation from image to world            
worldPoints2 = pointsToWorld(cameraParams, R, t, imagePoints2);            

% Compute the diameter of the coin in millimeters.
d = worldPoints2(2, :) - worldPoints2(1, :);
diameterInMillimeters = hypot(d(1), d(2));
fprintf('Major axis 4 = %0.2f mm\n', diameterInMillimeters);

box5 = double(boxes(5, :));
imagePoints2 = [box5(1:2); ...
                box5(1) + box5(3), box5(2)];

% Apply the inverse transformation from image to world            
worldPoints2 = pointsToWorld(cameraParams, R, t, imagePoints2);            

% Compute the diameter of the coin in millimeters.
d = worldPoints2(2, :) - worldPoints2(1, :);
diameterInMillimeters = hypot(d(1), d(2));
fprintf('Major axis 5 = %0.2f mm\n', diameterInMillimeters);

box4 = double(boxes(6, :));
imagePoints2 = [box4(1:2); ...
                box4(1) + box4(3), box4(2)];

% Apply the inverse transformation from image to world            
worldPoints2 = pointsToWorld(cameraParams, R, t, imagePoints2);            

% Compute the diameter of the coin in millimeters.
d = worldPoints2(2, :) - worldPoints2(1, :);
diameterInMillimeters = hypot(d(1), d(2));
fprintf('Major axis 6 = %0.2f mm\n', diameterInMillimeters);