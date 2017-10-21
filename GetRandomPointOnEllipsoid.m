% Author: Eseoghene Okonofua <EseO@Eseoghenes-MacBook-Pro.local>
% Created: 2017-09-25

%Helper function get random point on a sphere surface with given centre and radius
function coordinates = GetRandomPointOnEllipsoid(centre, a, b ,c, hemisphere)
  % default
  theta = 2*pi*rand;
  phi = acos(2*rand - 1); 

  if strcmp(hemisphere, 'north')
    phi = acos(rand);
  elseif strcmp(hemisphere, 'south')
    phi = acos(rand - 1);
  end
  
  x = centre(1) + ( a * sin(phi) * cos(theta) );
  y = centre(2) + ( b * sin(phi) * sin(theta) );
  z = centre(3) + ( c * cos(phi) );
     
  coordinates = [x,y,z];
end
