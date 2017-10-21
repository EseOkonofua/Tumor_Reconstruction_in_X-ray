function Q = Point_Projector(alpha, P)
%Point Projector Summary of this function goes here
%   Detailed explanation goes here
    
    % orthonormal base vectors for detector in C-arm coordinates
    uC = [0;-75;1];
    vC = [1;-75;0];
    wC = [0;-74;0];
    
    %Rotation matrix about the Z axis
    rotationZ = [cosd(-alpha),  sind(-alpha), 0;...
                -sind(-alpha),  cosd(-alpha), 0;...
                      0,              0,       1];
            
    %The source and detector coordinates are given by the Source detector distance of 150cm, and
    %Source axis distance of 75cm.
    source = [0;75;0];
    detector = [0;-75;0];
    
    %Translate and rotate the target point
    rP = rotationZ * P;
      
    %Find where projection vector hits detector plane
    
        %Define plane using normal vector to the plane and a point on the
        %plane.
    detectorPlaneNormal = detector - wC;
    
        %Find intersection between line & plane.
    intersect = plane_line_intersect(detectorPlaneNormal, detector, source, rP);
        
    %Convert intersection point into detector coordinates.
    
        %Do a rotation and translation of intersectPoint    
        %Translation will be 75 units up. Add padding to end of vector.
    
    
    translationVector = eye(4);
    translationVector(1:3, 4) = [0; 75; 0];
    
    intersect = [intersect; 1];    
    Q = translationVector*intersect;
    
    %Change Z Coordinate to the X coordinate & Switch X coordinate to Y
    %cooordinate
    % This simulates 2 90 degree rotations to switch to detector
    % coordinates.
    x = Q(3);
    y = Q(1);
    Q = [x; y; 0];
end

