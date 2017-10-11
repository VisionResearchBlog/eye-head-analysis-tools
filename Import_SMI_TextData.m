%imports 
%32 columns see pg 320 begaze pdf to get more info

          % 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
format = ['%f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %s ' ...
'%f %f %f %f %f %f %f %f %f %f %f %f %f %s %s %s %s'];
%17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33

a=fopen([ddir smitext_fn]);
b=textscan(a,format);
keyboard
Time=b{1}; Time=Time(t);	%in ms
Type=b{2};	Type=Type(t);
Trial=b{3};	Trial=Trial(t);
L_Dia_X_px=b{4}; L_Dia_X_px=L_Dia_X_px(t); %horiz. diameter of Left pupil	in pixels
L_Dia_Y_px=b{5}; L_Dia_Y_px=L_Dia_Y_px(t); %vert. diameter of Left pupil in pixels
L_Mapped_Diameter_mm=b{6}; L_Mapped_Diameter_mm=L_Mapped_Diameter_mm(t); %total L pupul diam. in mm	
R_Dia_X_px=b{7}; R_Dia_X_px=R_Dia_X_px(t);	% same as above but for R eye
R_Dia_Y_px=b{8}; R_Dia_Y_px=R_Dia_Y_px(t);	
R_Mapped_Diameter_mm=b{9};	R_Mapped_Diameter_mm=R_Mapped_Diameter_mm(t);
B_POR_X_px=b{10}; B_POR_X_px=B_POR_X_px(t);	%binocular point of regard X in pixels
B_POR_Y_px=b{11}; B_POR_Y_px=B_POR_Y_px(t);	%binocular point of regard Y in pixels
L_POR_X_px=b{12}; L_POR_X_px=L_POR_X_px(t);	% same as above but for L eye
L_POR_Y_px=b{13}; L_POR_Y_px=L_POR_Y_px(t);	
R_POR_X_px=b{14}; R_POR_X_px=R_POR_X_px(t);	% same as above but for R eye
R_POR_Y_px=b{15}; R_POR_Y_px=R_POR_Y_px(t);	
B_Object_Hit=b{16}; B_Object_Hit=B_Object_Hit(t);%Area of Interest being 'hit' by gaze
L_EPOS_X=b{17};	L_EPOS_X=L_EPOS_X(t); %L eye position X in ?
L_EPOS_Y=b{18};	L_EPOS_Y=L_EPOS_Y(t); %L eye position Y in ?
L_EPOS_Z=b{19};	L_EPOS_Z=L_EPOS_Z(t); %L eye position Z in ?
R_EPOS_X=b{20};	R_EPOS_X=R_EPOS_X(t); %same as above but for R eye
R_EPOS_Y=b{21};	R_EPOS_Y=R_EPOS_Y(t);
R_EPOS_Z=b{22};	R_EPOS_Z=R_EPOS_Z(t);
L_GVEC_X=b{23};	L_GVEC_X=L_GVEC_X(t); %L gaze vector X in ?
L_GVEC_Y=b{24};	L_GVEC_Y=L_GVEC_Y(t); %L gaze vector Y in ?
L_GVEC_Z=b{25};	L_GVEC_Z=L_GVEC_Z(t); %L gaze vector Z in ?
R_GVEC_X=b{26};	R_GVEC_X=R_GVEC_X(t); % same as above but for R eye
R_GVEC_Y=b{27};	R_GVEC_Y=R_GVEC_Y(t); 
R_GVEC_Z=b{28};	R_GVEC_Z=R_GVEC_Z(t); 
Trigger=b{29}; Trigger(t); %external trigger mark
Frame=b{30}; Frame=Frame(t); %video frame associated with data frame
B_Event_Info=b{31};	B_Event_Info=B_Event_Info(t); %??
Aux1=b{32}; Aux1=Aux1(t); %auto event detect (fix,blink,saccade)	
Stimulus=b{33}; Stimulus(t); %name of associated avi video

return



