%FILTER_ADAPTIVE_SMOOTH  filter
%   B = FILTER__ADAPTIVE_SMOOTH(A, RADIUS)
%   looking at the eye in head velocities
%   there seems to be signal dependent noise from
%   the eye tracker -> nonlinear mean filtering
%   have to decide on the dynamic range: 90deg/sec
%   nonlinear mean filter, see
%   Mitra, Sicuranza 'Nonlinear Image Processing'
% $Id: filter_adaptive_smooth.
% rothkopf 10June2002

function b = filter_adaptive_smooth(a, radius)

n           = length(a); 
b           = [];   
win_radius  = radius;

%pad with zeros
a_tmp = [zeros(win_radius, 1)+a(1,1)  ; a(:) ;  zeros(win_radius, 1)+a(n,1)];

for i=1+win_radius:n+win_radius
    
    temp     = a_tmp( i-win_radius : i+win_radius,1 );
    feature  = mean( temp(:) );
    
    if feature > 0.09       %limit defined by 'dynamic range'
        feature = 0.09;  
    end

    faktor_b = feature/0.09;%limit defined by 'dynamic range'
    faktor_a = 1.0-faktor_b;
    
    temp1    = faktor_a*a_tmp( i,1 ) + faktor_b*a_tmp( i-radius,1 );
    temp2    = a_tmp( i );
    temp3    = faktor_a*a_tmp( i,1 ) + faktor_b*a_tmp( i+radius,1 );
    
    value    = mean([ temp1 ; temp2 ; temp3 ]);
    v(i)     = value;
end

b = v( 1+win_radius:n+win_radius );
b = b';
