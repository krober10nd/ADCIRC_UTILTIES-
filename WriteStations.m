clear all; close all; clc;
noStat = 193;
fid = fopen('ListForSync.txt','w'); 
fprintf(fid,'%s\n',num2str(noStat));
for i = 1 : noStat
s = ['STATION_',num2str(i)];
fprintf(fid,'%s\n',s);
end
fclose(fid);
