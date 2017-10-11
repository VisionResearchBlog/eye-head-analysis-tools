function [angleX, angleY] = smi2angle(smiX, smiY)

% converts asl pixels to angles
%the nvis is a 1280x1024 display with 60deg diagonal FOV (800pix diag)
vidResX=1280; vidResY=960;

%pix2deg_X=58.6/vidResX; %60deg from SMI, my measure was 58.6
%pix2deg_Y=37.9/vidResY; %46deg from SMI, my measure was 37.9
pix2deg_X=60/vidResX; %60deg from SMI, my measure was 58.6
pix2deg_Y=40/vidResY; %46deg from SMI, my measure was 37.9


%convert pix to angles
angleX= smiX*pix2deg_X;
angleY= smiY*pix2deg_Y;

return
