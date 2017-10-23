% This is the testing script that will run problems with known ground truths
% testing each Tumor_Reconstruction module.


%%% %%% %%% %%% %%% %%% %%% 
%%% Test Point_Projector %%%
%%% %%% %%% %%% %%% %%% %%% 

source = [0;75;0];
detector = [0;-75;0];

% Test whith no rotation

% Ground truth ans = [2; 2; 0]
point1 = Point_Projector(0, [1; 0; 1]);
point1C = [point1(2); -75; point1(1)];

% Ground truth ans = [-2; -2; 0]
point2 = Point_Projector(0, [-1; 0; -1]);
point2C = [point2(2); -75; point2(1)];

% Ground truth ans = [0; 0; 0] 
point3 = Point_Projector(0, [0; 0; 0]);
point3C = [point3(2); -75; point3(1)];

% Ground truth ans = [-2; 2; 0]
point4 = Point_Projector(0, [1; 0; -1]);
point4C = [point4(2); -75; point4(1)];

% Ground truth ans = [2; -2; 0]
point5 = Point_Projector(0, [-1; 0; 1]);
point5C = [point5(2); -75; point5(1)];


figure
plot3(source(1), source(2), source(3), '*', 'MarkerSize', 20);
hold on

%Plot projection targets
plot3(1, 0, 1, '.', 'MarkerSize', 12);
plot3(-1, 0, -1, '.', 'MarkerSize', 12);
plot3(0, 0, 0, '.', 'MarkerSize', 12);
plot3(1, 0, -1, '.', 'MarkerSize', 12);
plot3(-1, 0, 1, '.', 'MarkerSize', 12);

% Plot projection lines
plot3([source(1); point1C(1)], [source(2); point1C(2)], [source(3); point1C(3)])
plot3([source(1); point2C(1)], [source(2); point2C(2)], [source(3); point2C(3)])
plot3([source(1); point3C(1)], [source(2); point3C(2)], [source(3); point3C(3)])
plot3([source(1); point4C(1)], [source(2); point4C(2)], [source(3); point4C(3)])
plot3([source(1); point5C(1)], [source(2); point5C(2)], [source(3); point5C(3)])

%Plot projected points
plot3(point1C(1), point1C(2), point1C(3), '.', 'MarkerSize', 16);
plot3(point2C(1), point2C(2), point2C(3), '.', 'MarkerSize', 16);
plot3(point3C(1), point3C(2), point3C(3), '.', 'MarkerSize', 16);
plot3(point4C(1), point4C(2), point4C(3), '.', 'MarkerSize', 16);
plot3(point5C(1), point5C(2), point5C(3), '.', 'MarkerSize', 16);

theta = linspace(0,2*pi);
x = 15*cos(theta);
y = -75*ones(1, 100);
z = 15*sin(theta);
plot3(x,y,z)
hold off
title('Point Projections')



%%% %%% %%% %%% %%% %%% %%% 
%%% Test Tumor_Projector %%%
%%% %%% %%% %%% %%% %%% %%% 
%Radius 3cm sphere with 200 points.
n = 200;
spherePoints = zeros(3, n);
for  i = 1:n
    spherePoints(:,i) = GetRandomPointOnSphere([0,0,0], 3, 'all')';
end

contour = Tumor_Projector(0, spherePoints);

figure
title('Tumor Projections of Ellipses')
subplot(2,2,[1 2])
plot(contour(1, :), contour(2, :))
title('Tumor Projection of Sphere of 3cm')

%Ellipsoid a=1, b=2, c=3
ellipsoidPoints = zeros(3, n);
for i = 1:n
   ellipsoidPoints(:, i) = GetRandomPointOnEllipsoid([0,0,0], 1, 2, 3, 'all')';
end

contour = Tumor_Projector(0, ellipsoidPoints);

subplot(2,2,3)
plot(contour(1, :), contour(2, :))
title('Tumor Projection of Ellipsoid at 0deg')

contour = Tumor_Projector(90, ellipsoidPoints);

subplot(2,2,4)
plot(contour(1, :), contour(2, :))
title('Tumor Projection of Ellipsoid at 90deg')

%%% %%% %%% %%% %%% %%% %%% 
%%% Test Super_Sphere %%%
%%% %%% %%% %%% %%% %%% %%% 

%Simulate the rotation of c-arm by taking many silhouette images on
%different angles.
%Imaging angles, alpha
[~, silhouettes] = Generate_Silhouettes(ellipsoidPoints,0,90,90);
radius = Super_Sphere(silhouettes);

