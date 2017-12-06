clear all; close all; clc;
%plot time series from output of syncIMEDS python script
noStat=193;
load StationNames
jj=1; %counter for storing
plotFig = 1;
%read in location of stations
locs = dlmread('SANDY_VAL.V2.INTERP6364.STATIONS.txt');
locs = locs(2:end,:);
OFFSET=0;

for i = 1:noStat
    file = ['sync_STATION_',num2str(i)];
    name = ['STATION ',num2str(i)];
    fid = fopen(file,'r');
    if fid < 0 %file doesn't exist
        continue
    else
        %bad data
        if i == 26 || i == 25
            continue
        end
        
        
        data=textscan(fid,'%q %f %f','HeaderLines',1,'Delimiter',',');
        dmytime = data{1}; %time vector
        %
        if isempty(dmytime)~=1
            for j = 1 : size(dmytime,1)
                meta=dmytime{j,1};
                datetime(j,1)=datenum(meta,'yyyymmddHHMMSS')';
            end
        else %time vector doesn't exist
            continue
        end
        obs = data{2};
        if nanmean(obs) > 4.0
            continue %must be pressure sensor, skip
        end
        obs(obs<-1000) = NaN; %dry value
        %obsLP=wlevel_filter_24h(datetime,obs,.0028,.3968); %low pass with a cutoff of 0.50 h.
        if i==3 || i==4 %some problems with these two stations.
            obs(obs<0.50)=NaN;
            obsLP=obs;
        else
            obsLP = smooth(obs,3); %30min low pass 
        end
       
        %remove the drying effects
        mask=diff(obsLP);
        mask=[0;mask];
        mask=abs(mask)>0.005;
        mask = double(mask);
        mask(mask==0) = NaN; % or A(~A)=NaN
        obsLP=mask.*obsLP;
        
        if isempty(nanmax(obs))==1
            continue %no obs.
        end
        %model data
        mod = data{3};
        mod(mod<-1000) = NaN; %dry value
        mod(mod>5.0) = NaN; %non-physical value
        metacorr=corrcoef([obsLP,mod],'rows','complete');
        R(jj,1)=metacorr(2);
        
        landfall = datenum([2012,10,29,23,00,00]); %landfall time
        if plotFig == 1
            
            hObs=plot(datetime(1:length(obsLP)),obsLP,'bo'); hold on;
            hMod=plot(datetime(1:length(mod)),mod+OFFSET,'r','linewi',3);
            legend([hObs,hMod],'Obs.','Mod.','position','best');
            datetick('x','dd');
            xlabel('Days in October 2012');
            ylabel('m above NAVD88');
            ylim([-1.0 4.5]);
            plot(linspace(landfall,landfall,100),linspace(-1.0,4.5,100),'g--','linewi',3);
            title([StationNames{i,:}]);
            makepretty(gcf,gca,16);
            print(['SV2',StationNames{i,:}],'-dpng','-r300');   
            
            obsMax(jj) = nanmax(obsLP);
            obsMean(jj) = nanmean(obsLP);
            modMax(jj) = nanmax(mod)+OFFSET;
            modMean(jj)= nanmean(mod);
            %rmse 
            
            %(y - yhat)    % Errors
            %(y - yhat).^2   % Squared Error 
            %mean((y - yhat).^2)   % Mean Squared Error
            %RMSE = sqrt(mean((y - yhat).^2));  % Root Mean Squared Error
            RMSE(jj) = sqrt(nanmean((obsLP - mod).^2));  % Root Mean Squared Error            
            MAE(jj)=nanmean(abs(mod-obs));
            maxEleMAE(jj)=abs(modMax(jj)-obsMax(jj));
            KeptNames{jj,:}=StationNames{i,:};
            Kept(jj,:) = locs(i,:);
            jj=jj+1;
            createxmlfile(KeptNames,Kept,obsMax,modMax,0.2,'ZetaGE1pt5m_amp','SandyVal');
            close all;
            
        else
            obsMax(jj) = nanmax(obsLP);
            obsMean(jj) = nanmean(obsLP);
            modMax(jj) = nanmax(mod)+OFFSET;
            modMean(jj)= nanmean(mod)+OFFSET;
            
            %rmse 
            
            %(y - yhat)    % Errors
            %(y - yhat).^2   % Squared Error 
            %mean((y - yhat).^2)   % Mean Squared Error
            %RMSE = sqrt(mean((y - yhat).^2));  % Root Mean Squared Error
            RMSE(jj) = sqrt(nanmean((obsLP - mod).^2));  % Root Mean Squared Error            
            MAE(jj)=nanmean(abs(mod-obs));
            maxEleMAE(jj)=abs(modMax(jj)-obsMax(jj))
            KeptNames{jj,:}=StationNames{i,:};
            Kept(jj,:) = locs(i,:);
            jj=jj+1;
            createxmlfile(KeptNames,Kept,obsMax,modMax,0.2,'ZetaGE1pt5m_amp','SandyVal');
        end
        fclose(fid);
    end
    i
    
    
    
