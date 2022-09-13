% 
% Skeleton code to demonstrate comparative analysis of saltmarsh topography
% 
% September 2022 - MSc Environmental Modelling Dissertation
%
% Notes:
% 1. This script reads all the mat files save in the topographic analysis,
%    which includs the amsked elevation, the abslute area of site, 
%    percentage area of sub-environemts and mean elevation of
%    sub-environments.
%
% Tested:       MATLAB 2020a
% Dependencies: Mapping Toolbox

clear 
close all

%% load data for each sites
load('Zdata_bwSteepleBay.mat');
load('Zdata_bwsalcott.mat');
load('Zdata_bwtoellsbury.mat');
load('Zdata_colne.mat'); 
load('Zdata_deben.mat');
load('Zdata_ScoltHeadIsland.mat');
load('Zdata_MorecambeBay.mat');
load('Zdata_ribble.mat');
%% Plot hypsometry curve
% sort and eliminate NaNs for each site
BWSteepleBay=Zdata_bwSteepleBay.maskedDEM;
BWSteepleBay=sort(reshape(BWSteepleBay,1,numel(BWSteepleBay)),'descend');
BWSteepleBay(isnan(BWSteepleBay))=[];
elementsSB=numel(BWSteepleBay);

BWSalcott=Zdata_bwsalcott.maskedDEM;
BWSalcott=sort(reshape(BWSalcott,1,numel(BWSalcott)),'descend');
BWSalcott(isnan(BWSalcott))=[];
elementsS=numel(BWSalcott);

BWToellsbury=Zdata_bwsalcott.maskedDEM;
BWToellsbury=sort(reshape(BWToellsbury,1,numel(BWToellsbury)),'descend');
BWToellsbury(isnan(BWToellsbury))=[];
elementsT=numel(BWToellsbury);

Colne=Zdata_colne.maskedDEM;
Colne=sort(reshape(Colne,1,numel(Colne)),'descend');
Colne(isnan(Colne))=[];
elementsC=numel(Colne);

Deben=Zdata_deben.maskedDEM;
Deben=sort(reshape(Deben,1,numel(Deben)),'descend');
Deben(isnan(Deben))=[];
elementsD=numel(Deben);

ScoltHeadIsland=Zdata_ScoltHeadIsland.maskedDEM;
ScoltHeadIsland=sort(reshape(ScoltHeadIsland,1,...
    numel(ScoltHeadIsland)),'descend');
ScoltHeadIsland(isnan(ScoltHeadIsland))=[];
elementsSHI=numel(ScoltHeadIsland);

MorecambeBay=Zdata_MorecambeBay.maskedDEM;
MorecambeBay=sort(reshape(MorecambeBay,1,numel(MorecambeBay)),'descend');
MorecambeBay(isnan(MorecambeBay))=[];
elementsMB=numel(MorecambeBay);

Ribble=Zdata_ribble.maskedDEM;
Ribble=sort(reshape(Ribble,1,numel(Ribble)),'descend');
Ribble(isnan(Ribble))=[];
elementsR=numel(Ribble);

% Normalize elevation on y-axis
BWSteepleBay=(BWSteepleBay-min(BWSteepleBay))./...
    (max(BWSteepleBay)-min(BWSteepleBay));
BWSalcott=(BWSalcott-min(BWSalcott))./(max(BWSalcott)-min(BWSalcott));
BWToellsbury=(BWToellsbury-min(BWToellsbury))./...
    (max(BWToellsbury)-min(BWToellsbury));
Colne=(Colne-min(Colne))./(max(Colne)-min(Colne));
Deben=(Deben-min(Deben))./(max(Deben)-min(Deben));
ScoltHeadIsland=(ScoltHeadIsland-min(ScoltHeadIsland))./...
    (max(ScoltHeadIsland)-min(ScoltHeadIsland));
MorecambeBay=(MorecambeBay-min(MorecambeBay))./...
    (max(MorecambeBay)-min(MorecambeBay));
Ribble=(Ribble-min(Ribble))./(max(Ribble)-min(Ribble));

