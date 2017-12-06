clearvars; close all; clc;

demnames   = {'ncei19_n40x75_w074x25_2015v1.nc'
    'ncei19_n41x00_w073x50_2015v1.nc'
    'ncei19_n41x00_w073x75_2015v1.nc'
    'ncei19_n41x00_w074x00_2015v1.nc'
    'ncei19_n41x25_w073x75_2015v1.nc'
    'ncei19_n41x00_w074x00_2015v1.nc'
    'ncei19_n41x25_w073x75_2015v1.nc'
    };


xname = 'lon';
yname = 'lat';
zname = 'Band1';

[t,p,b1,op,bd]=readfort14('fort3.14',1);

for d = 1 : length(demnames)
    demname=demnams{1};
    disp(['Processing DEM ',num2str(d)]); 
    
    x = ncread(demname,xname);
    y = ncread(demname,yname);
    z = ncread(demname,zname);
    
    F = griddedInterpolant({x,y},z,'linear','none');
    
    b2= -F(p(:,1),p(:,2)); %<--negative above zero. 
    
    sel= isnan(b2);
    
    b2(sel,1) = b1(sel,1);
    
    figure, fastscatter(p(:,1),p(:,2),b2-b1,'.'); caxis([-1 1]);    
    title(['Difference attributed to ',demname]); 
    plot_google_map
    b1 = b2; 
end
writefort14('fort_updated.14',t,p,b1,op,bd,'grid');