end


hist(maxEleMAE,[.05:0.1:2]); hold on; 
plot(linspace(0.5,0.5,100),linspace(0,50,100),'g','linewi',2);
h=text(0.5,35,'Excellent');
set(h, 'rotation', 90)
plot(linspace(1.0,1.0,100),linspace(0,50,100),'y','linewi',2);
h=text(1.0,35,'Acceptable');
set(h, 'rotation', 90)
plot(linspace(1.5,1.5,100),linspace(0,50,100),'r','linewi',2);
h=text(1.5,35,'Poor');
set(h, 'rotation', 90)
title('Hurricane Sandy, $|simulated - observed|_{\infty}$','Interpreter','LaTeX'); 
xlabel('$|simulated - observed|_{\infty}$','Interpreter','Latex'); 
ylabel('Number of stations','Interpreter','Latex'); 
makepretty(gcf,gca,16); 

% figure;
% for i = 1 : 119
%     if i <= 4 %CT
%         scatter(obsMax(i),modMax(i),'ro'); hold on;
%     elseif i > 4 && i<= 27 % %
%         scatter(obsMax(i),modMax(i),'gx'); hold on;
%     elseif i > 27 && i <=54
%      scatter(obsMax(i),modMax(i),'bs'); hold on;
%     elseif i > 54 && i <=59 %
%      scatter(obsMax(i),modMax(i),'mp'); hold on;
%     elseif i > 59 && i<=62 %
%       scatter(obsMax(i),modMax(i),'oo'); hold on;
%
%     end
% end
% DATA=refline;
% PER=refline(1,0);
% refline(1,0.25);
% refline(1,-0.25);
% PER.Color='k';
% crr = corrcoef(modMax,obsMax,'rows','complete');
% title('Hurricane Sandy Oct. 25 00Z to Nov. 1st 00Z');
% text(2,5,['Corr = ',num2str(crr(2))]);
% text(2,4.5,['n = 112']);
% xlabel('simulated $||\eta||_{\infty}$','interpreter','latex');  ylabel('obserevd $||\eta||_{\infty}$','interpreter','latex');
% makepretty(gcf,gca,16);

% figure;
% scatter(obsMean,modMean,'ro');
% DATA=refline;
% PER=refline(1,0);
% refline(1,0.25);
% refline(1,-0.25);
% PER.Color='k';
% crr = corrcoef(obsMean,modMean,'rows','complete');
% title('Hurricane Sandy Oct. 25 00Z to Nov. 1st 00Z');
% text(2,3.5,['Corr = ',num2str(crr(2))]);
% text(2,4.0,['n = 112']);
% xlabel('simulated $\hat{eta} \ge 1.5 m$','interpreter','latex');  ylabel('obserevd $\hat{eta} \ge 1.5 m $','interpreter','latex');
% makepretty(gcf,gca,16);


%create xml file
%createxmlfile(StnId,LatLon,obs,mod,delta,xmlabel,runtitle)
