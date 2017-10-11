% COMPUTE_FIX_CHMM_211
%       fixation finder that uses 2 state 
%       Hidden Markov model with single Gaussian distribution 
%       FIX = COMPUTE_FIX_HMM(T, VEL, VEL_THRESH, T_THRESH , A, myu, sigma) returns the
%       fixations associated with (T, VEL) in FIX
%
%   T is time vector, VEL is velocity vector
%
% Constantin Rothkopf 20 June 2002
%
% CASE 1:   2 states    1 Gaussian      1 input ( eih velocity )


function [fix, fix_frames] = compute_fix_chmm_211(t_vec, vel , vel_thresh, t_thresh , A , myu , sigma ) 


T = length( t_vec );

%construct A matrix
%         fix->fix    sac->fix    fix->sac
%A =    [ 0.97      , 0.10      ; 0.03      , 0.90];
%A =     [ 0.9688    , 0.3332    ; 0.0312    , 0.6668];
%A =     [ 0.9853    , 0.2054    ; 0.0147    , 0.7946 ];%DK
%A =     [ 0.9888    , 0.2031    ; 0.0112    , 0.7969 ];%SA
%A =     [ 0.9570    , 0.2045    ; 0.0430    , 0.7955 ];%SA



%construct B matrix
%x = 0:299;
%column1 = normpdf( x , myu(1,1) , sigma(1,1) );
%column2 = normpdf( x , myu(2,1) , sigma(2,1)  );

%column1 = normpdf( x , 30.5094 , 13.4444 );
%column2 = normpdf( x , 120.199 , 57.9085  );


%figure,plot(x,column1,x,column2)

%B = [ column1 ; column2 ]';

%A = A';%this was coded before the reestimation. along the way the notation changed...


A = log10( A );
%B = log10( B );
%initialize variables
delta           = zeros( T , 2 );

delta( 1 , 1 )  = log10( 0.5 ) + log10(  bjo( vel(1,1) , myu(1,1) , sigma(1,1) )  );%B( 1+vel(1,1) , 1 );
delta( 1 , 2 )  = log10( 0.5 ) + log10(  bjo( vel(1,1) , myu(2,1) , sigma(2,1) )  );%B( 1+vel(1,1) , 2 );
%delta( 1 , 1 )  = log10( 0.5 ) + B( 1+vel(1,1) , 1 );
%delta( 1 , 2 )  = log10( 0.5 ) + B( 1+vel(1,1) , 2 );


phi             = zeros( T , 2 );
states          = zeros( T , 1 );

%forward
for t=2:T
    
    v = vel( t,1 );
    
    %[m , i]         = max( [B(v,1) + A(1,1) + delta(t-1,1)  ,  B(v,1) + A(1,2) + delta(t-1,2)]  );
    %[m , i]         = max( [log10(bjo(vel(t,1) , myu(1,1) , sigma(1,1))) + A(1,1) + delta(t-1,1)  ,  log10(bjo(vel(t,1) , myu(1,1) , sigma(1,1))) + A(1,2) + delta(t-1,2)]  );%old notation
    [m , i]         = max( [log10(bjo(vel(t,1) , myu(1,1) , sigma(1,1))) + A(1,1) + delta(t-1,1)  ,  log10(bjo(vel(t,1) , myu(1,1) , sigma(1,1))) + A(2,1) + delta(t-1,2)]  );
    delta( t,1 )    = m;
    phi( t,1 )      = i;
   
    
    %[m , i]         = max( [B(v,2) + A(2,1) + delta(t-1,1)  ,  B(v,2) + A(2,2) + delta(t-1,2)]  );
    %[m , i]         = max( [log10(bjo(vel(t,1) , myu(2,1) , sigma(2,1))) + A(2,1) + delta(t-1,1)  ,  log10(bjo(vel(t,1) , myu(2,1) , sigma(2,1))) + A(2,2) + delta(t-1,2)]  );%old notation
    [m , i]         = max( [log10(bjo(vel(t,1) , myu(2,1) , sigma(2,1))) + A(1,2) + delta(t-1,1)  ,  log10(bjo(vel(t,1) , myu(2,1) , sigma(2,1))) + A(2,2) + delta(t-1,2)]  );
    delta( t,2 )    = m;
    phi( t,2 )      = i;
    
end


%backward
for t=T:-1:1
    
    [m , i]         = max( [ delta( t,1 ) , delta( t,2 ) ] );
    
    states( t,1 )     = i;
    
    
end

%states
% figure,plot(states)
% length(states)

vel_thresh = 1.5;
vel = states;



fix = []; idx = 1;  
n = length(vel);

t_start = -1;

for i=1:n
    v = vel(i);
    t_ = t_vec(i);
    
    if(v < vel_thresh) %begin new fixations
       if(t_start == -1) %start fixation
          t_start = t_;  
	  frame_i = i;
       end        
    else %end old fixations
       if(t_start ~= -1) %end fixation
          %fix = [fix; t_start t_];  
          if(t_ - t_start > t_thresh)  
	      frame_f = i;
              fix(idx, :) = [t_start t_]; 
	      fix_frames(idx, :) = [frame_i frame_f];
	          idx = idx + 1;
          end             
          t_start = -1; 
       end
    end
end
