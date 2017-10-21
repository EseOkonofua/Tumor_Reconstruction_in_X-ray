function contour = Tumor_Projector(alpha, tumorPoints)
%Tumor_Projector Generates silhouette of a closed convex tumor object on the detector at some C-arm imaging angle. The
%tumor is defined by an array of its surface points. The result is a polygon on the detector plane
%   Detailed explanation goes here
    [m, n] = size(tumorPoints);
    projectedPoints = zeros(m, n);
    
    %Projected each point in the tumor points.
    for i = 1:n
        projectedPoints(:, i) = Point_Projector(alpha, tumorPoints(:, i));
    end
    
    %Get points that make up contour of points
    k = convhull(projectedPoints(1,:), projectedPoints(2,:));
    contour = projectedPoints(:, k);
end