% Plot 
% Use linspace to show the cumulative area on x-axis
figure
plot(linspace(0,100,elementsSB),BWSteepleBay,'-c', ...
     linspace(0,100,elementsS),BWSalcott,'-g',...
    linspace(0,100,elementsT),BWToellsbury,'--r',...
    linspace(0,100,elementsC),Colne,'-m',...
    linspace(0,100,elementsD),Deben,'-k',...
    linspace(0,100,elementsSHI),ScoltHeadIsland,'-b',...
    linspace(0,100,elementsMB),MorecambeBay,'-y',...
    linspace(0,100,elementsR),Ribble,'-r',...
    'LineWidth',1,'MarkerSize',3);

title('Hypsometry curve');
xlabel('Cumulative area [%]');
ylim([0 1]);
ylabel({'h/H'; 'h:elevation of sea level'; 'H:elevation of HAT'});
legend({'BWSteeple Bay','BWSalcott','BWTollesbury','Colne','Deben',...
    'Scolt Head Island', 'Morecambe Bay','Ribble'},'Location','southwest')

%% Topographic information talbe
% Absolute area of each site
SiteArea=[Zdata_bwSteepleBay.SiteArea;Zdata_bwsalcott.SiteArea;...
    Zdata_bwtoellsbury.SiteArea;Zdata_ScoltHeadIsland.SiteArea;...
    Zdata_colne.SiteArea;Zdata_deben.SiteArea;Zdata_ribble.SiteArea;...
    Zdata_MorecambeBay.SiteArea];

% Percentage area of salt pan
PansArea=[Zdata_bwSteepleBay.pansarea;Zdata_bwsalcott.pansarea;...
    Zdata_bwtoellsbury.pansarea;Zdata_ScoltHeadIsland.pansarea;...
    Zdata_colne.pansarea;Zdata_deben.pansarea;Zdata_ribble.pansarea;...
    Zdata_MorecambeBay.pansarea];

% Mean elevation of salt pan
PansElevation=[Zdata_bwSteepleBay.meanpansdem;Zdata_bwsalcott.meanpansdem;...
    Zdata_bwtoellsbury.meanpansdem;Zdata_ScoltHeadIsland.meanpansdem;...
    Zdata_colne.meanpansdem;Zdata_deben.meanpansdem;...
    Zdata_ribble.meanpansdem;Zdata_MorecambeBay.meanpansdem];

% Percentage area of saltmarsh
SaltmarshArea=[Zdata_bwSteepleBay.saltmarsharea;...
    Zdata_bwsalcott.saltmarsharea;...
    Zdata_bwtoellsbury.saltmarsharea;...
    Zdata_ScoltHeadIsland.saltmarsharea;...
    Zdata_colne.saltmarsharea;Zdata_deben.saltmarsharea;...
    Zdata_ribble.saltmarsharea;Zdata_MorecambeBay.saltmarsharea];

% Mean elevation of saltmarsh
SaltmarshElevation =[Zdata_bwSteepleBay.meansaltmarshdem;...
    Zdata_bwsalcott.meansaltmarshdem;...
    Zdata_bwtoellsbury.meansaltmarshdem;...
    Zdata_ScoltHeadIsland.meansaltmarshdem;...
    Zdata_colne.meansaltmarshdem;Zdata_deben.meansaltmarshdem;...
    Zdata_ribble.meansaltmarshdem;Zdata_MorecambeBay.meansaltmarshdem];

% Percentage area of channel
ChannelArea=[Zdata_bwSteepleBay.channelarea;Zdata_bwsalcott.channelarea;...
    Zdata_bwtoellsbury.channelarea;Zdata_ScoltHeadIsland.channelarea;...
    Zdata_colne.channelarea;Zdata_deben.channelarea;...
    Zdata_ribble.channelarea;Zdata_MorecambeBay.channelarea];

sites={'BWSteeple Bay','BWSalcott','BWTollesbury','Scolt Head Island', ...
    'Colne','Deben','Ribble','Morecambe Bay'};
