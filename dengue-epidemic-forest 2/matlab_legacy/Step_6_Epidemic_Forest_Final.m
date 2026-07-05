clear all;
clc;
close all;

%% INITIALIZATION

pop = readtable('SimulationData.xlsx');
lat = pop.Latitude;
lon = pop.Longitude;
% lon(4) = 125.2;
[cities, population,coordinates] = muncity_list();


popul = pop.Population;
[cities, population,coordinates] = muncity_list();
NumCities = length(cities);
Period = [[116,319]; [510, 800];[1550, 1796]];
idxxx= 0;
for KKK = 1:3
%     if (KKK==4)||(KKK==8)||(KKK==1)||(KKK==5)
        
        
%     else
       
        idxxx = idxxx+1;
% richards cumulative
    load('SmoothMergedData.mat'); %size [2192 18]
    SmoothMergedData = SmoothMergedData(Period(KKK,1):Period(KKK,2),:);
    SmoothMergedData = cumsum(SmoothMergedData);
    DATA = SmoothMergedData;
    tspan = 0:1:size(DATA,1)-1;
    load('NormalizedOnset');
    OnsetList = NormalizedOnset(:,KKK);
    CumSimCities = DATA';

ParentofChildrenIdxLoop = [];
kMax = 5000;

for loopIdx = 1:kMax
% Adjacency matrix
% ConnectivityMatrix = xlsread('Input Data/AdjMatrix.xlsx','B2:AE31'); %%simple graph
%random network
ConnectivityMatrix = zeros(12,12);
alpha = 5;
ProbDis = @(dis) exp(-alpha*dis);
for i = 1:12
    for j = 1:12
        if (i < j)
            randomNum  = rand(1);
            dis = disFun(coordinates(i,:),coordinates(j,:));
%             ProbDis(dis)
            if randomNum < ProbDis(dis)
                ConnectivityMatrix(i,j) = 1;
                ConnectivityMatrix(j,i) = 1;
            end
        end
    end
end
   
    %% LOOPING
    IncubationPeriod = 5; %Incubation period on one infected person
    ChildrenIdx = 1:NumCities; %index of all cities 
    ParentofChildrenIdx = zeros(1,NumCities); %index of parent for each children
    while (length(ChildrenIdx) > 0)
        RandIdx = randi(length(ChildrenIdx)); %pick one random children
    %     RandIdx = 21; %test
        Tc = OnsetList(ChildrenIdx(RandIdx)); %Onset of children
        %Looking for candidates (spatio-filtering)
        [aa, ParentCandidateIdx1] = find(ConnectivityMatrix(ChildrenIdx(RandIdx),:)==1); % spatial filter by considering the connections among cities
        TpCandidate1 = OnsetList(ParentCandidateIdx1); %Onsettime of all parent candidates
        %Looking for (better) candidates (tempo-filtering)
        %Tp should lies in (0, Tc-Ic)
        ParentCandidateIdx2 = ParentCandidateIdx1(find(TpCandidate1<Tc-IncubationPeriod));
        TpCandidate2 = OnsetList(ParentCandidateIdx2);
        %If ParentCandidateIdx2 is empty, then the randomly picked city is a
        %primary case
        if (length(ParentCandidateIdx2)~=0) %Have selected parent candidates
            Sd = mean(disFun(coordinates(ChildrenIdx(RandIdx),:),coordinates(ParentCandidateIdx2,:))); %spasial mean of children to all possible parents
            Td = mean(TpCandidate2 - Tc); %temporal mean of children to all possible parents
            PrevLevel = CumSimCities(ParentCandidateIdx2, Tc);
            Pd = mean(1./PrevLevel); %prevalence mean of children to all possible parents
            SoL = []; % Strength of Linkage
            alpha = 1/3; %spasial weight
            beta = 1/3; %temporal weight
            % [alpha, beta, (1-alpha-beta)]: weighted vectors (v_w)
            % when v_w = [1,0,0]: spatial consideration (only); looking for the
            % nearest neighbor
            % when v_w = [0,1,0]: temporal consideration (only); looking for
            % the shortest temporal distance
            % when v_w = [0,0,1]: prevalence consideration (only); looking for
            % the most infected countries
            % we choose v_w=[1/3,1/3,1/3] so that we are taking every aspect
            % equally
            for kk = 1:length(ParentCandidateIdx2) %calculate the strength of linkage for all candidates
                %SPATIAL
                Ws = disFun(coordinates(ChildrenIdx(RandIdx),:),coordinates(ParentCandidateIdx2(kk),:))/Sd; %normalized spatial
                %TEMPORAL
                Wt = (TpCandidate2(kk) - Tc)/Td;
                %PREVALENCE LEVEL
                Wp = CumSimCities(ParentCandidateIdx2(kk), Tc)/Pd;
                % STRENTGH of LINKAGE
                SoL = [SoL; alpha*Ws + beta*Wt + (1-alpha-beta)*(1/Wp)];
            end
            % Determining the parent with the highest score of SoL
            [aa, bb] = min(SoL);
            ParentofChildrenIdx(ChildrenIdx(RandIdx)) = ParentCandidateIdx2(bb); 
        else
            % DO NOTHING, IT MEANS THE POINT HAS NO PARENT CANDIDATE, THAT WILL
            % BE CONSIDERED AS PRIMARY CITIES
            % Cities that are considered as primary cases will be left its
            % parent to be zeros. Then for every zero values in
            % ParentofChildrenIdx, then its corresponding children index is a
            % primary cases
        end
        ChildrenIdx = ChildrenIdx(ChildrenIdx~=ChildrenIdx(RandIdx));
    end
    %results: ParentofChildrenIdx
    
    ParentofChildrenIdxLoop = [ParentofChildrenIdxLoop; ParentofChildrenIdx];
