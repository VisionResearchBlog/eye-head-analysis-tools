nan_idx=~isnan(dat.Gaze3DPositionLeftX);
g3d_L_xyz=[dat.Gaze3DPositionLeftX(nan_idx) dat.Gaze3DPositionLeftY(nan_idx) ...
    dat.Gaze3DPositionLeftZ(nan_idx)];

nan_idx=~isnan(dat.Gaze3DPositionRightX);
g3d_R_xyz=[dat.Gaze3DPositionRightX(nan_idx) dat.Gaze3DPositionRightY(nan_idx) ...
    dat.Gaze3DPositionRightZ(nan_idx)];

%nan_idx=~isnan(dat.Gaze3DPositionCombinedX);
%g3d_COMBO_xyz=[dat.Gaze3DPositionCombinedX(nan_idx) dat.Gaze3DPositionCombinedY(nan_idx) dat.Gaze3DPositionCombinedZ(nan_idx)];

nan_idx=~isnan(dat.GazeDirectionLeftY);
gd_L_xyz=[dat.GazeDirectionLeftX(nan_idx) dat.GazeDirectionLeftY(nan_idx) ...
    dat.GazeDirectionLeftZ(nan_idx)];

nan_idx=~isnan(dat.GazeDirectionRightY);
gd_R_xyz=[dat.GazeDirectionRightX(nan_idx) dat.GazeDirectionRightY(nan_idx) ...
    dat.GazeDirectionRightZ(nan_idx)];

figure(10); clf;

subplot(1,2,1)
quiver3( zeros(size(g3d_L_xyz,1),1), ...
    zeros(size(g3d_L_xyz,1),1),...
    zeros(size(g3d_L_xyz,1),1),...
    g3d_L_xyz(:,1), ...
    g3d_L_xyz(:,2), ...
    g3d_L_xyz(:,3),0 )

hold on

quiver3( zeros(size(g3d_R_xyz,1),1), ...
    zeros(size(g3d_R_xyz,1),1),...
    zeros(size(g3d_R_xyz,1),1),...
    g3d_R_xyz(:,1), ...
    g3d_R_xyz(:,2), ...
    g3d_R_xyz(:,3),0,'r' )



%plot3([0 g3d_COMBO_xyz(i,1)], [0 g3d_COMBO_xyz(i,2)],[0 g3d_COMBO_xyz(i,3)],'b')
grid on
xlim([-500 500]); xlabel('x')
ylim([-500 500]); ylabel('y')
zlim([-500 500]); zlabel('z')

subplot(1,2,2)
quiver3( zeros(size(gd_L_xyz,1),1), ...
    zeros(size(gd_L_xyz,1),1),...
    zeros(size(gd_L_xyz,1),1),...
    gd_L_xyz(:,1), ...
    gd_L_xyz(:,2), ...
    gd_L_xyz(:,3),0 )

hold on

quiver3( zeros(size(gd_R_xyz,1),1), ...
    zeros(size(gd_R_xyz,1),1),...
    zeros(size(gd_R_xyz,1),1),...
    gd_R_xyz(:,1), ...
    gd_R_xyz(:,2), ...
    gd_R_xyz(:,3),0,'r' )

grid on
xlim([-1 1]); xlabel('x')
ylim([-1 1]); ylabel('y')
zlim([-1 1]); zlabel('z')