%% THIS CODE PROVIDES THE HIERARCICAL CLUSTERING OF THE HEATMAP

clear all;
clc;
close all;

[cities, population, coordinates] = muncity_list();

%% Data
load('SmoothMergedData.mat'); %size [2192 12]
% SmoothMergedData = SmoothMergedData(round(length(SmoothMergedData)/2):end,:);
for i = 1:size(SmoothMergedData,2)
    Cluster{i} = SmoothMergedData(:,i); %Current Clusters (will decrease from 12 to 1)
    CitiesCluster{i} = i; %index cities
end

%% Hierarcical clustering
while(length(Cluster) ~= 1)
% for jjj = 1:1
    tempCluster = [];
    tempCitiesCluster = [];
    Similarity = NaN*ones(length(Cluster), length(Cluster)); %Initial similarity is set to be NaN (not similar)
    %Checking pair possibilities
    for i = 1:length(Cluster) 
        for j = 1:length(Cluster)
            if i ~= j
                Variance = mean(mean(Cluster{i},2)) + mean(mean(Cluster{j},2));
                Similarity(i,j) = sum((mean(Cluster{i},2)-mean(Cluster{j},2)).^2)/Variance; % updating its similarity
            end
        end
    end
    % which pair is the most similar??
    val = min(min(Similarity));
    [idx1, idx2] = find(Similarity == val);
    % New cluster
    IdxCluster = 1;
    tempCluster{IdxCluster} = [Cluster{idx1(1)}, Cluster{idx1(2)}];
    tempCitiesCluster{IdxCluster} = [CitiesCluster{idx1(1)}, CitiesCluster{idx1(2)}];
    % Update Cluster

    for i = 1:length(Cluster) %Will only have length(Cluster)-1 numbers of clusters, since the two most similar is merged into one
        if (i ~= idx1(1))&&(i ~= idx1(2))
           
            IdxCluster = IdxCluster + 1;
            tempCluster{IdxCluster} = Cluster{i};
            tempCitiesCluster{IdxCluster} = CitiesCluster{i};
        end
    end
    % Update clusters
    Cluster = tempCluster;
    CitiesCluster = tempCitiesCluster;
    % Update Matrix Arrangement
    UpdatedData = [];
    for i = 1:length(Cluster)
        UpdatedData = [UpdatedData, Cluster{i}];
    end
    length(Cluster)
end

% Rearrange the list of the cities
UpdatedCities = [];
NewList = CitiesCluster{1};
for i = 1:length(CitiesCluster{1})
    UpdatedCities = [UpdatedCities, cities(NewList(i))];
end

figure;
D = datetime(2015,1,1) + caldays(0:1:length(SmoothMergedData)-1);
C = categorical(UpdatedCities);

h = heatmap(D,C,UpdatedData')
grid off
colormap(parula)
title([{'Temporal-Spatial Data of Dengue Cases (Clustered)'};{'South Cotabato'}])
% Show every 1st month
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
caxis([0, 10]);

 save("Hierarchical_Clustering_per_period.m")

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