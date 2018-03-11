close all; clc; 
% create a logarithmic trimesh plot with cleanly labels intervals.
% here we use the cmocean package for colormaps. 

desmin = 50;
desmax = 10e3;
desiredTicks = [ 50 100 250 500 1000 2e3 5e3 10e3];
% msh1 = msh('prelim.14');
% plot(msh1,'tri');
for i = 1  : length(msh1.t)
    nm1 = msh1.t(i,1);
    nm2 = msh1.t(i,2);
    nm3 = msh1.t(i,3);
    facebath(nm1,1) = (msh1.b(nm1)+msh1.b(nm2)+msh1.b(nm3))/3;
    facebath(nm2,1) = (msh1.b(nm1)+msh1.b(nm2)+msh1.b(nm3))/3;
    facebath(nm3,1) = (msh1.b(nm1)+msh1.b(nm2)+msh1.b(nm3))/3;
    
end

base = 10;
q = log10((facebath)); % plot on log scale with base 10

figure;
trimesh(msh1.t,msh1.p(:,1),msh1.p(:,2),real(q), 'facecolor', 'flat', 'edgecolor', 'none');
view(2)
cb = colorbar;
caxis([log10(desmin) log10(desmax)]);
cmap=cmocean('ice',length(desiredTicks));
colormap(cmap,length(desiredTicks));
cb.Ticks     = log10(desiredTicks);
for i = 1 : length(desiredTicks)
    cb.TickLabels{i} = num2str(desiredTicks(i));
end
ylabel(cb,'m','fontsize',15);
title('bathymetry');

