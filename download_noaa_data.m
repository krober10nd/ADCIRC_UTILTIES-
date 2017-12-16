close all
clear all
close all


load noaastations.mat

date1 = '20161001';
date2 = '20161010';

%download waterleveldata
for i = 1:length(noaastations)
    
    url = ['https://tidesandcurrents.noaa.gov/api/datagetter?product=water_level&application=NOS.COOPS.TAC.WL&begin_date=' date1 '&end_date=' date2 '&datum=MSL&station=' num2str(noaastations{i,1}) '&time_zone=GMT&units=metric&format=csv'];
    filename = [num2str(noaastations{i,1}) '_',date1,'_',date2,'_wse.csv'];
    websave(filename,url)
    [noaa_wse,time_data,noaa_sigma] = importnoaawse(filename);
%     if ~isempty(noaa_wse)
%         %subplot(3,1,1)
%         figure,plot(datenum(time_data),noaa_wse)
%         datetick('x','dd-mmm-hh')
%         title(num2str(noaastations{i,1}))
%         pause; close all
%     end
%  
end

%download pressure

%  for i = 1:length(stations)
%
%  url = ['https://tidesandcurrents.noaa.gov/api/datagetter?product=air_pressure&application=NOS.COOPS.TAC.WL&begin_date=' date1 '&end_date=' date2 '&datum=MSL&station=' num2str(stations(i)) '&time_zone=GMT&units=metric&format=csv'];
%  filename = [num2str(stations(i)) '_20170901_20170930_press.csv'];
%  websave(filename,url)
%
%      [time_data,noaa_press] = importnoaapress(filename);
%      figure(i)
%      subplot(3,1,2)
%     plot(datenum(time_data),noaa_press)
%     datetick('x','dd-mmm-hh')
%     title(num2str(stations(i)))
%
%  end

%[1:4 6:length(stations)-1 ]

%download wind speed
%
%  for i = 1:length(stations)
%     url = ['https://tidesandcurrents.noaa.gov/api/datagetter?product=wind&application=NOS.COOPS.TAC.WL&begin_date=' date1 '&end_date=' date2 '&datum=MSL&station=' num2str(stations(i)) '&time_zone=GMT&units=metric&format=csv'];
%     filename = [num2str(stations(i)) '_20170901_20170930_met.csv'];
%     websave(filename,url)
%
%     [time_data,noaa_ws,noaa_dir] = importnoaaws(filename);
%     figure(i)
%     subplot(3,1,3)
%     plot(datenum(time_data),noaa_ws)
%     datetick('x','dd-mmm-hh')
%     title(num2str(stations(i)))
%
%  end

