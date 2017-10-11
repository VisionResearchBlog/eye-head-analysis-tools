%FILTER_AVERAGE  filter
%   B = FILTER_AVERAGE(A, RADIUS)  
%   filter with radius (NOT diameter) of RADIUS. result put in
%   B. inefficient implementation. uses zero to pad the ends when
%   necessary during filtering.

% $Id: filter_average.m,v 0.9 2002/06/04 
% rothkopf

function b = filter_average( vector , size )





kernel      = ones( size,1 )./size;
convolution = conv( vector , kernel );




if mod( size , 2 ) == 0
    %even kernel size 
    b = convolution( 1+(size/2) : (size/2)+length( vector ) );
    
else
    %odd kernel size
    b = convolution( 1+((size-1)/2) : ((size-1)/2)+length( vector ) );
    
end

