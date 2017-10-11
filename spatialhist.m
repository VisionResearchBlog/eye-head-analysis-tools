function [matrixthingRAW,matrixthingPERC] = ...
    spatialhist(GazePointX,GazePointY,maxVidResX,maxVidResY,...
    pix2deg_X,pix2deg_Y)
%bin things per visual degree (20 pixels bins about)
matrixthing=zeros(round(maxVidResY*pix2deg_Y),...
    round(maxVidResX*pix2deg_X));

for w=1:length(GazePointX)
    
    x_r(w)=round(GazePointX(w)*pix2deg_X);
    y_r(w)=round(GazePointY(w)*pix2deg_Y);
    
    if( x_r(w)>0 & y_r(w)>0 & x_r(w)<=maxVidResX & y_r(w)<=maxVidResY)
        matrixthing(y_r(w), x_r(w)) = ...
            matrixthing(y_r(w), x_r(w))+1;
    end
end

%eye tracker origin is bottom left, imagesc uses top left
matrixthing=flipud(matrixthing);

matrixthingRAW=matrixthing;
matrixthingPERC=matrixthing./sum(sum(matrixthing));

return
