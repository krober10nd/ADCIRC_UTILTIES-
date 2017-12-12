clear all; close all; clc;
% Assumes you got the NOAA stations from download_noaa_data.m. You must
% have a file like noaastations.mat which contains the name, lon, lat of
% the station.
load noaastations.mat
NoStations = length(noaastations);
date1 = '20161001';
date2 = '20161010';
NoExistSta = 0; %<--some
for i = 1 : NoStations
    %read in the file
    filename=[num2str(noaastations{i,1}),'_',date1,'_',date2,'_wse.csv'];
    if exist(filename,'file')~=2
        continue
    end
    % retain a list of data that does exist!
    NoExistSta = NoExistSta + 1;
    NOAAStaExist{NoExistSta,1} = noaastations{i,1};
    NOAAStaExist{NoExistSta,2} = noaastations{i,2};
    NOAAStaExist{NoExistSta,3} = noaastations{i,3};
    data=readtable(filename);
    
    fprintf('Processing %s\n',char(filename));
    %write to file in IMEDs format
    if NoExistSta==1
        fid=fopen('obs.IMEDS','w');%start a new file
        headerspec='%% IMEDS generic format-Water Level\n%% year month day hour min sec waterlev (m)\n ADCIRC UTC NAVD88\n %s  %f         %f\n';
    else
        fid=fopen('obs.IMEDS','a');%append to file
        headerspec='%s  %f         %f\n';
    end
    dataspec='   %d     %d     %d     %d    %d     %d       %f \n';
    fprintf(fid,headerspec,['STATION_',num2str(NoExistSta)],noaastations{i,2},noaastations{i,3});
    for ii = 1 : length(data.WaterLevel)
        fprintf(fid,dataspec,...
            str2num(datestr(data.DateTime(ii),'yyyy')),...
            str2num(datestr(data.DateTime(ii),'mm')),...
            str2num(datestr(data.DateTime(ii),'dd')),...
            str2num(datestr(data.DateTime(ii),'HH')),...
            str2num(datestr(data.DateTime(ii),'MM')),...
            str2num(datestr(data.DateTime(ii),'ss')),...
            data.WaterLevel(ii)... % <--has to be in meters!
            );
    end
    fprintf('Wrote IMEDS entries for %s\n',char(filename));
    fclose(fid);
end

% write out file for interp6364
fid = fopen('noaa.stations.forinterp6364','w');
fprintf(fid,'%d\n',NoExistSta);
for i = 1 : NoExistSta
   fprintf(fid,'%f %f\n',NOAAStaExist{i,3},NOAAStaExist{i,2}); 
end
fclose(fid);

% The station list for sync'ing up 
fid = fopen('ListForSync.txt','w');
fprintf(fid,'%d',NoExistSta);
for i = 1 : NoExistSta
    fprintf(fid,'%s\n',['STATION_',num2str(i)]);
end
fclose(fid);