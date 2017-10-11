function result = bjo( x , myu , sigma )


p = normpdf( x, myu, sigma );

if p == 0
    %this is the smalles double precision number
    %represented in matlab
    %this is used to avoid the result of -Inf
    %when calculating the log10( 0 )
    p = 1*10^-323;
end

result = p;
