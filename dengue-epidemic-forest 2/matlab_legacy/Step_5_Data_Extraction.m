%% THIS CODE PROVIDES THE HIERARCICAL CLUSTERING OF THE HEATMAP

clear all;
clc;
close all;

[cities, population, coordinates] = muncity_list();
Period = [[116,319]; [510, 800];[1550, 1796]];
PointPrev = population*(25/100000); %infections identified for 100 over 100000 penduduk

Onset = [];
Cases = [];
for KKK = 1:3
    % Data
    load('SmoothMergedData.mat'); %size [2192 11]
    SmoothMergedData = SmoothMergedData(Period(KKK,1):Period(KKK,2),:);
    SmoothMergedData = cumsum(SmoothMergedData);
    % Onset Data Extraction
    figure;
    OnsetList = [];
    CasesList = [];
    ParList = [];
    for i = 1:length(cities)
        % Richards estimation of cities i
        %% OPTIMISASI
        t = 0:1:size(SmoothMergedData,1)-1;
        lb = [0,0.005,0,0];
        ub = [Inf, Inf, Inf, Inf];
        %filtering
        CumDATA = SmoothMergedData(:,i);
            MaxIter = 1e3;
            SobolBeta = sobolset(4,'Skip',1e3,'Leap',1e2); 
            InitGuess = net(SobolBeta,MaxIter);
            % adjusting domain on K
            InitGuess(:,1) = 2*max(CumDATA)*InitGuess(:,1);
            InitGuess(:,2) = 0.1*InitGuess(:,2);
            InitGuess(:,3) = 1*InitGuess(:,3);
            InitGuess(:,4) = 1000*InitGuess(:,4);    

            % Filtering
            Min_ErrorGuess = CostFunction(InitGuess(1,:),t,CumDATA);
            Min_InitGuess  = InitGuess(1,:);
            for jj = 2 : MaxIter
                Temp_ErrorGuess = CostFunction(InitGuess(jj,:),t,CumDATA);
                Temp_InitGuess    = InitGuess(jj,:);
                if (Temp_ErrorGuess<Min_ErrorGuess)
                    Min_InitGuess = Temp_InitGuess;
                    Min_ErrorGuess = Temp_ErrorGuess;
                end    
            end
        %parameter estimation
        x = fmincon(@(p) CostFunction(p,t,CumDATA),Min_InitGuess,[],[],[],[],lb,ub);
        %generate dynamics
        dyn = DynK(t,x);
        %onset estimator
        idx = (PointPrev(i)*ones(length(t),1)<=dyn');
        cek = 0;
        kk = 1;
        while (cek == 0)
            if (cek == 0)&&(cek+idx(kk)==1)
                onset = cek+ kk-1; 
            end
            if (kk == length(idx))
               onset = Inf;
               cek = 1;
            end
            cek = cek + idx(kk);
            kk = kk + 1;
        end

        subplot(3,4,i)
        hold on
        plot(t, CumDATA,'ro','MarkerSize',3)
        plot(t, dyn,'b','LineWidth',2)
        plot(t, PointPrev(i)*ones(length(t),1),'k--','LineWidth',1.5)
        hold off
        xlim([t(1), t(end)])
        title([cities{i},' (Onset=',num2str(onset),')'],'fontsize',5)

        OnsetList = [OnsetList; onset];
        CasesList = [CasesList; dyn(end)];
        ParList = [ParList; x];
        
    end
  %  suptitle(['Period ', num2str(KKK)])
    Onset = [Onset, OnsetList];
    Cases = [Cases, CasesList];
end

%% Reset the Onset
NormalizedOnset = [];
for i = 1:3
    NormalizedOnset = [NormalizedOnset, Onset(:,i)-min(Onset(:,i))];
end

save('NormalizedOnset.mat','NormalizedOnset')

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

function Error = CostFunction(p,t,DATA)
    Model = DynK(t,p);
    Error = sum((Model'-DATA).^2);
end

function dynamics = DynK(t,p)
C1 = p(1);
C2 = p(2);
C3 = p(3);
C4 = p(4);
dynamics = C1./(1+C2.*exp(-C3.*(t-C4))).^(1./C2);
end