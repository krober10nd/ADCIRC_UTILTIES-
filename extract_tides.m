clear all; close all; clc; 
% After running prep_boundary.m, run this code to produce a text file 
% called Exp.txt that will be in a format that is directly copied into the fort.15. 
fid = fopen('Exp.txt','w');
constout = {'Q1','O1','P1','K1','N2','M2','S2','K2'};
const = {'q1','o1','p1','k1','n2','m2','s2','k2'};

boundary = importdata('boundary.1');
b_lat = boundary(:,1);
b_lon = boundary(:,2);

for j = 1 : 8
    
    lon=ncread(['hf.',cell2mat(const(j)),'_tpxo8_atlas_30c_v1.nc'],'lon_z');
    lat=ncread(['hf.',cell2mat(const(j)),'_tpxo8_atlas_30c_v1.nc'],'lat_z');
    hRe=ncread(['hf.',cell2mat(const(j)),'_tpxo8_atlas_30c_v1.nc'],'hRe') ;
    hIm=ncread(['hf.',cell2mat(const(j)),'_tpxo8_atlas_30c_v1.nc'],'hIm') ;
    lon = lon-360;
    
    hRe = double(hRe);
    hIm = double(hIm);
    
    amp=abs(hRe+i*hIm);
    amp = (amp./1e3)';
    max(amp(:))
    phs=atan2(-hIm,hRe)/pi*180; phs = phs';
    
    % [lx,ly] = meshgrid(lon,lat) ;
    % lx=lx'; ly=ly';
    %
    % figure(2)
    % pcolor( lx, ly, amp ) ;
    % colorbar
    % shading('interp') ;
    % pause
    
    %figure; plot(b_lon,b_lat,'k-','linewi',2);
    for i = 1 : length(boundary)
        [min_lat,i_lat(i)] = min(abs(lat - b_lat(i)));
        [min_lon,i_lon(i)] = min(abs(lon - b_lon(i)));
        
        coord(i,:) = [lon(i_lon(i)),lat(i_lat(i))];
        
        %find location of this coord in mesh
        b_amp(i) = amp(i_lon(i),i_lat(i));
        b_phs(i) = phs(i_lon(i),i_lat(i)) ;
        %hold on;
        %plot(lx(i_lon(i),i_lat(i)),ly(i_lon(i),i_lat(i)),'rx'); %highlight the boundary nodes on a map
    end
    
    fprintf(fid,'%s \n',cell2mat(constout(j))) ;
    for i = 1:length(boundary)
        
        fprintf(fid,'%12.6f  %12.6f\n',[b_amp(i) b_phs(i)]) ;
        
        
    end
    disp('finished');
    clearvars -except const constout b_lat b_lon boundary fid
end

