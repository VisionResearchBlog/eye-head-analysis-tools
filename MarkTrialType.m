function [condition,blockOrder] = MarkTrialType(TrialList)

% CondLabels={
% 	'Slow,Small,Eyes' 1
% 	'Fast,Small,Eyes' 2
% 	'Slow,Small,Hand' 3
% 	'Fast,Small,Hand' 4
% 	'Slow,Medium,Eyes' 5
% 	'Fast,Medium,Eyes' 6
% 	'Slow,Medium,Hand' 7 
% 	'Fast,Medium,Hand' 8
% 	'Slow,Large,Eyes' 9
% 	'Fast,Large,Eyes' 10
% 	'Slow,Large,Hand' 11
% 	'Fast,Large,Hand'}; 12
condition=zeros(length(TrialList),4);

for i=1:length(TrialList)
    str=TrialList(i);
    str_parts=strsplit(str{:},',');
    
    %str 2 - speed slow,fast
    %str 3 - small, medium, large
    s=str_parts{2};
    if(s(1)=='S') %slow
        condition(i,1)=0;
    else %fast
        condition(i,1)=1;
    end
    
    s=str_parts{3};
    if(s(1)=='S') %small
        condition(i,2)=0;
    elseif(s(1)=='M') %medium
        condition(i,2)=1;
    else %large
        condition(i,2)=2;
    end
    
    s=str_parts{4};
    if(s(1)=='E') %eyes
        condition(i,3)=0;
    elseif(s(1)=='H') %hands
        condition(i,3)=1;
	end
	
% 	try
% 		s=str_parts{5};
% 		condition(i,5)=str2num(s(1:2));
% 	catch ME
% 		disp('no 5th column')
% 	end
	
	
    %convert into a single digit numeric code
    if(      condition(i,1)==0 & condition(i,2)==0 & condition(i,3)==0)
        condition(i,4)=1;
    elseif(  condition(i,1)==1 & condition(i,2)==0 & condition(i,3)==0)
        condition(i,4)=2;
    elseif(  condition(i,1)==0 & condition(i,2)==0 & condition(i,3)==1)
        condition(i,4)=3;
    elseif(  condition(i,1)==1 & condition(i,2)==0 & condition(i,3)==1)
        condition(i,4)=4;
    elseif(  condition(i,1)==0 & condition(i,2)==1 & condition(i,3)==0)
        condition(i,4)=5;
    elseif(  condition(i,1)==1 & condition(i,2)==1 & condition(i,3)==0)
        condition(i,4)=6;
    elseif(  condition(i,1)==0 & condition(i,2)==1 & condition(i,3)==1)
        condition(i,4)=7;
    elseif(  condition(i,1)==1 & condition(i,2)==1 & condition(i,3)==1)
        condition(i,4)=8;
    elseif(  condition(i,1)==0 & condition(i,2)==2 & condition(i,3)==0)
        condition(i,4)=9;
    elseif(  condition(i,1)==1 & condition(i,2)==2 & condition(i,3)==0)
        condition(i,4)=10;
    elseif(  condition(i,1)==0 & condition(i,2)==2 & condition(i,3)==1)
        condition(i,4)=11;
    elseif(  condition(i,1)==1 & condition(i,2)==2 & condition(i,3)==1)
		condition(i,4)=12;
	end
	
	
end



%find order of conditions 12
tmp=condition(4,:);
blockOrder=tmp;
for i=2:length(condition)
    if(tmp(4)==condition(i,4))
        %do nothing same block
    else% block switch
        tmp=condition(i,:);
		blockOrder(end+1,:) =condition(i,:);
    end
end


return


