function [fmark, dat] = fixdetect(datx,daty,dattime)

dat.x = datx;
dat.y = daty;
dat.time = dattime/1000;

%%%%% eye tracker defaults
%gv.tracker          = gv.datatype;
 

%gv.camres       = gv.wcr;   % resolution of eye camera
%gv.trackres     = gv.ecr;    % resolution of scene camera

 
f                   = initeventdetect('test') %gv.tracker);
 
%%%%% Make sure there are NaNs where there is data loss (pupillabs uses zero) 
% assuming there is an x, y and time signal
% for example dat.x, dat.y, dat.time
 
%%%%% determine velocity
vx                  = detvel(dat.x,dat.time);
vy                  = detvel(dat.y,dat.time);
dat.v               = pythagoras(vx,vy);

%%%%% detect fixations
fmark               = detectfixaties2015(dat.v,f,dat.time);

