%convert t and fix
%input t and fix
%output fix / non-fix state at each t



function state_vec = convert_t_fix( t , fix )


count = 1;
state_vec = [];


for i = 1:length( t )
    
    if      t(i) < fix( count,1 )
        %before fixation
        state_vec = [ state_vec , 0 ];
        
        
    elseif  t(i) < fix( count,2 )
        %within fixation
        state_vec = [ state_vec , 1 ];
        
        
    else  
        %after fixation
        count = count +1;
        state_vec = [ state_vec , 0 ];
        
        if count > length(fix) 
            count = length( fix );
        end
    end

    
end


