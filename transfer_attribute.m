% Transfer an attribute from other grid to new one by matching node
% positions
clearvars; clc;

att = 'mannings_n_at_sea_floor'; %choose attribute 
                         %(advection_state or mannings_n_at_sea_floor etc.)
filename = ['fort_new.13.' att]; %out filename

[~,VXn]=readfort14('fort3.14',0); 

[~,VX]=readfort14('fort_old.14',0); 

%% open the old fort 13 and transfer mannings to new grid
f13name = 'fort_old.13';
fid=fopen(f13name,'rt');

desc = textscan(fid, '%s %*[^\n]',1);
total_nodes = fscanf(fid, '%d',1);
att_num = fscanf(fid, '%d',1); % number of attributes
att_name = cell(1,1);
while ~strcmp(att_name{1},att) % search for wanted attribute
    att_name = textscan(fid, '%s %*[^\n]',1);
end
units = textscan(fid, '%s %*[^\n]',1);
desc = textscan(fid, '%s %*[^\n]',1);
N_default = fscanf(fid, '%f',1); % Default value of attribute
att_name = cell(1,1);
while ~strcmp(att_name{1},att) % search for wanted attribute
    att_name = textscan(fid, '%s %*[^\n]',1);
    nnodes = fscanf(fid, '%d',1); % get number of nodes for this attribute
    att_val = fscanf(fid,'%d %f',[2 nnodes])'; % get values for this attribute
end
fclose(fid);

[idx, ~] = knnsearch(VXn,VX(att_val(:,1),:));
[idx, ix] = sortrows(idx);
att_val = att_val(ix,2);

%% Write out the new .13 sub file
fid = fopen(filename,'w');

% Print header
fprintf(fid,'%s \n','Spatial attributes description') ;
fprintf(fid,'%d \n',length(VXn)) ;   
fprintf(fid,'%d \n',1) ;  
fprintf(fid,'%s \n',att) ;
fprintf(fid,'%s \n',char(units{1})) ;
fprintf(fid,'%d \n',1) ;  
fprintf(fid,'%f \n',N_default) ;  
fprintf(fid,'%s \n',att) ;
%number of nodes not default
fprintf(fid,'%d \n',nnodes) ; 
% Print out list of nodes for each
for k = 1:nnodes
    fprintf(fid,'%d \t %f \n',idx(k),att_val(k));
end
fclose(fid);