% Hapgood_rotation_matrix_conventions

theta = pi / 4.0;

cosTheta = cos (theta);
sinTheta = sin (theta);

RotX = [ 1      0         0    ;
				 0   cosTheta  sinTheta;
				 0  -sinTheta  cosTheta];

RotY = [  cosTheta  0  sinTheta;
				     0      1     0     ;
				 -sinTheta  0  cosTheta];

RotZ = [  cosTheta  sinTheta  0;
				 -sinTheta  cosTheta  0;
				     0         0      1];

% Rotate (1,0,1) CW around Z => (0.70711, -0.70711, 1)
% This is equivalent to rotating the 2D vector (1,0) CW by pi/4 in the xy-plane.
% The result is a vector expressed in terms of a different coordinate system
% that is rotated CCW with respect to this system by pi/4 in the xy-plane.
RotZ * [ 1.0; 0.0; 1.0 ]
