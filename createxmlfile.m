function createxmlfile(StnId,LatLon,obs,mod,delta,xmlabel,runtitle)
fid = fopen([runtitle,'_',xmlabel,'.xml'],'w');
fprintf(fid,'%s \n','<markers>');
for k = 1:length(StnId)
    str = ['<marker stnid="',StnId{k},'" lat="',num2str(LatLon(k,2)),...
        '" lng="',num2str(LatLon(k,1)),'" label="',xmlabel,...
        '" observed="',num2str(obs(k)),'" model="',num2str(mod(k)),'" error="',num2str(abs(-obs(k)+mod(k))),...
        '" delta="',num2str(delta),'" image="',['SV2',StnId{k},'.png'],'"/>'];
    fprintf(fid,'%s \n',str);
end
fprintf(fid,'%s','</markers>');
fclose(fid);