figure
[x,y,z] = sphere;
surf(x*radius,y*radius,z*radius)
alpha 0.3
hold on
scatter3(ellipsoidPoints(1, :), ellipsoidPoints(2, :),ellipsoidPoints(3, :), 'filled')
hold off
title('Super Sphere and Ellipsoid Points')
%Plot super sphere and ellipsoid

%%% %%% %%% %%% %%% %%% %%% %%%
%%% Test Tumor_Reconstructor %%%
%%% %%% %%% %%% %%% %%% %%% %%% 

%Ground thruth ellipsoidal tumor at (1,1,1) with axes a=1, b=2, c=3
groundTruthVolume = 25.13;
numImages = [];
volumes = [];
tumorPoints = zeros(3, n);
for i = 1:n
    tumorPoints(:, i) = GetRandomPointOnEllipsoid([1,1,1], 1, 2, 3, 'all')';
end

%Images taken at every imaging angle 0.
[alphaVector, silhouettes] = Generate_Silhouettes(tumorPoints,0,360,0);
[contour, volume, k, truePoints]  = Tumor_Reconstructor(alphaVector, silhouettes);
numImages = [numImages numel(alphaVector)];
volumes = [volumes volume/groundTruthVolume];

figure
subplot(2,3,1)
trisurf(k, truePoints(1, :), truePoints(2, :), truePoints(3, :));
title('Tumor Reconstruction at only angle 0deg')

%Images taken at every imaging angle 180.
[alphaVector, silhouettes] = Generate_Silhouettes(tumorPoints,0,360,180);
[contour, volume, k, truePoints]  = Tumor_Reconstructor(alphaVector, silhouettes);
numImages = [numImages numel(alphaVector)];
volumes = [volumes volume/groundTruthVolume];

subplot(2,3,2)
trisurf(k, truePoints(1, :), truePoints(2, :), truePoints(3, :));
title('Tumor Reconstruction at every angle 180deg')

%Images taken at every imaging angle 90.
[alphaVector, silhouettes] = Generate_Silhouettes(tumorPoints,0,360,90);
[contour, volume, k, truePoints]  = Tumor_Reconstructor(alphaVector, silhouettes);
numImages = [numImages numel(alphaVector)];
volumes = [volumes volume/groundTruthVolume];

subplot(2,3,3)
trisurf(k, truePoints(1, :), truePoints(2, :), truePoints(3, :));
title('Tumor Reconstruction at every angle 90deg')

%Images taken at every imaging angle 60.
[alphaVector, silhouettes] = Generate_Silhouettes(tumorPoints,0,360,60);
[contour, volume, k, truePoints]  = Tumor_Reconstructor(alphaVector, silhouettes);
numImages = [numImages numel(alphaVector)];
volumes = [volumes volume/groundTruthVolume];

subplot(2,3,4)
trisurf(k, truePoints(1, :), truePoints(2, :), truePoints(3, :));
title('Tumor Reconstruction at every angle 60deg')

%Images taken at every imaging angle 30.
[alphaVector, silhouettes] = Generate_Silhouettes(tumorPoints,0,360,30);
[contour, volume, k, truePoints]  = Tumor_Reconstructor(alphaVector, silhouettes);
numImages = [numImages numel(alphaVector)];
volumes = [volumes volume/groundTruthVolume];

subplot(2,3,5)
trisurf(k, truePoints(1, :), truePoints(2, :), truePoints(3, :));
title('Tumor Reconstruction at every angle 30deg')

%Images taken at every imaging angle 15.
[alphaVector, silhouettes] = Generate_Silhouettes(tumorPoints,0,360,15);
[contour, volume, k, truePoints]  = Tumor_Reconstructor(alphaVector, silhouettes);
numImages = [numImages numel(alphaVector)];
volumes = [volumes volume/groundTruthVolume];

subplot(2,3,6)
trisurf(k, truePoints(1, :), truePoints(2, :), truePoints(3, :));
title('Tumor Reconstruction at every angle 15deg')

figure
plot(numImages, volumes)
title('Number of Images vs Volume Reconstruction Accuracy')
xlabel('Number of Images')
ylabel('Volume Recon. Accuracy')

hold on 
plot(numImages, ones(numel(numImages)))
hold off

legend('Volume reconstruction accuracy', 'Target accuracy')