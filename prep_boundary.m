%%
%FUNCTION TO READ MESH

f14name = 'fort_NCEI_RDEMS.grd'

fid=fopen(f14name,'rt');

%READ DESCRIPTION
desc = fgetl(fid)

%READ FIRST LINE (NODES NUMBER)
[elno] = fscanf(fid,'%g',[1 2]);

%READ NODES AND COORDINATES
[bathy] = fscanf(fid,'%g', [4 elno(2)])';

%READ ELEMENTS
[connect] = fscanf(fid,'%i',[5 elno(1)])';

% %READ ELEVATION (TIDAL/OPEN) BOUNDARIES
nobnds = textscan(fid, '%d %*[^\n]',1);

bndnodes = textscan(fid, '%d %*[^\n]',1);

for currbnd = 1:nobnds{1}
    
    nodesincurr = textscan(fid, '%d %*[^\n]',1);
    
    for n=1:nodesincurr{1}
        
        tmp = textscan(fid, '%d %*[^\n]',1);
        boundaries(currbnd).boundary(n) = tmp{1};
        
    end
    
end

%% GET BOUNDARIES LAT AND LON
% 
nobnds{1}
for n = 1:nobnds{1}
    
    tmp = size(boundaries(n).boundary);
    
    for i = 1:tmp(2)
        
        location(i,1) =   bathy( boundaries(n).boundary(i) , 3);
        location(i,2) =   bathy( boundaries(n).boundary(i) , 2);
    
    end
    
    dlmwrite(['boundary.' num2str(n)], location, ' ')
    
end

fclose(fid);
clear desc;
