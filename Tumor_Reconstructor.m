function [contour, volume, k, truePoints] = Tumor_Reconstructor(alphaVector, silhouettes)
%Tumor_Reconstructor Reconstruct a tumor?s outer shell as a closed convex surface tumor from its silhouettes and compute
%the tumor volume
%   Returns 
%   contour, the cell containing triangles that make up the tumor
%   reconstruction.
%   volume, the volume of the reconstructed tumor.
%   k, indices of points that make up contour of tumor
%   truePoints, points determined to be on and in the tumor
    source = [0;75;0];
    
    numSilhouettes = size(silhouettes, 2);
    lineMatrix = zeros(3, numSilhouettes*2);

    for i = 1:numSilhouettes
       s = silhouettes{i};

       %convert points to c - arm coordinates
       for j = 1:size(s, 2)
          s(:, j) = [s(2, j), -75, s(1, j)];
       end
   
       %find the centre of the contour.
       centre = mean(s, 2);
       
       %Rotation matrix about the Z axis
       rotationZ = [ cosd(alphaVector(i)),  sind(alphaVector(i)), 0;...
                    -sind(alphaVector(i)),  cosd(alphaVector(i)), 0;...
                                 0,              0,               1];
                             
       %Rotate the source and detector point                      
       rCentre = rotationZ*centre;
       rSource = rotationZ*source;
       
       %Fill up lineMatrix array
       lineMatrix(:, i +(i-1)) = rCentre;
       lineMatrix(:, i*2) = rSource;
    end
    
    lineMatrix = mat2cell(reshape(lineMatrix, 1, numel(lineMatrix)), 1, 3*ones(1, size(lineMatrix, 2)));
    if numSilhouettes < 2
        intersect = [0;0;0];
    else
        intersect = Intersect_N_Lines(lineMatrix{:})';
    end
    
    radius = Super_Sphere(silhouettes);
    
    superSpherePoints = [];
    
    %Put a cube around the sphere and use it to step through the sphere
    %uniformly.
    stepPoint = intersect - radius;
    
    %stepCount aka Voxel size will affect resolution of reconstruction
    stepCount = 0.25;
    
    for x = 0:stepCount:radius*2
        for y = 0:stepCount:radius*2
            for z = 0:stepCount:radius*2
                newPoint = stepPoint + [x;y;z];
                
                indicator = norm(intersect - newPoint);
                %IF in the super sphere add it to the superSpherepoints
                if indicator <= radius
                    superSpherePoints = [superSpherePoints newPoint];
                end
            end 
        end
    end
    
    %For each angle
    for i = 1:numSilhouettes
       %Project each point and then check to see if it lies within the
       %contour of that angle. If it does... add it to the true points.
       for j = size(superSpherePoints, 2):-1:1
           p = Point_Projector(alphaVector(i), superSpherePoints(:, j));
           
           s = silhouettes{i};
           
           [in, on] = inpolygon(p(1), p(2), s(1,:), s(2,:));
           
           %if projected point is not in or on the contour then it is a
           %false point
           if ~(in || on)
               superSpherePoints(: ,j) = [];
           end
       end
    end
    truePoints = superSpherePoints;
    
    [k ,volume] = convhull(truePoints(1, :), truePoints(2, :), truePoints(3, :));
    contour = truePoints(:, k');
    contour = mat2cell(contour, 3, 3*ones(1, size(k, 1)));
end

