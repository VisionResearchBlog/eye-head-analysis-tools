%
% CBA_BROWSEHANDMOVEMENT - plot hand movements in one data file
%
% CBA_BROWSEHANDMOVEMENT(dataFile)
%
%   dataFile - name of data file in .data format
%

function A = cba_browseHandMovementstz(filename)

% get time, height, and z-pos data in arrays

% T = cba_load_data(filename, 'time');
% H = cba_load_data(filename, 'size');
% X = cba_load_data(filename, 'pos_x');
% Z = cba_load_data(filename, 'pos_z')+10; % correct for diff
                                           % haptic/vis. size

A = cba_load_data(filename, 'all');
T = A{2};
H = A{22};
X = A{19};
Z = A{21}+10;

size = size(T,1);
y_max = 150;

% compute binary size change signal
C = zeros(size,1);
for i=1:size-1
  if ( H(i)~=0 & H(i+1)~=0 & abs(X(i))<20 & H(i)~=H(i+1) )
    C(i) = y_max;
  end
end

% make t,z plots
width = 1000;

for start=1:0.9*width:size
  stop = min([start+width-1 size]); 
  t = T(start:stop);
  z = Z(start:stop);
  c = C(start:stop);
  plot(t, z);
  hold on;
  plot(t, c, 'r');
  set(gca,'FontSize',16)
  title('example hand trajectory');
  xlabel('time in seconds');
  ylabel('z of touched brick (mm)');
  hold off;
  
  pause;
end
