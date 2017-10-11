%
% CBA_BROWSEHANDMOVEMENT - plot hand movements in one data file
%
% CBA_BROWSEHANDMOVEMENT(dataFile)
%
%   dataFile - name of data file in .data format
%

function A = cba_browseHandMovementsxz(filename)

% get time, height, and z-pos data in arrays

% T = cba_load_data(filename, 'time');
% H = cba_load_data(filename, 'size');
% X = cba_load_data(filename, 'pos_x');
% Z = cba_load_data(filename, 'pos_z');

A = cba_load_data(filename, 'all');
T = A{2};
H = A{22};
X = A{19};
Z = A{21};

size = size(T,1);
y_max = 150;

% compute binary size change signal
C = zeros(size,1);
for i=1:size-1
  if ( H(i)~=0 & H(i+1)~=0 & abs(X(i))<20 & H(i)~=H(i+1) )
    C(i) = y_max;
  end
end


% make x,z plots

start = 1;
while start<size
  if H(start)==0
    start = start+1;
    continue;
  else
    % get stop
    for stop=start:size-1
      if H(stop+1)==0
	break;
      end
    end
    
    % check if touching lasts less than one second or if movement not
    % from left to right
    if ( (T(stop)-T(start)<1) | ( X(start) > -50) | (X(stop) < 50) )
      start=stop+1;
      continue;
    end
    
    % plot
    x = X(start:stop);
    z = Z(start:stop);
    c = C(start:stop);
    hold off;

    plot(x,z);
    hold on;
    
    % plot touching-table-baselin
    plot([-200 200], [Z(start) Z(start)], 'k:');
    
    % plot every second frame in red
    for s=start:2:stop-1
     xr = ([X(s) X(s+1)]);
     zr = ([Z(s) Z(s+1)]);
     plot(xr, zr, 'r');
    end
    
    plot(x,c, 'r');

    axis([-200 200 0 150]);
    title( sprintf('%s: movement starting at t=%g seconds', filename, T(start)));
    xlabel('x of touched brick (mm)');
    ylabel('z of touched brick (mm)');
    hold off
    pause
    start=stop+1;
  end
end

