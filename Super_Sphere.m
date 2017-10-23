function radius = Super_Sphere(silhouettes)
%Supher_Sphere computes super-sphere which is the smallest sphere that centered in the in the center of the C-arm
%coordinate system and completely encompasses tumor object to be reconstructed
%   Input:
%   silhouettes, Cell containing silhouettes of tumor taken at different
%   angles.

%   Output:
%   radius, Radius of the generated super sphere

    %Source axis distance of 75cm.
    source = [0;75;0];
    patientPlaneNormal = [0, 1, 0]; 
    
    %initialize super sphere min radius
    %calculate max distance from origin. This will be the radius of
    %Super Sphere.
    radius = 0;
    
    %back project silhouette points
    for i = 1:size(silhouettes, 2)
       s = silhouettes{i};
       
       %convert points to c - arm coordinates and back project points to patient plane 
       for j = 1:size(s, 2)
          s(:, j) = [s(2, j), -75, s(1, j)];

          intersect = plane_line_intersect(patientPlaneNormal, [0;0;0], s(:, j), source);
          
          %Find the distance of plane intersection to bed centre.
          distance = norm(intersect - [0;0;0]);
          
          if distance > radius
              radius = distance;
          end
       end
          
    end
end

