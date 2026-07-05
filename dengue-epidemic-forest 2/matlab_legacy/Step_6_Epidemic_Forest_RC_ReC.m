clear all;
clc;
close all;

%% DATA INPUT
pop = readtable('SimulationData.xlsx');
lat = pop.Latitude;
lon = pop.Longitude;
%lon(4) = 125.2;
[cities, population,coordinates] = muncity_list();


popul = pop.Population;

%% POPULATION DATA
figure;
subplot(1,2,1)
RC = pop.RC_3;
f = @(x) (30);
g = @(x) ((255-1)/(max(RC)-min(RC)))*x + 1;

cmap = colormap(parula);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(RC(1)),'MarkerFaceColor',cmap(round(g(RC(1)))+1,:),'MarkerEdgeColor','k')
    dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points 
    text(lat(1)+dx, lon(1)+dy, cities(1), 'Fontsize', 5); 
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(RC(i)),'MarkerFaceColor',cmap(round(g(RC(i)))+1,:),'MarkerEdgeColor','k')
    alpha 0.2
    dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points 
    text(lat(i)+dx, lon(i)+dy, cities(i), 'Fontsize', 5); 
end
geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('City-Scale Reproductive Ratios Periode 3','fontsize',14)
colorbar
caxis([min(RC),max(RC)])

subplot(1,2,2)
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',5,'MarkerEdgeColor','k')
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',5,'MarkerEdgeColor','k')
    alpha 0.2
end
geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title('City-scale Resistance Ratiso','fontsize',14)



%% SUPP. FILES
function [cities, population, coordinates] = muncity_list()
    cities = {'BANGA','KORONADAL CITY','LAKE SEBU','NORALA','POLOMOLOK',...
        'SANTO NINO','SURALLAH', 'TBOLI',...
        'TAMPAKAN','TANTANGAN','TUPI','GENERAL SANTOS CITY'};
    population = [89164; 195398; 87442; 44642; 152589;...
        39796; 89340; 91453;...
        41018; 45744; 73459;697315];
    coordinates = [[6.4235, 124.7734];[6.5003, 124.8435];[6.2248, 124.7118];[6.5188, 124.6567];[6.2142, 125.0644];...
        [6.438, 124.6734];[6.3756, 124.7472];[6.2136, 124.8226];...
        [6.4439, 124.9272];[6.5632, 124.7682];[6.331, 124.9508];[6.12,125.17]];
end


function distance = disFun(a,b)
    % a: children (1x2)
    % b: parent candidate (length(b), 2)
    distance = [];
    for i=1:size(b,1)
        distance = [distance; sqrt((a(1)-b(1))^2+(a(2)-b(2))^2)];
    end
end
