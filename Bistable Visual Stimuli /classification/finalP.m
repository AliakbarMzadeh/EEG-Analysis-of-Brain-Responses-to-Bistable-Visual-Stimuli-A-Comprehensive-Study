
%% loading file
clc;
clear;
close all;
data = load("C:\Users\Asus\Desktop\CI_PROJECT_MahdiSiami_98104274\CI_Project_data.mat");
traindata = data.TrainData;
testdata = data.TestData;
trainlabel = data.TrainLabel;

[numofchannels, numofsamples, numoftrials] = size(traindata);
for i = 1 : numoftrials
    if(trainlabel(i) == 2)
        trainlabel(i) = 0;
    end
end
save('trainlabel.mat');

%% Average feature 

for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    % Average feature of each trial
    for i = 1: numoftrials
        average(c, i) = sum(x(i, :)) / numofsamples;
    end
    
    [average , meanaverage , stdaverage] = normalize(average);    % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(average(c, :)) / length(average));
    mu1 = (sum(average(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(average(c, indexclass2)) / length(indexclass2));
    sigma1 = var(average(c, indexclass1));
    sigma2 = var(average(c, indexclass2));
    average_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%average = normalize(average);
disp(['Fisher factor for best average = ', num2str(max(average_J)), ' for channel = ', num2str(find(average_J == max(average_J)))]);
J_mat = average_J;
featuremat = average;
%% Variance feature
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    % Variance feature of each trial
    for i = 1: numoftrials
        variance(c, i) = var(x(i,:));
    end
    
    [variance, meanvariance , stdvariance] = normalize(variance);    % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(variance(c, :)) / length(variance));
    mu1 = (sum(variance(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(variance(c, indexclass2)) / length(indexclass2));
    sigma1 = var(variance(c, indexclass1));
    sigma2 = var(variance(c, indexclass2));
    variance_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%variance = normalize(variance);
disp(['Fisher factor for best variance = ', num2str(max(variance_J)), ' for channel = ', num2str(find(variance_J == max(variance_J)))]);
J_mat = [J_mat; variance_J];
featuremat = [featuremat ; variance];
%% skewness feature
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    % skewness feature of each trial
    for i = 1: numoftrials
        Skewness(c, i) = skewness(x(i,:));
    end
    
    [Skewness, meanSkewness , stdSkewness] = normalize(Skewness);   % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(Skewness(c, :)) / length(Skewness));
    mu1 = (sum(Skewness(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(Skewness(c, indexclass2)) / length(indexclass2));
    sigma1 = var(Skewness(c, indexclass1));
    sigma2 = var(Skewness(c, indexclass2));
    Skewness_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%Skewness = normalize(Skewness);
disp(['Fisher factor for best Skewness = ', num2str(max(Skewness_J)), ' for channel = ', num2str(find(Skewness_J == max(Skewness_J)))]);
J_mat = [J_mat; Skewness_J];
featuremat = [featuremat ; Skewness];
%% Entropy feature
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    % Entropy feature of each trial
    for i = 1: numoftrials
        Entropy(c, i) = entropy(x(i,:));
    end
    
    [Entropy , meanEntropy , stdEntropy] = normalize(Entropy);   % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(Entropy(c, :)) / length(Entropy));
    mu1 = (sum(Entropy(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(Entropy(c, indexclass2)) / length(indexclass2));
    sigma1 = var(Entropy(c, indexclass1));
    sigma2 = var(Entropy(c, indexclass2));
    Entropy_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%Entropy = normalize(Entropy);
disp(['Fisher factor for best Entropy = ', num2str(max(Entropy_J)), ' for channel = ', num2str(find(Entropy_J == max(Entropy_J)))]);
J_mat = [J_mat; Entropy_J];
featuremat = [featuremat ; Entropy];
%% Medium Frequency feature(estimates the median normalized frequency, freq, of the power spectrum of a time-domain signal)
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    % Medium Frequency feature of each trial
    for i = 1: numoftrials
        Medfreq(c, i) = medfreq(x(i,:));
    end
    
    [Medfreq , meanMedfreq , stdMedfreq] = normalize(Medfreq);   % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(Medfreq(c, :)) / length(Medfreq));
    mu1 = (sum(Medfreq(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(Medfreq(c, indexclass2)) / length(indexclass2));
    sigma1 = var(Medfreq(c, indexclass1));
    sigma2 = var(Medfreq(c, indexclass2));
    Medfreq_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%Medfreq = normalize(Medfreq);
disp(['Fisher factor for best Medfreq = ', num2str(max(Medfreq_J)), ' for channel = ', num2str(find(Medfreq_J == max(Medfreq_J)))]);
J_mat = [J_mat; Medfreq_J];
featuremat = [featuremat ; Medfreq];
%% Mean Frequency feature(estimates the mean normalized frequency, freq, of the power spectrum of a time-domain signal)
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    %  Mean Frequency feature of each trial
    for i = 1: numoftrials
        Meanfreq(c, i) = meanfreq(x(i,:));
    end
    
    [Meanfreq , meanMeanfreq , stdMeanfreq] = normalize(Meanfreq);   % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(Meanfreq(c, :)) / length(Meanfreq));
    mu1 = (sum(Meanfreq(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(Meanfreq(c, indexclass2)) / length(indexclass2));
    sigma1 = var(Meanfreq(c, indexclass1));
    sigma2 = var(Meanfreq(c, indexclass2));
    Meanfreq_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%Meanfreq = normalize(Meanfreq);
disp(['Fisher factor for best Meanfreq = ', num2str(max(Meanfreq_J)), ' for channel = ', num2str(find(Meanfreq_J == max(Meanfreq_J)))]);
J_mat = [J_mat; Meanfreq_J];
featuremat = [featuremat ; Meanfreq];
%%  Band Power feature (average power in the input signal)
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    %  Band Power feature of each trial
    for i = 1: numoftrials
        Bandpower(c, i) = bandpower(x(i,:));
    end
    
    [Bandpower , meanBandpower , stdBandpower] = normalize(Bandpower);    % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(Bandpower(c, :)) / length(Bandpower));
    mu1 = (sum(Bandpower(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(Bandpower(c, indexclass2)) / length(indexclass2));
    sigma1 = var(Bandpower(c, indexclass1));
    sigma2 = var(Bandpower(c, indexclass2));
    Bandpower_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%Bandpower = normalize(Bandpower);
disp(['Fisher factor for best Bandpower = ', num2str(max(Bandpower_J)), ' for channel = ', num2str(find(Bandpower_J == max(Bandpower_J)))]);
J_mat = [J_mat; Bandpower_J];
featuremat = [featuremat ; Bandpower];
%% Occupied Bandwidth feature (99 Percent Bandwidth)
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    %  Occupied Bandwidth feature of each trial
    for i = 1: numoftrials
        Obw(c, i) = obw(x(i,:));
    end
    
    [Obw , meanObw , stdObw] = normalize(Obw);   % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(Obw(c, :)) / length(Obw));
    mu1 = (sum(Obw(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(Obw(c, indexclass2)) / length(indexclass2));
    sigma1 = var(Obw(c, indexclass1));
    sigma2 = var(Obw(c, indexclass2));
    Obw_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%Obw = normalize(Obw);
disp(['Fisher factor for best Occupied Bandwidth = ', num2str(max(Obw_J)), ' for channel = ', num2str(find(Obw_J == max(Obw_J)))]);
J_mat = [J_mat; Obw_J];
featuremat = [featuremat ; Obw];
%% Maximum Power Frequency feature 
Fs = 256;  % sampling rate
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    %  Maximum Power Frequency feature of each trial
    for i = 1: numoftrials
        m = x(i, :);
        n = length(m);
        y = fftshift(fft(m));
        f = ((-n/2) : ((n/2)-1)) * (Fs / n);       % making frequency range 0-centered
        power = ((abs(y).^2)/n);                   % making power 0-centered
        index = find(power == max(power));
        Maxpowerfreq(c, i) = index(end);
    end
    
    [Maxpowerfreq , meanMaxpowerfreq , stdMaxpowerfreq] = normalize(Maxpowerfreq);   % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(Maxpowerfreq(c, :)) / length(Maxpowerfreq));
    mu1 = (sum(Maxpowerfreq(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(Maxpowerfreq(c, indexclass2)) / length(indexclass2));
    sigma1 = var(Maxpowerfreq(c, indexclass1));
    sigma2 = var(Maxpowerfreq(c, indexclass2));
    Maxpowerfreq_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%Maxpowerfreq = normalize(Maxpowerfreq);
disp(['Fisher factor for best Maxpowerfreq = ', num2str(max(Maxpowerfreq_J)), ' for channel = ', num2str(find(Maxpowerfreq_J == max(Maxpowerfreq_J)))]);
J_mat = [J_mat; Maxpowerfreq_J];
featuremat = [featuremat ; Maxpowerfreq];
%% AR feature 
%{
for c = 1 : numofchannels
    
    % data of each channel
    x = traindata(c , : , :);
    x = transpose(squeeze(x));
    
    %  AR feature of each trial
    for i = 1: numoftrials
        AR(c,: , i) = aryule(x(i,:) , 5);
    end
    
    AR = normalize(AR);   % normalizing feature
    
    % calculating fisher factor for feature
    indexclass1 = find(trainlabel == 1);
    indexclass2 = find(trainlabel == 0);
    mu0 = (sum(AR(c, :)) / length(AR));
    mu1 = (sum(AR(c, indexclass1)) / length(indexclass1));
    mu2 = (sum(AR(c, indexclass2)) / length(indexclass2));
    sigma1 = var(AR(c, indexclass1));
    sigma2 = var(AR(c, indexclass2));
    AR_J(c) = ((mu0 - mu1)^2 + (mu0 - mu2)^2) / (sigma1 + sigma2);     
end
%AR = normalize(AR);
disp(['Fisher factor for best AR = ', num2str(max(AR_J)), ' for channel = ', num2str(find(AR_J == max(AR_J)))]);
J_mat = [J_mat; AR_J];
featuremat = [featuremat ; AR];
%}
%% Best feature for each channel

disp('------------ Now we show best feature for each channel ------------');
for i = 1 : numofchannels
    bests(i) = find(J_mat(:, i) == max(J_mat(:, i)));
    disp(['The best feature for channel ', num2str(i), ' is ', featurestring(bests(i)), ', The fisher factor is ', num2str(max(J_mat(:, i)))]);
end
%% Sorted features

[sorted , ind] = sort(J_mat) ;

%% Finding Best group of features
%clc;
disp('------------ Now we try to find best group of features ------------');

% some examples of group of features 
features1 = transpose([Meanfreq(18, :); Medfreq(18, :); Entropy(10, :)]);
features2 = transpose([Meanfreq(14, :); variance(15, :); Bandpower(15, :)]);
features3 = transpose([Meanfreq(18, :); Maxpowerfreq(6, :); Bandpower(10, :)]);
features4 = transpose([Meanfreq(1, :); Skewness(2, :); variance(3, :); Meanfreq(4, :); Meanfreq(5, :); Meanfreq(6, :) ; Entropy(10, :)]);
features5 = transpose([Meanfreq(18, :); Meanfreq(19, :); Meanfreq(20, :); Meanfreq(5, :); Entropy(10, :) ; Medfreq(18, :) ;  Meanfreq(6, :); Meanfreq(10, :)]);
features6 = transpose([Meanfreq(5, :); Meanfreq(6, :); Meanfreq(10, :); Meanfreq(18, :); Meanfreq(19, :); Entropy(10, :)]);

nt = 800;
% this loop is for chooosing number of features and calculating J of group
% of them so we can search for the best group of features
%{
for i = 1 : nt
    numofselectedfeatures = 3 + randi(50);
    features = [];
    featuresind = [];
    for j = 1 : numofselectedfeatures
        f = randi(9);
        c = randi(30);
        %features = [features ; featuremat(f , c)];
        featuresind = cat(1,featuresind ,[f,c]);
        if(f == 1)
            features = [features ; average(c , :)];
        elseif(f == 2)
            features = [features ; variance(c , :)];
        elseif(f == 3)
            features = [features ; Skewness(c , :)];
        elseif(f == 4) 
            features = [features ; Entropy(c , :)];
        elseif(f == 5) 
            features = [features ; Medfreq(c , :)];
        elseif(f == 6)
            features = [features ; Meanfreq(c , :)];
        elseif(f == 7)
            features = [features ; Bandpower(c , :)];
        elseif(f == 8)
            features = [features ; Obw(c , :)];
        elseif(f == 9)    
            features = [features ; Maxpowerfreq(c , :)];
        end
    end
    if (groupfisher(transpose(features) , trainlabel) > 0.01)
        featuresind
        disp(['This group has ' num2str(numofselectedfeatures) ,' features with J factor of ',num2str(groupfisher(transpose(features) , trainlabel))]);
    end
    %disp(['This group has ' num2str(numofselectedfeatures) ,' features with J factor of ',num2str(groupfisher(transpose(features) , trainlabel))]);
    %groupfisher(transpose(features) , trainlabel)
end
%}
% in this loop we realized 1 to 6 features are good and features should
% mostly choose from Meanfreq , Entropy , Entropy , variance and we search
% for the best group from these features
for i = 1 : nt
    numofselectedfeatures = randi(50);
    features = [];
    featuresind = [];
    for j = 1 : numofselectedfeatures
        f = randi(4);
        c = randi(30);
        %features = [features ; featuremat(f , c)];
        featuresind = cat(1,featuresind ,[f,c]);
        if(f == 1)
            features = [features ; variance(c , :)];
        elseif(f == 2)
            features = [features ; Entropy(c , :)];
        elseif(f == 3)
            features = [features ; Meanfreq(c , :)];
        elseif(f == 4)
            features = [features ; Medfreq(c , :)];
        end
    end
    if (groupfisher(transpose(features) , trainlabel) > 0.02)
        featuresind
        disp(['This group has ' num2str(numofselectedfeatures) ,' features with J factor of ',num2str(groupfisher(transpose(features) , trainlabel))]);
    end
    %disp(['This group has ' num2str(numofselectedfeatures) ,' features with J factor of ',num2str(groupfisher(transpose(features) , trainlabel))]);
    %groupfisher(transpose(features) , trainlabel)
end

%% chosen group of features
cf = ([Meanfreq(5, :); Meanfreq(6, :); Meanfreq(10, :); Meanfreq(18, :); Meanfreq(19, :); Entropy(10, :)]);
chosen_J = groupfisher(transpose(cf) , trainlabel)
%% features for test data 

% data of each channel
[numofchannelst, numofsamplest, numoftrialst] = size(testdata);
for c = 1 : numofchannelst
    T = testdata(c , : , :);
    T = transpose(squeeze(T));

% features of each trial
    for i = 1: numoftrialst
        averageT(c, i) = sum(T(i, :)) / numofsamplest;
        varianceT(c, i) = var(T(i,:));
        SkewnessT(c, i) = skewness(T(i, :));
        EntropyT(c, i) = entropy(T(i, :));
        MedfreqT(c, i) = medfreq(T(i, :));
        MeanfreqT(c, i) = meanfreq(T(i, :));
        BandpowerT(c, i) = bandpower(T(i, :));
        ObwT(c, i) = obw(T(i,:));
        mT = T(i, :);
        nT = length(mT);
        yT = fftshift(fft(mT));
        fT = ((-nT/2) : ((nT/2)-1)) * (Fs / nT);       % making frequency range 0-centered
        powerT = ((abs(yT).^2)/nT);                   % making power 0-centered
        indexT = find(powerT == max(powerT));
        MaxpowerfreqT(c, i) = indexT(end);
    end
end
averageT = normalizedT(averageT , meanaverage , stdaverage );
varianceT = normalizedT(varianceT , meanvariance , stdvariance );
SkewnessT = normalizedT(SkewnessT , meanSkewness , stdSkewness );
EntropyT = normalizedT(EntropyT , meanEntropy , stdEntropy );
MedfreqT = normalizedT(MedfreqT , meanMedfreq , stdMedfreq );
MeanfreqT = normalizedT(MeanfreqT , meanMeanfreq , stdMeanfreq );
BandpowerT = normalizedT(BandpowerT , meanBandpower , stdBandpower);
ObwT = normalizedT(ObwT , meanObw , stdObw);
MaxpowerfreqT = normalizedT(MaxpowerfreqT , meanMaxpowerfreq , stdMaxpowerfreq);
%% chosen features for test data
cfT = ([MeanfreqT(5, :); MeanfreqT(6, :); MeanfreqT(10, :); MeanfreqT(18, :); MeanfreqT(19, :); EntropyT(10, :)]);
%% MLP Network
%clc;
mlpnet = 0;
activationfunc = ["tansig", "hardlims" ,"satlin" , "purelin", "radbas", "logsig"];
mlpbestaccuracy = -inf;
% a loop for best activtion fuction
for i = 1 : length(activationfunc)
    
    % a loop for best number of neurons in one hidden layers 
    for numofneurons = 10 : 30
        mlpaccuracy = 0;
        % 5 fold cross validation 
        for k = 1:5
            % indicing
            trainind = [ 1 : ((k-1) * 24) , (k * 24 + 1) : 120 ];
            validind = ((k-1)* 24 + 1) : (k * 24) ;
            
            mlptrain = cf(: , trainind);
            mlpvalid = cf(: , validind);
            mlptrainlabel = trainlabel(trainind);
            mlpvalidlabel = trainlabel(validind);
            
            
            % network
            mlpnet = patternnet(numofneurons);
            % activation function
            activation_function_string = convertStringsToChars(activationfunc(i));
            mlpnet.layers{2}.transferFcn =  activation_function_string;
            mlpnet = train(mlpnet , mlptrain , mlptrainlabel);
            
            
            predictedvalidlabel = mlpnet(mlpvalid);
            thereshold = 0.5;
            predictedvalidlabel = predictedvalidlabel >= thereshold;
  
            mlpaccuracy = mlpaccuracy + length(find(predictedvalidlabel == mlpvalidlabel)) ;
        end
        if (mlpaccuracy >= mlpbestaccuracy)
            mlpbestaccuracy = mlpaccuracy;
            mlptestlabelofnet = mlpnet(cfT);
            mlptestlabelofnet = (mlptestlabelofnet >= thereshold);
            
        end
        mlpaccuracymatrix(numofneurons) = mlpaccuracy / 120;
    end
    bestnumofneurons = find(mlpaccuracymatrix == max(mlpaccuracymatrix));
    disp(['Best Number of Neurons in MLP with actvation function ', activation_function_string, ' is to ', num2str(bestnumofneurons), ', Accuracy = ', num2str(mlpaccuracymatrix(bestnumofneurons))]);
end
%% RBF
%clc;

goal = 0 ;
maxspread = 10;
maxMN = 40;
%DF = ;
rbfaccuracymat = [];
rbfbestaccuracy = -inf;
for spread = 1 : maxspread
    for MN = 1 : maxMN
        rbfaccuracy = 0;
        for i = 1 : 5
            % indicing
            rbftrainind = [ 1 : ((k-1) * 24) , (k * 24 + 1) : 120 ];
            rbfvalidind = ((k-1)* 24 + 1) : (k * 24) ;
            
            rbftrain = cf(: , rbftrainind);
            rbfvalid = cf(: , rbfvalidind);
            rbftrainlabel = trainlabel(rbftrainind);
            rbfvalidlabel = trainlabel(rbfvalidind);
            
            evalc('netrbf = newrb(rbftrain, rbftrainlabel, goal, spread, MN)');
            %netrbf.performFcn = 'crossentropy';
            rbfpredictedvalidlabel = sim(netrbf,rbfvalid);
            rbfthereshold = 0.5;
            rbfpredictedvalidlabel = (rbfpredictedvalidlabel >= rbfthereshold);
            rbfaccuracy = rbfaccuracy + length(find(rbfpredictedvalidlabel == rbfvalidlabel)) ;
        end
        if(rbfaccuracy >= rbfbestaccuracy)
            rbfbestaccuracy = rbfaccuracy;
            rbftestlabelofnet = sim(netrbf,cfT);
            rbftestlabelofnet = (rbftestlabelofnet >= rbfthereshold);
        end
        
         rbfaccuracymat(spread , MN ) = rbfaccuracy / 120 ;       
    end
end
maximum = max(max(rbfaccuracymat));
[numofrbfhiddenneurons , radius] = find(rbfaccuracymat == maximum);
disp(['Best Number of Neurons in RBF = ', num2str(numofrbfhiddenneurons(1)), ', Radius = ', num2str(radius(1)) ', Accuracy = ', num2str(maximum(1))]);

%% Saving Phase 1 Result
save('mlptestlabelofnet.mat');
save('rbftestlabelofnet.mat');

dismatch_indexes = find(mlptestlabelofnet ~= rbftestlabelofnet);
disp('Predict Labels of two netwporks are not equal in these indexes :');
disp(dismatch_indexes);
%% phase 2
%clc
%%
%clc;
% Selecting top 30 features from fisher matrix
J_mat_reshaped = reshape(J_mat, [1, 270]);
J_mat_reshapesorted = sort(J_mat_reshaped);
topfishervalues = J_mat_reshapesorted(end - 29 : end);

% finding the corresponding features and values
for i = 1:30
    [featureindex(i), channel(i)] = find(J_mat == topfishervalues(i));
end
gafeat = [];
testgafeat = [];
for i = 1 : 30
    featurestringmat = featurestring(featureindex(i));
    
    if (featurestringmat == "Average")
        gafeat = [gafeat ;average(channel(i), :);] 
        testgafeat =  [testgafeat ;averageT(channel(i), :)];
    end
    
    if (featurestringmat == "Variance")
        gafeat = [gafeat ; variance(channel(i), :)]; 
        testgafeat =  [testgafeat ;varianceT(channel(i), :)];
    end
    
    if (featurestringmat == "Skewness")
        gafeat = [gafeat ;Skewness(channel(i), :)];
        testgafeat =  [testgafeat ;SkewnessT(channel(i), :)];
    end
    
    if (featurestringmat == "Entropy")
        gafeat = [gafeat ;Entropy(channel(i), :)]; 
        testgafeat =  [testgafeat ;EntropyT(channel(i), :)];
    end
    
    if (featurestringmat == "Medfreq")
        gafeat = [gafeat  ;Medfreq(channel(i), :)]; 
        testgafeat =  [testgafeat ;MedfreqT(channel(i), :)];
    end
    
    if (featurestringmat == "Meanfreq")
        gafeat = [gafeat ; Meanfreq(channel(i), :)]; 
        testgafeat =  [testgafeat ;MeanfreqT(channel(i), :)];
    end
    
    if (featurestringmat == "Bandpower")
        gafeat = [gafeat ; Bandpower(channel(i), :)];
        testgafeat =  [testgafeat ;BandpowerT(channel(i), :)];
    end
    
    if (featurestringmat == "Occupied Bandwidth")
        gafeat = [gafeat ; Obw(channel(i), :)]; 
        testgafeat =  [testgafeat ;ObwT(channel(i), :)];
    end
    
    if (featurestringmat == "Maxpowerfreq")
        gafeat = [gafeat ; maxPowerFrequency(channel(i), :)]; 
        testgafeat =  [testgafeat ;maxPowerFrequencyT(channel(i), :)];
    end
     
end
save('gafeat.mat');
jjjj = ga( @bestTimeFeature  , 30 , [ones(1 , 30) ; (-ones(1 , 30))] , [6 ; -6]  , [] , [] , zeros(1 , 30) , ones(1,30) , [] , (1:30) );
%ga(@groupfisher2,100,[ones(1,100);-ones(1,100)],[i,-i],[],[],zeros(1,100),ones(1,100),[],1:100);
%[result, fval] = ga(@groupfisher2,20,[],[],ones(1,20),10,zeros(1,20),ones(1,20),[],1:20);

%%
cf2 = [];
cfT2 = [];
for i = 1 : length(jjjj)
    if(jjjj(i) == 1)
        cf2 = [cf2 ; gafeat(i , :)];
        cfT2 = [cfT2 ; testgafeat(i , :)];
    end
end
%% MLP Network phase 2
%clc;
mlpnet2 = 0;
activationfunc2 = ["tansig", "hardlims" ,"satlin" , "purelin", "radbas", "logsig"];
mlpbestaccuracy2 = -inf;
% a loop for best activtion fuction
for i = 1 : length(activationfunc2)
    
    % a loop for best number of neurons in one hidden layers 
    for numofneurons2 = 10 : 30
        mlpaccuracy2 = 0;
        % 5 fold cross validation 
        for k = 1:5
            % indicing
            trainind = [ 1 : ((k-1) * 24) , (k * 24 + 1) : 120 ];
            validind = ((k-1)* 24 + 1) : (k * 24) ;
            
            mlptrain2 = cf2(: , trainind);
            mlpvalid2 = cf2(: , validind);
            mlptrainlabel2 = trainlabel(trainind);
            mlpvalidlabel2 = trainlabel(validind);
            
            
            % network
            mlpnet2 = patternnet(numofneurons2);
            % activation function
            activation_function_string2 = convertStringsToChars(activationfunc2(i));
            mlpnet2.layers{2}.transferFcn =  activation_function_string2;
            mlpnet2 = train(mlpnet2 , mlptrain2 , mlptrainlabel2);
            
            
            predictedvalidlabel2 = mlpnet2(mlpvalid2);
            thereshold2 = 0.5;
            predictedvalidlabel2 = predictedvalidlabel2 >= thereshold2;
  
            mlpaccuracy2 = mlpaccuracy2 + length(find(predictedvalidlabel2 == mlpvalidlabel2)) ;
        end
        if (mlpaccuracy2 >= mlpbestaccuracy2)
            mlpbestaccuracy2 = mlpaccuracy2;
            mlptestlabelofnet2 = mlpnet2(cfT2);
            mlptestlabelofnet2 = (mlptestlabelofnet2 >= thereshold2);
            
        end
        mlpaccuracymatrix2(numofneurons2) = mlpaccuracy2 / 120;
    end
    bestnumofneurons2 = find(mlpaccuracymatrix2 == max(mlpaccuracymatrix2));
    disp(['Phase2 : Best Number of Neurons in MLP with actvation function ', activation_function_string2, ' is to ', num2str(bestnumofneurons2), ', Accuracy = ', num2str(mlpaccuracymatrix2(bestnumofneurons2))]);
end


%% RBF phase2
%clc;

goal2 = 0 ;
maxspread2 = 10;
maxMN2 = 40;
%DF = ;
rbfaccuracymat2 = [];
rbfbestaccuracy2 = -inf;
for spread = 1 : maxspread2
    for MN = 1 : maxMN2
        rbfaccuracy2 = 0;
        for i = 1 : 5
            % indicing
            rbftrainind = [ 1 : ((k-1) * 24) , (k * 24 + 1) : 120 ];
            rbfvalidind = ((k-1)* 24 + 1) : (k * 24) ;
            
            rbftrain2 = cf2(: , rbftrainind);
            rbfvalid2 = cf2(: , rbfvalidind);
            rbftrainlabel2 = trainlabel(rbftrainind);
            rbfvalidlabel2 = trainlabel(rbfvalidind);
            
            evalc('netrbf2 = newrb(rbftrain2, rbftrainlabel2, goal2, spread, MN)');
            %netrbf.performFcn = 'crossentropy';
            rbfpredictedvalidlabel2 = sim(netrbf2,rbfvalid2);
            rbfthereshold2 = 0.5;
            rbfpredictedvalidlabel2 = (rbfpredictedvalidlabel2 >= rbfthereshold2);
            rbfaccuracy2 = rbfaccuracy2 + length(find(rbfpredictedvalidlabel2 == rbfvalidlabel2)) ;
        end
        if(rbfaccuracy2 >= rbfbestaccuracy2)
            rbfbestaccuracy2 = rbfaccuracy2;
            rbftestlabelofnet2 = sim(netrbf2,cfT2);
            rbftestlabelofnet2 = (rbftestlabelofnet2 >= rbfthereshold2);
        end
        
         rbfaccuracymat2(spread , MN ) = rbfaccuracy2 / 120 ;       
    end
end
maximum2 = max(max(rbfaccuracymat2));
[numofrbfhiddenneurons2 , radius2] = find(rbfaccuracymat2 == maximum2);
disp(['Phase2 : Best Number of Neurons in RBF = ', num2str(numofrbfhiddenneurons2(1)), ', Radius = ', num2str(radius2(1)) ', Accuracy = ', num2str(maximum2(1))]);

%% Saving Phase 1 Result
save('mlptestlabelofnet2.mat');
save('rbftestlabelofnet2.mat');

dismatch_indexes2 = find(mlptestlabelofnet2 ~= rbftestlabelofnet2);
disp('Predict Labels of two netwporks are not equal in these indexes :');
disp(dismatch_indexes2);


%% output
mlptestlabelofnet = double(mlptestlabelofnet);
mlptestlabelofnet2 = double(mlptestlabelofnet2);
rbftestlabelofnet = double(rbftestlabelofnet);
rbftestlabelofnet2 = double(rbftestlabelofnet2);
for i = 1 : 40
    if(mlptestlabelofnet(i) == 0)
        mlptestlabelofnet(i) = 2;
    end
    if(mlptestlabelofnet2(i) == 0)
        mlptestlabelofnet2(i) = 2;
    end
    if(rbftestlabelofnet(i) == 0)
        rbftestlabelofnet(i) = 2;
    end
    if(rbftestlabelofnet2(i) == 0)
        rbftestlabelofnet2(i) = 2;
    end
end
save('mlptestlabelofnet.mat');
save('rbftestlabelofnet.mat');
save('mlptestlabelofnet2.mat');
save('rbftestlabelofnet2.mat');
%% Functions 
function [normalized, mean , STD] = normalize(input)
    [l1, l2] = size(input);
    for i = 1: l1
        mean = sum(input(i, :)) / l2;
        STD = std(input(i, :));
        normalized(i, :) = (input(i, :) - mean) / STD;
    end   
end

function [s] = featurestring(input)
    if (input == 1)
        s = 'Average';
    end

    if (input == 2)
        s = 'Variance';
    end

    if (input == 3)
        s = 'Skewness';
    end

    if (input == 4)
        s = 'Entropy';
    end

    if (input == 5)
        s = 'Medfreq';
    end

    if (input == 6)
        s = 'Meanfreq';
    end

    if (input == 7)
        s = 'Bandpower';
    end

    if (input == 8)
        s = 'Occupied Bandwidth';
    end

    if (input == 9)
        s = 'Maxpowerfreq';
    end
    %{
    if (input == 10)
        s = 'AR';
    end
    %}
end    

function [J] = groupfisher( features , trainlabel )
indexclass1 = find(trainlabel == 1);
indexclass2 = find(trainlabel == 0);
N1 = length(find(trainlabel == 1));
N2 = length(find(trainlabel == 0));
mu1 = sum(features(indexclass1, :)) / N1;
mu2 = sum(features(indexclass2, :)) / N2;
mu0 = sum(features) / (N1 + N2);   
[l1 , l2] = size(features);
s1 = zeros(l2);
for i = indexclass1
    s1 = s1 + (features(i, :) - mu1) * transpose(features(i, :) - mu1);
end
s1 = s1 / N1;

s2 = zeros(l2);
for i = indexclass2
    s2 = s2 + (features(i, :) - mu2) * transpose(features(i, :) - mu2);
end
s2 = s2 / N2;

Sw = s1 + s2;
Sb = (mu1 - mu0) * transpose(mu1 - mu0) + (mu2 - mu0) * transpose(mu2 - mu0);
J = (trace(Sb)/trace(Sw));
%J = det(Sb)/det(Sw);
%J = trace((Sb^(-1))*Sw);
end

function [normalized] = normalizedT(input , mean , STD)
    [l1, l2] = size(input);
    for i = 1: l1
        normalized(i, :) = (input(i, :) - mean) / STD;
    end   
end

function [J] = groupfisher2( xx )
load trainlabel.mat;
load gafeat.mat;
features = [];
for i = 1 : length(xx)
    if(xx(i) == 1)
        features = [features : gafeat(i)];
    end
end
features
indexclass1 = find(trainlabel == 1);
indexclass2 = find(trainlabel == 0);
N1 = length(find(trainlabel == 1));
N2 = length(find(trainlabel == 0));
mu1 = sum(features(indexclass1, :)) / N1;
mu2 = sum(features(indexclass2, :)) / N2;
mu0 = sum(features) / (N1 + N2);   
[l1 , l2] = size(features);
s1 = zeros(l2);
for i = indexclass1
    s1 = s1 + (features(i, :) - mu1) * transpose(features(i, :) - mu1);
end
s1 = s1 / N1;

s2 = zeros(l2);
for i = indexclass2
    s2 = s2 + (features(i, :) - mu2) * transpose(features(i, :) - mu2);
end
s2 = s2 / N2;

Sw = s1 + s2;
Sb = (mu1 - mu0) * transpose(mu1 - mu0) + (mu2 - mu0) * transpose(mu2 - mu0);
J = -(trace(Sb)/trace(Sw));
%J = det(Sb)/det(Sw);
%J = trace((Sb^(-1))*Sw);
end

function [J] = bestTimeFeature(x)

load gafeat.mat;
load trainlabel.mat;

TrainLabel = trainlabel;
matrix=gafeat;
% for converting integer vector x to logical vector we assing x equal to 1
%(x==1)
C1mat=matrix(x==1,TrainLabel==1);
C2mat=matrix(x==1,TrainLabel==2);
mhu1=mean(C1mat,2);
mhu2=mean(C1mat,2);
mhu0=mean(matrix(x==1,:),2);
S1=(1/size(C1mat,2))*(C1mat-mhu1)*(C1mat-mhu1)';
S2=(1/size(C2mat,2))*(C2mat-mhu2)*(C2mat-mhu2)';
Sw=S1+S2;
mhu=[mhu1-mhu0 mhu2-mhu0];
Sb=mhu*mhu';
%J=-trace(Sw^-1*Sb);
J = -(trace(Sb)/trace(Sw));
end