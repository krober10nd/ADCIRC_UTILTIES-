clear all; close all; clc;
% Interpolate Manning's n data using NLCD landcover database projected onto
% WGS84 onto your mesh. 
% kjr, chl, und Dec. 2017;
%%%%%%%%%%%%%%%%%%%%%%%%%
def_mannings_n  =0.025;
fort14name      ='fort.14';
nlcdname        ='outfile_sbs.nc'; %<--use gdal_translate to convert nlcd img file to netcdf 
oldfort13name   ='fort.13'; 
oldattname      ='mannings_n_at_sea_floor'; 
%%%%%%%%%%%%%%%%%%%%%%%%%

tic
disp('Reading in fort.14...');
[t,p,b]=readfort14(fort14name,0);
toc

disp('Building interpolant...');
tic
x = ncread(nlcdname,'lon');
y = ncread(nlcdname,'lat');
Band1= ncread(nlcdname,'Band1');
F=griddedInterpolant({x,y},Band1,'nearest','none');
toc

disp('Interpolating Manning''s onto your grid...');
tic
if ~isempty(oldfort13name)
    disp('...from your old fort.13...'); 
    [fort13dat]=readfort13(oldfort13name); 
    dmy=fort13dat.userval.Atr.Val;
    mannings_n(dmy(1,:))=dmy(2,:); 
    dmy=fort13dat.defval.Atr.Val;
    mannings_n(dmy(1,:))=dmy(2,:);
    clear dmy
else
    disp('...assuming default value of ',num2str(def_mannings_n)); 
    mannings_n = 0*p(:,1) + def_mannings_n;
end
% nearest landcover classification for node's in the mesh. 
nlcd_class=F(p(:,1),p(:,2));
% class numbers that are mapped to different land types. 
classes = [11; 12; 21; 22; 23; 24; 31; 32; 41; 42; 43; 51 ;52; 71; 72;
           73; 74; 81; 82; 90; 91; 92; 93; 94; 95; 96; 97; 98; 99]; 
% find the nearest lc pt to the grid pt
for cl=1 : length(classes) % loop over the classes
    idx = find(nlcd_class==cl); 
    if cl==11
        mannings_n(idx)=0.02;    %Open Water
    elseif cl==12
        mannings_n(idx)=0.010;   %Perennial Ice/Snow
    elseif cl==21
        mannings_n(idx)=0.020;   %Developed - Open Space
    elseif cl==22
        mannings_n(idx)=0.050;   %Developed - Low Intensity
    elseif cl==23
        mannings_n(idx)=0.100;      %Developed - Medium Intensity
    elseif cl==24
        mannings_n(idx)=0.150;   %Developed - High Intensity
    elseif (cl==31)
        mannings_n(idx)=0.090;  %Barren Land (Rock/Sand/Clay)
    elseif (cl==32)
        mannings_n(idx)=0.040;   %Unconsolidated Short
    elseif (cl==41)
        mannings_n(idx)=0.100;   %Deciduous Forest
    elseif (cl==42)
        mannings_n(idx)=0.110;   %Evergreen Forest
    elseif (cl==43)
        mannings_n(idx)=0.100;   %Mixed Foresty
    elseif (cl==51)
        mannings_n(idx)=0.040;   %Dwarf Scrub
    elseif (cl==52)
        mannings_n(idx)=0.050;   %Shrub/Scrub
    elseif (cl==71)
        mannings_n(idx)=0.034;   %Grassland/Herbaceous
    elseif (cl==72)
        mannings_n(idx)=0.030;   %Sedge/Herbaceous
    elseif (cl==73)
        mannings_n(idx)=0.027;   %Lichens
    elseif (cl==74)
        mannings_n(idx)=0.025;   %Moss
    elseif (cl==81)
        mannings_n(idx)=0.033;   %Pasture/Hay
    elseif (cl==82)
        mannings_n(idx)=0.037;   %Cultivated Crops
    elseif (cl==90)
        mannings_n(idx)=0.100;   %Woody Wetlands
    elseif (cl==91)
        mannings_n(idx)=0.100;   %Palustrine Forested Wetland
    elseif (cl==92)
        mannings_n(idx)=0.048;   %Palustrine Scrub/Shrib Wetland
    elseif (cl==93)
        mannings_n(idx)=0.100;   %Estuarine Forested Wetland
    elseif (cl==94)
        mannings_n(idx)=0.048;   %Estuarine Scrub/Shrub Wetland
    elseif (cl==95)
        mannings_n(idx)=0.045;   %Emergent Herbaceous Wetlands
    elseif (cl==96)
        mannings_n(idx)=0.045;  %Palustrine Emergent Wetland (Persistant)
    elseif (cl==97)
        mannings_n(idx)=0.045;   %Estuarine Emergent Wetland
    elseif (cl==98)
        mannings_n(idx)=0.015;   %Palustrine Aquatic Bed
    elseif cl==99
        mannings_n(idx)=0.015;   %Estuarine Aquatic Bed
    else
        %mannings_n(idx)=0.025;   % default value (no need since
        %initialization).
    end
end
%writefort13(
toc