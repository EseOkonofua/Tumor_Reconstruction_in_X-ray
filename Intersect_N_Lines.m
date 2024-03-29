% Author: Eseoghene Okonofua <EseO@Eseoghenes-MacBook-Pro.local>
% Created: 2017-09-20

% Intersect-N-Lines
% Input:
    % (
    % [line1point1x, line1point1y, line1point1z], [line1point2x, line1point2y, line1point2z],
    % [line2point1x, line2point1y, line2point1z], [line2point2x, line2point2y, line2point2z],
    % [line3point1x, .............)
% Ouput:
    % Intersection point: [x,y,z], avg distance, std

function [Point, AvgDistance, Std] = Intersect_N_Lines (varargin)
    %make sure there are pairs of lines as arguments
    if rem(nargin, 2) ~= 0
        error('Arguments are not valid, The inputs must be pairs of line coordinates.')
    end
    
    %validate inputs
    for i = 1:nargin
       Verify_Numerical_Inputs(varargin{i});
       Verify_3d_Inputs(varargin{i});
    end
    
    %reshape inputs to be used in intersection function
    vectorMatrix = reshape(cell2mat(varargin), 3, []);

    [Point, AvgDistance, D, Std] = findIntersect(vectorMatrix);

    %Outlier removal. Remove lines that are not similar to 80% of all other
    %lines.
%     outliers = abs(AvgDistance - D) > 2*Std;
%     while sum(outliers)
%         %delete outlier lines
%         for j = size(outliers,1):-1:1
%             vectorMatrix(:, j*2) = [];
%             vectorMatrix(:, j*2 - 1) = [];
%         end
%         
%         %recompute intersect with removed lines
%         [Point, AvgDistance, D, Std] = findIntersect(vectorMatrix);
%         %recompute outlier equation
%         outliers = abs(AvgDistance - D) > 2*Std;
%     end
end

function [Point, AvgDistance, D, Std] =  findIntersect(line_matrix)
    numOfPoints = size(line_matrix, 2);
    M = [];
    D = [];
    
    %Compute the intersects of every pair of lines
    for i = 1:2:numOfPoints
        if i ~= numOfPoints - 1
          for y = i+2:2:numOfPoints
            line1Point1 = line_matrix(:, i)';
            line1Point2 = line_matrix(:, i+1)';

            line2Point1 = line_matrix(:, y)';
            line2Point2 = line_matrix(:, y+1)';

            m = Intersect_Two_Lines(line1Point1,line1Point2,line2Point1,line2Point2);
            if isempty(m)
                disp('empty')
            end
            M = [M; m];
          end   
        end
    end
    
    
    % if there are only 2 lines the intersect is at M
    if size(M,1) == 1
        Point = M;
    else
        Point = mean(M); %else take the average of all the intersects
    end
    
    %compute the distance of each line to the new average intersect
    for i = 1:2:numOfPoints
        linePoint1 = line_matrix(:, i)';
        linePoint2 = line_matrix(:, i+1)';

        d = Distance_of_Line_and_Point(linePoint1, linePoint2, Point);
        D = [D; d];
    end
    
    %find the Std and Average distance to each line
    Std = std(D);
    AvgDistance = mean(D);
end
