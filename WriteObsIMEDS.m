%Read in NOAA data from  gauages
%IMEDS data is obtained from MetOceanViewer
%first run AssembleStationList.m
clear all; close all; clc;

%file format for .stations file: 'no. of stations'
% Number of stations
%'STATION NAME LON LAT'
%31
%NOAA_8418150 -70.246700 43.656700
%NOAA_8419317 -70.563300 43.320000

fid=fopen('noaa_sta.csv','r');
NoStations=textscan(fid,'%d');
NoStations=NoStations{1};
fprintf('Planning to process %d stations. To continue hit enter.\n',NoStations);
StationData=textscan(fid,'%s %f %f\n');
fclose(fid);

lon=StationData{2};
lat=StationData{3};

for i = 1 : NoStations
    %read in the file
    filename=strcat('Observation_',StationData{1}(i,:),'.imeds');
    fidFILE=fopen(filename{1},'r');
    %10-28-2012 10:00:00
    data=textscan(fidFILE,'%d %d %d %d %d %d %f','HeaderLines',4);
    fclose(fidFILE);
    fprintf('Processing %s\n',char(filename));
    %write to file in IMEDs format
    if i == 1
        fid=fopen('obs.IMEDS','w');%start a new file
        headerspec='%% IMEDS generic format-Water Level\n%% year month day hour min sec waterlev (m)\n ADCIRC UTC NAVD88\n %s  %f         %f\n';
    else
        fid=fopen('obs.IMEDS','a');%append to file
        headerspec='%s  %f         %f\n';
    end
    dataspec='   %d     %d     %d     %d    %d     %d       %f \n';
    %fprintf(fid,headerspec,char(StationData{1}(i,:)),lat(i),lon(i));
    str = ['STATION_',num2str(i)];
    fprintf(fid,headerspec,str,lat(i),lon(i));
    for ii = 1 : length(data{1})
        fprintf(fid,dataspec,data{1}(ii),data{2}(ii),data{3}(ii),data{4}(ii),data{5}(ii),data{6}(ii),data{7}(ii));
    end
    fprintf('Wrote IMEDS entries for %s\n',char(filename));
    fclose(fid);
end


