% process latency files
function h = lat_test(filename)

close all;

volts = load(filename);
v = volts(:,2);
photo1 = smooth(volts(:,3),2);
photo2 = smooth(volts(:,3),10);



t = volts(:,1);

%make moving average since data is noisy
%scope samples 25smps/ms
i = 1;
ave_v=[];

while(i<size(volts,1))
  
    ave_v(end+1,1) = mean(v(i:i+24));
    ave_v(end,2) = t(i+24,1);
    i = i+25;   
end
        
vel = (ave_v(2:end,1)-ave_v(1:end-1,1))/0.001;
vel = abs(vel)*5;
tmp_vel = smooth(vel,1);   
 
%plot(t*100, v,'k'); hold on;
%plot(t, photo1*30000, 'b'); hold on;
plotyy(t*1000, v, t*1000, photo1) 
%plot(t, photo2*30000, 'k'); hold on;
%plot(ave_v(2:end, 2), ave_v(2:end, 1)*100,'m'); hold on;
%plot(ave_v(2:end, 2), vel,'r'); hold on;
%plot(ave_v(2:end, 2), tmp_vel,'g'); hold on;
%ylim([0 300])
%set(gca,'XGrid','on')
plotedit

keyboard

return