end
% mode
ParentofChildrenIdx = mode(ParentofChildrenIdxLoop);
% ParentofChildrenIdx = ParentofChildrenIdxLoop;

%% VISUALIZATION

figure;
f = @(x) 6 + 20*(x/max(popul));
g = @(x) 2*x;

onset = OnsetList;
cmap = colormap(hot);
geoplot([lat(1)],[lon(1)],'bo-','MarkerSize',f(popul(1)),'MarkerFaceColor',cmap(round(g(onset(1)))+1,:),'MarkerEdgeColor','k')
    dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points 
    text(lat(1)+dx, lon(1)+dy, cities(1), 'Fontsize', 5); 
alpha 0.2
hold
for i = 2:12
    geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',f(popul(i)),'MarkerFaceColor',cmap(round(g(onset(i)))+1,:),'MarkerEdgeColor','k')
    alpha 0.2
    dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points 
    text(lat(i)+dx, lon(i)+dy, cities(i), 'Fontsize', 5); 
end
for i = 1:length(ParentofChildrenIdx)
    if (ParentofChildrenIdx(i) ~= 0) %WITH PARENTS
        geoplot([lat(i), lat(ParentofChildrenIdx(i))],[lon(i), lon(ParentofChildrenIdx(i))],'r-')
    else
        geoplot([lat(i)],[lon(i)],'bo-','MarkerSize',1.5*f(popul(i)),'MarkerEdgeColor','r')
    end
end




geolimits([min(lat)-0.1,max(lat)+0.2],[min(lon)-0.25,max(lon)+0.25])
geobasemap darkwater
title(['Period ', num2str(KKK)])



%     end
end


%% VISUALIZATION FOR EACH PERIOD











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

function dynamics = DynK(t,p)
C1 = p(1);
C2 = p(2);
C3 = p(3);
C4 = p(4);
dynamics = C1./(1+C2.*exp(-C3.*(t-C4))).^(1./C2);
end

function distance = disFun(a,b)
    % a: children (1x2)
    % b: parent candidate (length(b), 2)
    distance = [];
    for i=1:size(b,1)
        distance = [distance; sqrt((a(1)-b(1))^2+(a(2)-b(2))^2)];
    end
end