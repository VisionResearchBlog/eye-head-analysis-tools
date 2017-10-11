%function [ A , B ] = fix_finder_chmm_reestimate( observation_seq )

%reestimates parameters of HMM

%MODEL:
%   2 state HMM:   fixations / non-fixations
%   1 continuous, single gaussian distribution for each state
%   1 input value, the 'eih' eye velocity

%OUTPUT:
%   A is the 2 x 2 transition matrix
%   myu is a column vector containing the mean values of the two gaussian distributions 
%   sigma is a column vector containing the variance values of the two gaussian distributions

%REQUIRES:
%   bjo.m which calculates the probabilities of the observed velocity given a gaussian distribution
%
% Constantin Rothkopf 20 June 2002

function [ A , myu , sigma ] = fix_finder_chmm_211_reestimate( observation_seq )



%construct A matrix
A = [ 0.9       0.1    ;    0.2         0.8 ];

%cba std dev values for 'fixation' and 'non fixation' states    no filter

myu         = [ 32      ;       496  ];%cba mean values for 'fixation' and 'non fixation' states       1 1 filter
sigma       = [ 16      ;       786  ]

T           = length( observation_seq );
states      = 2;
vel         = observation_seq;

steps       = 0;
max_steps   = 20;
error       = 100;
min_error   = 0.001;

%try estimation steps
while((steps < max_steps)&(error > min_error))

    %initialize variables
    O                   = vel;
    
    alpha               = zeros( T , 2 );
    beta                = zeros( T , 2 );
    gamma               = zeros( 1 , 2 );

    Xi_t                = zeros( 2,2 );
    Sum_Xi_t            = zeros( 2,2 );
    gamma_t             = zeros( 2,1 );
    Sum_gamma_t         = zeros( 2,1 );
    
    Sum_gamma_j_t       = zeros( 2,1 );
    Sum_gamma_o_sigma_t = zeros( 2,1 );
    Sum_gamma_o_myu_t   = zeros( 2,1 );

    %precalculate alphas
    alpha( 1,1 )    = 0.5 * bjo( O(1,1) , myu(1,1) , sigma(1,1)  );%B( 1,O( 1,1 ) );
    alpha( 1,2 )    = 0.5 * bjo( O(1,1) , myu(2,1) , sigma(2,1)  );%B( 2,O( 1,1 ) );
    
    scale( 1,1 )    = 1.0 / sum( alpha( 1 , : ) );%scaling
    alpha( 1,1 )    = alpha( 1,1 ) * scale( 1,1 );
    alpha( 1,2 )    = alpha( 1,2 ) * scale( 1,1 );
    
    for t=2:T
        for i=1:2
            alpha( t , 1 ) = alpha( t , 1 ) + (   alpha( t-1 , i ) * A( i , 1 )   );
            alpha( t , 2 ) = alpha( t , 2 ) + (   alpha( t-1 , i ) * A( i , 2 )   );
        end
        alpha( t , 1 ) = alpha( t , 1 ) * bjo( O(t,1) , myu(1,1) , sigma(1,1)  );%B( 1,O( t,1 ) );
        alpha( t , 2 ) = alpha( t , 2 ) * bjo( O(t,1) , myu(2,1) , sigma(2,1)  );%B( 2,O( t,1 ) );
        
        scale( t , 1 ) = 1.0 / sum( alpha( t , : ) );%scaling
        alpha( t , 1 ) = alpha( t , 1 ) * scale( t,1 );
        alpha( t , 2 ) = alpha( t , 2 ) * scale( t,1 );
    end
    %alpha;

    %precalculate betas
    beta( T,1 )    = 1 * scale( T,1 );
    beta( T,2 )    = 1 * scale( T,1 );
    for t=T-1:-1:1
        for j=1:2
            beta( t , 1 ) = beta( t , 1 ) + (   A( 1,j ) * bjo( O(t+1,1) , myu(j,1) , sigma(j,1) ) * beta( t+1 , j )   );%B( j,O( t+1,1) )
            beta( t , 2 ) = beta( t , 2 ) + (   A( 2,j ) * bjo( O(t+1,1) , myu(j,1) , sigma(j,1) ) * beta( t+1 , j )   );%B( j,O( t+1,1) )
        end
            beta( t , 1 ) = beta( t , 1 ) * scale( t,1 );%scaling
            beta( t , 2 ) = beta( t , 2 ) * scale( t,1 );
    end
    %beta;
    
    %go through entire sequence
    for t=1:T-1
        
        for i=1:2
            for j=1:2     
                Xi_t( i,j )     = alpha( t,i ) * A( i,j ) * bjo( O(t+1), myu(j,1) , sigma(j,1) ) * beta( t+1,j );%B( j,O(t+1) )
            end
        end        
        Polambda        = sum( Xi_t(:) );
        Xi_t            = Xi_t./Polambda;
        Sum_Xi_t        = Sum_Xi_t + Xi_t;
        
        gamma_t         = zeros( 2,1 );
        for i=1:2
            for j=1:2     
                gamma_t( i )     = gamma_t( i ) + Xi_t( i,j );
            end
        end
        
        %estimate myu and sigma
        Sum_gamma_j_t( 1,1 )         = Sum_gamma_j_t( 1,1 ) + gamma_t( 1,1 );
        Sum_gamma_j_t( 2,1 )         = Sum_gamma_j_t( 2,1 ) + gamma_t( 2,1 );
        
        Sum_gamma_o_sigma_t( 1,1 )   = Sum_gamma_o_sigma_t( 1,1 ) + (   gamma_t( 1,1 ) * (  O( t,1 ) - myu( 1,1 )  )^2   );
        Sum_gamma_o_sigma_t( 2,1 )   = Sum_gamma_o_sigma_t( 2,1 ) + (   gamma_t( 2,1 ) * (  O( t,1 ) - myu( 2,1 )  )^2   );
        
        Sum_gamma_o_myu_t( 1,1 )     = Sum_gamma_o_myu_t( 1,1 ) + gamma_t( 1,1 ) * O( t,1 );
        Sum_gamma_o_myu_t( 2,1 )     = Sum_gamma_o_myu_t( 2,1 ) + gamma_t( 2,1 ) * O( t,1 );
        
        
        Sum_gamma_t         = Sum_gamma_t + gamma_t; 
    end %t
    
    
    %construct A & B estimates
    for i=1:2
        for j=1:2     
            Abar( i,j )     = Sum_Xi_t( i,j ) / Sum_gamma_t( i,1 );
        end
    end

    %replace with new estimates
    A = Abar;
    
    myu11           = Sum_gamma_o_myu_t( 1,1 ) / Sum_gamma_j_t( 1,1 );
    myu21           = Sum_gamma_o_myu_t( 2,1 ) / Sum_gamma_j_t( 2,1 );
    
    error           = max( abs( myu( 1,1 )-myu11 ) , abs( myu( 2,1 )-myu21 ) )
    
    myu( 1,1 )      = myu11;
    myu( 2,1 )      = myu21;
    
    sigma( 1,1 )    = sqrt(   Sum_gamma_o_sigma_t( 1,1 ) / Sum_gamma_j_t( 1,1 )   );
    sigma( 2,1 )    = sqrt(   Sum_gamma_o_sigma_t( 2,1 ) / Sum_gamma_j_t( 2,1 )   );

    steps = steps + 1
end %while




