clearvars; close all; clc;

filelist= dir('ncei*nc');

xname = 'lon';
yname = 'lat';
zname = 'Band1';

[t,p,b1,op,bd]=readfort14('fort3.14',1);

for d = 1 : length(filelist)
    demname=filelist(d).name; 
    disp(['Processing DEM ',demname]); 
    
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
    
    % swap old with new 
    b1 = b2; 
end
writefort14('fort_updated.14',t,p,b1,op,bd,'grid');