sites=sites';

ta=table(sites,SiteArea,PansArea,PansElevation,SaltmarshArea,...
    SaltmarshElevation,ChannelArea); 

% Save the topographyic information table in excel
writetable(ta,'topogtaphy.xlsx')

%% Sub-environment image display: Saltmarsh (vegatated platform) 

figure;
t = tiledlayout(2,4);
nexttile
imshow(Zdata_bwsalcott.saltmarsh)
title('BWSalcott');
nexttile
[m1,n1,l1] = size(Zdata_bwsalcott.saltmarsh);
[m2,n2,l2] = size(Zdata_bwSteepleBay.saltmarsh);
bwsbSaltmarsh = zeros(m2,n2,l2); 
bwsbSaltmarsh((4000-m2+1):4000,(n1/2-n2/2+1):(n1/2+n2/2),:)...
    = Zdata_bwSteepleBay.saltmarsh;
imshow(bwsbSaltmarsh)
title('BWSteeple Bay');
nexttile
imshow(Zdata_bwtoellsbury.saltmarsh)
title('BWTollesbury');
nexttile
imshow(Zdata_colne.saltmarsh)
title('Colne');
nexttile
imshow(Zdata_deben.saltmarsh)
title('Deben');
nexttile
imshow(Zdata_ScoltHeadIsland.saltmarsh)
title('Scolt Head Island');
nexttile
imshow(Zdata_MorecambeBay.saltmarsh)
title('Morecambe Bay');
nexttile
imshow(Zdata_ribble.saltmarsh)
title('Ribble')
t.TileSpacing = 'compact';
t.Padding = 'compact';

%% Sub-environment image display: Salt pan

p=figure;
t = tiledlayout(2,4);
nexttile
imshow(Zdata_bwsalcott.pans)
title('BWSalcott');
nexttile
[m1,n1,l1] = size(Zdata_bwsalcott.pans);
[m2,n2,l2] = size(Zdata_bwSteepleBay.pans);
bwsbPans = zeros(m2,n2,l2); 
bwsbPans((4000-m2+1):4000,(n1/2-n2/2+1):(n1/2+n2/2),:)...
    = Zdata_bwSteepleBay.pans;
imshow(bwsbPans)
title('BWSteeple Bay');
nexttile
imshow(Zdata_bwtoellsbury.pans)
title('BWTollesbury');
nexttile
imshow(Zdata_colne.pans)
title('Colne');
nexttile
imshow(Zdata_deben.pans)
title('Deben');
nexttile
imshow(Zdata_ScoltHeadIsland.pans)
title('Scolt Head Island');
nexttile
imshow(Zdata_MorecambeBay.pans)
title('Morecambe Bay');
nexttile
imshow(Zdata_ribble.pans)
title('Ribble')
t.TileSpacing = 'compact';
t.Padding = 'compact';

%% Sub-environment image display: Channel image

figure;
t = tiledlayout(2,4);
nexttile
imshow(Zdata_bwsalcott.channel)
title('BWSalcott');
nexttile
[m1,n1,l1] = size(Zdata_bwsalcott.channel);
[m2,n2,l2] = size(Zdata_bwSteepleBay.channel);
bwsbChannel = zeros(m2,n2,l2); 
bwsbChannel((4000-m2+1):4000,(n1/2-n2/2+1):(n1/2+n2/2),:)...
    = Zdata_bwSteepleBay.channel;
imshow(bwsbChannel)
title('BWSteeple Bay');
nexttile
imshow(Zdata_bwtoellsbury.channel)
title('BWTollesbury');
nexttile
imshow(Zdata_colne.channel)
title('Colne');
nexttile
imshow(Zdata_deben.channel)
title('Deben');
nexttile
imshow(Zdata_ScoltHeadIsland.channel)
title('Scolt Head Island');
nexttile
imshow(Zdata_MorecambeBay.channel)
title('Morecambe Bay');
nexttile
imshow(Zdata_ribble.channel)
title('Ribble')
t.TileSpacing = 'compact';
t.Padding = 'compact';
