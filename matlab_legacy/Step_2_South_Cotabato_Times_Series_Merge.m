%% THIS CODE IS THE CONTINUATION OF THE North_Cotabato_Time_Series_Data.m
%% THIS CODE MERGES DATA FOR ALL YEARS

clear all;
clc;
close all;

[cities, population, coordinates] = muncity_list();


%% ORIGINAL DATA
MergedData = [];
YearList = [2015; 2016; 2017; 2018; 2019; 2020];
for i = 1:length(YearList)
    load(['DailyMat', num2str(YearList(i))]);
    MergedData = [MergedData; DaiyMat];
end

figure;
s = surf(MergedData')
s.EdgeColor = 'none';
xlim([0, 2192])
ylim([1, 12])

%% SMOOTHED DATA
SmoothMergedData = [];

    SmoothDaiyMat = [];
    for j = 1:12
        SmoothDaiyMat = [SmoothDaiyMat, smooth(MergedData(:,j),60)];
    end
    SmoothMergedData = [SmoothMergedData; SmoothDaiyMat];
    
figure;
C = categorical(cities);
D = datetime(2015,1,1) + caldays(0:1:length(SmoothMergedData)-1);
s = surf(D, C, SmoothMergedData')
s.EdgeColor = 'none';
% xlim([0, 2192])
% ylim([1, 12])
view(2)
ylabel('Regions')

%% HEATMAP
figure;
h = heatmap(D,C,SmoothMergedData')
grid off
colormap(parula)
title([{'Temporal-Spatial Data of Dengue Cases:'};{'South Cotabato'}])
% Show every 1 January
for i = 1:length(D)
    if (month(D(i))==1)&&(day(D(i))==1)
        idx(i) = 1;
    else
        idx(i) = 0;
    end
end          % index of datetime values to show as x tick
h.XDisplayLabels(~idx) = {''};
s = struct(h);
s.XAxis.TickLabelRotation = 0;  % vertical
save('SmoothMergedData.mat','SmoothMergedData','DailyMat')

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