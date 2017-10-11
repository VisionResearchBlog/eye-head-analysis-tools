function tc=min2tc(min)
% function TC=float2TC(float)
%
% Converts floating point time to [HH,MM,SS,FF] format.
%
% pilardi 8/02

h=floor(min/3600);
m=floor(mod(min,3600)/60);
s=floor(mod(min,60));
f=floor((min-floor(min))*30);

for i = 1:size(h,1)
    hr = '%d:'; min = '%d:'; sec = '%d:'; frm = '%d';
    if(h(i)<10)
        hr = '0%d:';
    end
    if(m(i)<10)
        min = '0%d:';
    end
    if(s(i)<10)
        sec = '0%d:';
    end
    if(f(i)<10)
        frm = '0%d';
    end



    str = [hr min sec frm];

    tc{i,:} = sprintf(str, h(i),m(i),s(i),f(i));
    %tc=[h m s f]
end