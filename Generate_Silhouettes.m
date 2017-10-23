function [alphaVector, silhouettes] = Generate_Silhouettes(points, min, max, interval)
%GENERATE_SILHOUETTES Generates silhouettes and angle vector
    silhouettes = {};
    alphaVector = [];
    
    if interval == 0
        alphaVector = [0];
        contour = Tumor_Projector(0, points);
        silhouettes{1} = contour;
    else
        sCount = 1;
        for i = min:15:max
            if mod(i, interval) == 0
                alphaVector = [alphaVector; i];
                contour = Tumor_Projector(i, points);
                silhouettes{sCount} = contour;
                sCount = sCount + 1;
            end
        end
    end
end

