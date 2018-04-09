fid = fopen('mixed_mesh.14','w');

noNode = length(ptemp);
noEle  = length(qtmesh);

fprintf(fid,'%s\n','testing mixed mesh');
fprintf(fid,'%i %i\n',noEle,noNode);

% nodal table
for i = 1 : length(ptemp)
    fprintf(fid,'%i %f %f %f\n',i,ptemp(i,1),ptemp(i,2),0.0);
end


% element table
for i = 1 : length(qtmesh)
    noEl = length(qtmesh(i).con);
    if noEl ==3
        % triangular element
        fprintf(fid,'%i %i %i %i %i\n',i,noEl,qtmesh(i).con(1),qtmesh(i).con(2),qtmesh(i).con(3) );
    else
        % quad element
        fprintf(fid,'%i %i %i %i %i %i\n',i,noEl,qtmesh(i).con(1),qtmesh(i).con(2),qtmesh(i).con(3),qtmesh(i).con(4) );
    end
end

% boundary nonsense
for i = 1 : 4
    fprintf(fid,'%i\n',0);
end

fclose(fid);