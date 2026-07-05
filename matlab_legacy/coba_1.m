clear all;
clc;
close all;

%% DATA INPUT
pop = readtable('SimulationData.xlsx');
lat = pop.Latitude;
lon = pop.Longitude;
lon(4) = 125.2;
[cities, population,coordinates] = muncity_list();


popul = pop.Population;

%% POPULATION DATA
figure;
subplot(2,2,1)
f = @(x) 6 + 20*(x/max(popul));
g = @(x) 2*x;

onset = pop.Onset_1;
cmap = colormap(hot);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(onset(1)))+1,:),'MarkerEdgeColor','k')
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(onset(i)))+1,:),'MarkerEdgeColor','k')
    alpha 0.2
end
geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('Period 1')

subplot(2,2,2)
f = @(x) 6 + 20*(x/max(popul));
g = @(x) 2*x;

onset = pop.Onset_2;
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(onset(1)))+1,:),'MarkerEdgeColor','k')
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(onset(i)))+1,:),'MarkerEdgeColor','k')
    alpha 0.2
end
geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('Period 2')


subplot(2,2,3)
f = @(x) 6 + 20*(x/max(popul));
g = @(x) 2*x;

onset = pop.Onset_3;
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(onset(1)))+1,:),'MarkerEdgeColor','k')
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(onset(i)))+1,:),'MarkerEdgeColor','k')
    alpha 0.2
end
geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('Period 3')

% subplot(2,2,4)
% f = @(x) 6 + 20*(x/max(popul));
% g = @(x) 2*x;
% 
% onset = pop.Onset_7;
% geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(onset(1)))+1,:),'MarkerEdgeColor','k')
% alpha 0.2
% hold
% for i = 2:12
%     geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(onset(i)))+1,:),'MarkerEdgeColor','k')
%     alpha 0.2
% end
% geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
% geobasemap darkwater
% title('Period 7')


%% POPULATION DATA + CASES
figure;
subplot(2,2,1)
f = @(x) 6 + 20*(x/max(popul));
g = @(x) x/3;

cases = pop.Cases_1;
cmap = colormap(copper);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(cases(1)))+1,:),'MarkerEdgeColor','k')
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(cases(i)))+1,:),'MarkerEdgeColor','k')
    alpha 0.2
end
geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('Period 1')


subplot(2,2,2)
f = @(x) 6 + 20*(x/max(popul));
g = @(x) x/3;

cases = pop.Cases_2;
cmap = colormap(copper);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(cases(1)))+1,:),'MarkerEdgeColor','k')
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(cases(i)))+1,:),'MarkerEdgeColor','k')
    alpha 0.2
end
geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('Period 2')


subplot(2,2,3)
f = @(x) 6 + 20*(x/max(popul));
g = @(x) x/3;

cases = pop.Cases_3;
cmap = colormap(copper);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(cases(1)))+1,:),'MarkerEdgeColor','k')
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(cases(i)))+1,:),'MarkerEdgeColor','k')
    alpha 0.2
end
geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('Period 3')

% subplot(2,2,4)
% f = @(x) 6 + 20*(x/max(popul));
% g = @(x) x/3;
% 
% cases = pop.Cases_7;
% cmap = colormap(copper);
% geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(cases(1)))+1,:),'MarkerEdgeColor','k')
% alpha 0.2
% hold
% for i = 2:12
%     geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(cases(i)))+1,:),'MarkerEdgeColor','k')
%     alpha 0.2
% end
% geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
% geobasemap darkwater
% title('Period 7')


%% NETWORK CONTRUCTION
figure;
ConnectivityMatrix = zeros(12,12);
alpha = 0;
ProbDis = @(dis) exp(-alpha*dis);
for i = 1:12
    for j = 1:12
        if (i ~= j)
            randomNum  = rand(1);
            dis = disFun(coordinates(i,:),coordinates(j,:));
%             ProbDis(dis)
            if randomNum < ProbDis(dis)
                ConnectivityMatrix(i,j) = 1;
            end
        end
    end
end

subplot(1,3,1)
onset = pop.Onset_1;
cmap = colormap(hot);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor','r','MarkerEdgeColor','k')
hold
for i = 2:12
   geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor','r','MarkerEdgeColor','k')
