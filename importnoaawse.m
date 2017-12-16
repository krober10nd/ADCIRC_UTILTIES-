%read ins in Noaa COOPS station csv and returns :
%       -Water level 
%       -time of measurement as datenum
%       -variance in avereaging period of obs. as given by NOAA
function [noaa_wse,time_data,noaa_sigma] = importnoaawse(filename)


try 
    data_import  = readtable(filename);
    data_import = table2cell(data_import);
catch
    data_import = [];
end
   

check = size(data_import);

if check(1) < 1
    time_data = [];
    noaa_wse = [];
    noaa_sigma = [];
    return
    
else

    %seperate wse
    noaa_wse = data_import(:,2);
    noaa_wse = cell2mat(noaa_wse);
    %seperate std
    noaa_sigma = data_import(:,3);
    noaa_sigma = cell2mat(noaa_sigma);
    %seperate times
    data_string = data_import(:,1);
    
    time_data = 0*noaa_wse;
    for jj = 1 :length(data_string)
        time_data(jj) = datenum(data_string{jj});
    end
    
    
end