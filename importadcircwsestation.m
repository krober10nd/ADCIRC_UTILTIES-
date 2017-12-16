function [time,wse_sta,x,y] = importadcircwsestation(ncfile,stanum) 

        %read netcdf station wse file
        base = ncreadatt(ncfile,'time','base_date');
        base = datenum(base,'yyyy-mm-dd HH:MM:SS');
        time = ncread(ncfile,'time');
        time = time/60/60/24 + base;
        time = datestr(time);
        
        %read all wse
        wse_all = ncread(ncfile,'zeta');
        wse_sta = wse_all(stanum,:);
        
        %read x,y location of station
        x_all = ncread(ncfile,'x');
        y_all = ncread(ncfile,'y');
        x = x_all(stanum);
        y = y_all(stanum);
end