end

geoplot([lat(1), lat(2)],[lon(1), lon(2)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor','r','MarkerEdgeColor','k')

for i = 1:12
    for j = 1:12
        if i~=j
            if ConnectivityMatrix(i,j) == 1
                geoplot([lat(i), lat(j)],[lon(i), lon(j)],'k-','LineWidth',1)
            end
        end
    end
end

geolimits([min(lat)-0.05,max(lat)+0.05],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('\lambda=0')

% lambda = 0.5
ConnectivityMatrix = zeros(12,12);
alpha = 0.5;
ProbDis = @(dis) exp(-alpha*dis);
for i = 1:12
    for j = 1:12
        if (i ~= j)
            randomNum  = rand(1);
            dis = disFun(coordinates(i,:),coordinates(j,:));
%             ProbDis(dis)
            if randomNum < ProbDis(dis)
                ConnectivityMatrix(i,j) = 1;
            end
        end
    end
end

subplot(1,3,2)
onset = pop.Onset_2;
cmap = colormap(hot);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor','r','MarkerEdgeColor','k')
hold
for i = 2:12
   geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor','r','MarkerEdgeColor','k')
end

geoplot([lat(1), lat(2)],[lon(1), lon(2)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor','r','MarkerEdgeColor','k')

for i = 1:12
    for j = 1:12
        if i~=j
            if ConnectivityMatrix(i,j) == 1
                geoplot([lat(i), lat(j)],[lon(i), lon(j)],'k-','LineWidth',1)
            end
        end
    end
end

geolimits([min(lat)-0.05,max(lat)+0.05],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('\lambda=0.5')

% lambda = 1
ConnectivityMatrix = zeros(12,12);
alpha = 1;
ProbDis = @(dis) exp(-alpha*dis);
for i = 1:12
    for j = 1:12
        if (i ~= j)
            randomNum  = rand(1);
            dis = disFun(coordinates(i,:),coordinates(j,:));
%             ProbDis(dis)
            if randomNum < ProbDis(dis)
                ConnectivityMatrix(i,j) = 1;
            end
        end
    end
end

subplot(1,3,3)
onset = pop.Onset_3;
cmap = colormap(hot);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor','r','MarkerEdgeColor','k')
hold
for i = 2:12
   geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor','r','MarkerEdgeColor','k')
end

geoplot([lat(1), lat(2)],[lon(1), lon(2)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor','r','MarkerEdgeColor','k')

for i = 1:12
    for j = 1:12
        if i~=j
            if ConnectivityMatrix(i,j) == 1
                geoplot([lat(i), lat(j)],[lon(i), lon(j)],'k-','LineWidth',1)
            end
        end
    end
end

geolimits([min(lat)-0.05,max(lat)+0.05],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('\lambda=1')

%% SUPP
function [cities, population, coordinates] = muncity_list()
    cities = {'ALAMADA','ALEOSAN','ANTIPAS','ARAKAN','BANISILAN',...
        'CARMEN','KABACAN','KIDAPAWAN CITY','LIBUNGAN','MAGPET','MAKILALA',...
        'MATALAM','MIDSAYAP','M_LANG','PIGKAWAYAN','PIKIT','PRESIDENT ROXAS','TULUNAN'};
    population = [68659; 41944; 26817; 50558; 46995;...
        107603; 93882; 160791; 56269; 53640; 87927;...
        81355; 165376; 98195; 72371; 164646; 52512; 60978];
    coordinates = [[3.03, 4.87];[3.49, 2.88];[5.555, 3.51];[6.6, 4.03];[4.1, 4.93];...
        [4.31, 3.7];[4.54, 2.35];[5.81, 1.96];[2.81, 3.92];[6.57, 2.53];[6.19, 1.33];...
        [5.12, 2.49];[2.77, 2.63];[5.13, 1.47];[2.36, 3.47];[3.335, 2.08];[5.78, 2.95];[5.54, 0.59]];
end

function distance = disFun(a,b)
    % a: children (1x2)
    % b: parent candidate (length(b), 2)
    distance = [];
    for i=1:size(b,1)
        distance = [distance; sqrt((a(1)-b(1))^2+(a(2)-b(2))^2)];
    end
end