%% THIS CODE PRODUCES THE TIME-SERIES DATA OF CASES FOR EACH REGIONS IN THE NORTHERN COTABATO
%% SHOULD BE NOTED THAT THIS CODE RUNS SEMI-MANUALLY (HAS TO BE RUN FOR EACH YEAR)
%% THE RELATED CODE IS: 

clear all;
close all;
clc;

%% DATA

YYear = [2018, 2019, 2020];

for KKKKK = 1:length(YYear)
    [cities, population, coordinates] = muncity_list();
    [num,txt,raw] = xlsread('South_Cotabato_General Santos.xlsx',num2str(YYear(KKKKK)));

    %% DATA CLEANING
    DataCity = raw(2:end,2);
    DataOnset = raw(2:end,5);
    DaiyMat = zeros(365, length(cities));

    if YYear(KKKKK) == 2015
        RefDate = datetime(2015,1,1) + caldays(0:1:364); %2015
    elseif YYear(KKKKK) == 2016
        RefDate = datetime(2016,1,1) + caldays(0:1:365); %2016
    elseif YYear(KKKKK) == 2017
        RefDate = datetime(2017,1,1) + caldays(0:1:364); %2017
    elseif YYear(KKKKK) == 2018
        RefDate = datetime(2018,1,1) + caldays(0:1:364); %2018
    elseif YYear(KKKKK) == 2019
        RefDate = datetime(2019,1,1) + caldays(0:1:364); %2019
    else
        RefDate = datetime(2020,1,1) + caldays(0:1:365); %2020
    end


    for j = 1:length(cities)
       cities{j}
       for i = 1:length(RefDate)
          temp = [];
          for kk = 1:length(DataOnset)
              if strcmp(cities{j}, DataCity{kk})==1
                  temp = [temp; isequal(datetime(DataOnset{kk},'InputFormat','dd/MM/yyyy'), RefDate(i))];
              end
          end
          DaiyMat(i,j) = sum(temp); 
       end
    end

    %% SAVE
    filename = ['DailyMat', num2str(YYear(KKKKK)), '.mat'];
    save(filename,'DaiyMat')

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