interp_x
interp_y
angular_orient
linear_pos
%lets recreate what the sub did

%first plot head position in space
plot3(linear_pos(:,1),linear_pos(:,1),linear_pos(:,1))

x = cos(yaw)cos(pitch)
y = sin(yaw)cos(pitch)
z = sin(pitch)