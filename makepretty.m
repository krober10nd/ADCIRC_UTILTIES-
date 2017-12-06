%alter properties of figurs so that all figures are consistent in appearance 

function [] =makepretty(gcf,gca,size)
set(gcf,'color','white'); 
grid on; 
set(get(gca,'title'),'fontsize',size,'fontweight','bold')
set(get(gca,'xlabel'),'fontsize',size,'fontweight','bold')
set(get(gca,'ylabel'),'fontsize',size,'fontweight','bold')
set(gca,'fontsize',size,'fontweight','bold')

end