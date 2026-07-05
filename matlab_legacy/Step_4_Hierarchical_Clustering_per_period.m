%% THIS CODE PROVIDES THE HIERARCICAL CLUSTERING OF THE HEATMAP

clear all;
clc;
close all;

[cities, population, coordinates] = muncity_list();
Period = [[116,319]; [510, 800];[1550, 1796]]; %3 period only
load('SmoothMergedData.mat')
tm = datetime(2015,1,1) + caldays(0:1:length(SmoothMergedData)-1);
for KKK = 1:3

%% Data
load('SmoothMergedData.mat'); %size [2192 12]
% norm
%  ttemp = []; 
% for i = 1:12
%     ttemp = [ttemp, SmoothMergedData(:,i)/population(i)];
% end
% SmoothMergedData = ttemp;

SmoothMergedData = SmoothMergedData(Period(KKK,1):Period(KKK,2),:);
for i = 1:size(SmoothMergedData,2)
    Cluster{i} = SmoothMergedData(:,i); %Current Clusters (will decrease from 11 to 1)
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
                Variance = mean(mean(Cluster{i},2))/2 + mean(mean(Cluster{j},2))/2;
                Similarity(i,j) = sqrt(sum((mean(Cluster{i},2)-mean(Cluster{j},2)).^2)/Variance); % updating its similarity
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
    
end

% Rearrange the list of the cities
UpdatedCities = [];
NewList = CitiesCluster{1};
for i = 1:length(CitiesCluster{1})
    UpdatedCities = [UpdatedCities, cities(NewList(i))];
end

%% Heatmap
figure(1);
subplot(1,3,KKK)
D = tm(Period(KKK,1):Period(KKK,2));
%D = datetime(2015,1,1) + caldays(0:1:length(SmoothMergedData)-1);
C = categorical(UpdatedCities);

h = heatmap(D,C,UpdatedData')
h.ColorbarVisible = 'off';
grid off
colormap(parula)
title(['Period-', num2str(KKK)])
idx = zeros(1, length(UpdatedData));
idx(1) = 1; idx(end) = 1;
h.XDisplayLabels(~idx) = {''};
s = struct(h);
s.XAxis.TickLabelRotation = 0;  % vertical
caxis([0,6])
xlabel('Date')

%% Heatmap
figure(2);
subplot(1,3,KKK)
plot(D,cumsum(SmoothMergedData),'o','MarkerSize',2)
xlim([D(1), D(end)])
ylabel('Cumulative Cases')
xlabel('Date')
end


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