%clearvars; close all; clc;
%msh1 = msh('ECGC_CH5_-82.3_-60.5_36.75_42.14');
%msh2 = msh('ECGC_CH5_-72_-60.5_41.75_46.14'); 
% msh1 = msh('prelim.14');
% plot(msh1,'tri');
msh1 = m; 
TR = triangulation(msh1.t,msh1.p(:,1),msh1.p(:,2));

[cc,cr] = circumcenter(TR);

for i = 1  : length(msh1.t)
    cl = cr(i) ;
    for j = 1 :  3
        z(msh1.t(i,j)) = cl*111e3;
    end
end

base = 10; 
q = log10((z)); % plot on log scale with base 

figure;
trimesh(msh1.t,msh1.p(:,1),msh1.p(:,2),q, 'facecolor', 'flat', 'edgecolor', 'none');
view(2)
cptcmap('GMT_haxby'); cb = colorbar;
caxis([log10(50) log10(10e3)]);

desiredTicks = [ 50 100 250 500 1000 2e3 5e3 10e3];
cb.Ticks     = log10(desiredTicks); 
for i = 1 : length(desiredTicks)
   cb.TickLabels{i} = num2str(desiredTicks(i)); 
end
ylabel(cb,'m','fontsize',15);
title('mesh resolution');

