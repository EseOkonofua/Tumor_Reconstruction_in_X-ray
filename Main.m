% This is the testing script that will run problems with known ground truths
% testing each Tumor_Reconstruction module.

fID = fopen('output.txt','w');

fprintf(fID, '----Tumor Reconstruction in X-Ray by Ese Okonofua - 10107285----\n\n');
%%% %%% %%% %%% %%% %%% %%% 
%%% Test Tumor_Projector %%%
%%% %%% %%% %%% %%% %%% %%% 
%Radius 3cm sphere with 200 points.
n = 100;
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
silhouettes = {};
alphaVector = [];
sCount = 1;
for i = 0:15:180
    alphaVector = [alphaVector; i];
    contour = Tumor_Projector(i, ellipsoidPoints);
    silhouettes{sCount} = contour;
    sCount = sCount + 1;
end

radius = Super_Sphere(alphaVector, silhouettes)

%Plot super sphere and ellipsoid

%%% %%% %%% %%% %%% %%% %%% %%%
%%% Test Tumor_Reconstructor %%%
%%% %%% %%% %%% %%% %%% %%% %%% 

Tumor_Reconstructor(alphaVector, silhouettes);

fclose(fID);
%