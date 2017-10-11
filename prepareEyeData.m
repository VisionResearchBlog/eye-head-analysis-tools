%prepareEyeData

%first detect track losses

xeye=eye_data.BPORX_px_; 
%flip up/down
yeye=maxy-eye_data.BPORY_px_;

x1=xeye>maxx;
x2=xeye<minx;
x3=xeye==0;
x4=xeye==-1;
x5=isnan(xeye);

y1=yeye>maxy;
y2=yeye<miny;
y3=xeye==0;
y4=xeye==-1;
y5=isnan(yeye);

%we need to throw out questionable extremes
bad_X= x1 | x2 | x3 | x4 | x5;
bad_Y= y1 | y2 | y3 | y4 | y5;

bad_eye=bad_X | bad_Y;

xeye(bad_eye)=nan;
yeye(bad_eye)=nan;


interp_limit=3; %up to 100ms
%linear interpolate
for i=1:(length(xeye)-1)
    if( isnan(xeye(i)) )
        %find next entry without a zero
        for j=(i+1):length(xeye)
            if(j-i<=interp_limit)
                if( isnan(xeye(j)))
                    xeye(i)=(xeye(i)+xeye(j))/2;
                    break
                end
            end
        end
    end
    
    if( isnan(yeye(i)) )
        %find next entry without a zero
        for j=(i+1):length(yeye)
            if(j-i<=interp_limit)
                if( isnan(yeye(j)) )
                    yeye(i)=(yeye(i)+yeye(j))/2;
                    break
                end
            end
        end
    end
end

xeye=medfilt1(xeye,pos_medfilt_win_size,'omitnan');
yeye=medfilt1(yeye,pos_medfilt_win_size,'omitnan');



%adjust x,y too shift over for outside scene cam coordinates
xeye=xeye+xrng; yeye=yeye+yrng;


clear x1 x2 x3 x4 y1 y2 y3 y4 bad_X bad_Y  
