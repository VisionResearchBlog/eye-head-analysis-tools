[x, y]= ginput(3)

sys_lat = x(3)-x(1);
hmd_lat = x(3)-x(2);

a = pwd;
a(end)
filename(8)

excel = [str2double(a(end)) str2double(filename(8)) sys_lat hmd_lat x(1) x(2) x(3)]