%% Goal

% Step 1 - simulate neural activity
% Step 2 - simulate fMRI data - convolve with hrf
% Step 3 - add noise
% Step 4 - build a model 
% Step 5 - solve for beta

% This script is inspired by the code used in David Heeger's fMRI course at NYU. 
% It's a great way to get started with GLM and fMRI, and I've tweaked it to only cover the basics. 
% Hope it helps you out! 

%% useful functions to try 

% pwd - get current working directory
% clear all - clear all variables in the workspace
% clc - clear command window
% close all - close all open figures
% others:
    %help/doc - type doc doc in command window to learn more
    %repmat
    %repelem
    %mod
    %conv
    %squeeze
    %flip
    %pinv
    %'
    %imagesc/imshow/plot/scatter/hist
    %randn
      
% given any variable 'val'
    % it is always good to check the following things:
        % size and dimension - size(vals)
            % size of the kth dimension - size(vals,k)
        % basic stats - min(vals), max(vals), mean(vals)
            % use vals(:) instead of vals to get the result across all the values in this variable regardless of dimensions
        % distribution - hist(vals)
    % always keep in mind:
        %  what each dimension of my variable means
        %  what does large and small number mean in my variable, what's the range
        
%% step 0 - come up with a fake design

%  let's say, 10 seconds onset with 10 seconds offset, repeat for 1 minutes.

%% step 1 - simulate neural activity
clear all; close all; clc;

expDuration = 60; % experiments lasts 1 minutes - 60 seconds
blockDuration = 10; % each block lasts 10 seconds 
myTime = 1:expDuration; % 1:60, every second of this duration
blockDesign  = repelem([1 0],1,blockDuration); % 10 1s and 10 0s
expDesign  = repmat(blockDesign,1,expDuration/blockDuration/2); % we repeat the blocks many times through out 1 minutes

% for now, this expDesign is as good of a guess to neural activity as we can 
% basically mean neuron spikes at onset of the stimulus
dataNeural = expDesign;

% let's visualize it
figure(1); clf;
plot(dataNeural,'LineWidth',2)
ylim([0,1.1])
ylabel('neural activity (a.u.)')
xlabel('time (secs)');
title('ON and OFF of neural activity')
set(gca,'FontSize',15,'TickDir','out','Linewidth',2,'YTick',[0 0.5 1]);
    
%% step 2 -  simulate fMRI data - convolve with hrf

% real fMRI data are sluggish and not like the sharp on/off shape for the expDesign
% this is because of the HRF (hemodynamic impulse response function)
% we can model it and add it to our neural activity

% there are fancy ways to generate, model, and estimate HRF
% for now,  we will use a budget version -  the gamma function

%% step 2.1 generate hrf 

% we have two knobs (parameters) to set:
tau = 2; % decides shape of the peak
delta =  2; % decides delay after stimulus onset

% make our budget HRF
timeHrf = 0:1:30; % we will get the hrf for 30 seconds
hrf = (max(timeHrf-delta,0)/tau).^2 .* exp(-max(timeHrf-delta,0)/tau) / (2*tau);

figure(2); clf;
plot(timeHrf,hrf,'LineWidth',2);
title('HRF')
ylabel('intensities (a.u.)')
xlabel('time (sec)')
set(gca,'FontSize',15,'TickDir','out','Linewidth',2,'YTick',[0 0.5 1]);

%% step 2.2 generate fmri data 

% now let's transform our on/off neural activity to fmri data with the hrf

datafMRI =  conv(dataNeural,hrf);
datafMRI = datafMRI(1:length(dataNeural)); % chop off extra data generated from the function conv 

figure(3); clf;
plot(datafMRI,'LineWidth',2);
ylim([0,1.1])
title('fMRI signal')
ylabel('intensities (a.u.)')
xlabel('time (sec)')
set(gca,'FontSize',15,'TickDir','out','Linewidth',2,'YTick',[0 0.5 1]);
 
%% step 2.3 add baseline and convert to percentage signal change

% some extra stuff: add a baseline for the fMRI signal and converting it to %signal change

datafMRI = 100 + conv(dataNeural,hrf); % 100 value added as a baseline
datafMRI = datafMRI(1:length(dataNeural)); % chop off extras
datafMRIpercent = 100 * ((datafMRI/(mean(datafMRI)) - 1)); % percentage signal change

figure(4); clf;
plot(datafMRIpercent,'Linewidth',2);

title('fMRI percentage signal change')
ylabel('signal change (%)')
xlabel('time (sec)')
set(gca,'FontSize',15,'TickDir','out','Linewidth',2);
  
%% Step 3 - generate noise

% real data is quite noisy,  let's make some noise for our voxel

noise = 0.05 * randn(size(datafMRI)); % generate noise using randn
dataNoisy = datafMRI + noise; % add noise
dataNoisy = 100 * ((dataNoisy/(mean(dataNoisy)) - 1)); % convert to %signal change

% Plot it
figure(1); clf;
subplot(3,1,1)
plot(noise,'Linewidth',2)
title('noise')
ylabel('intensities (a.u.)')
xlabel('time (sec)')
set(gca,'FontSize',15,'TickDir','out','Linewidth',2);

subplot(3,1,2)
plot(datafMRIpercent,'Linewidth',2);
ylim([-0.6 0.6])
title('fMRI data without noise')
ylabel('signal change (%)')
xlabel('time (sec)')
set(gca,'FontSize',15,'TickDir','out','Linewidth',2);

subplot(3,1,3)
plot(dataNoisy,'Linewidth',2);
ylim([-0.6 0.6])
title('fMRI data with noise')
ylabel('signal change (%)')
xlabel('time (sec)')
set(gca,'FontSize',15,'TickDir','out','Linewidth',2);
% Note that each time you evaluate the above code, you get a somewhat
% different result because of the noise.

%% Step 4 - build a model 

% each column vector you put in the model serves as a regressor or predictor
% model has the size (time by number of regressors)

% first thing you put in should be your expDesign variable, 1s in onset and 0s in offset

% second one should be just 1s, if our experiment lasts 1 minute long, then we need 60 1s
% this is a constant term, like the b in y = mx + b

% the third, fourth, and however many other columns can be anything you believe that contribute to the variance of your data
% most people include a linear drift as fMRI signals tends to get higher as
% time goes on, so in this case 1:60

% another common thing is the global signal and 6 motion regressors and
% their derivatives and squares, you get them from the fMRIPrep output in
% the confound tsv file that we walked through in module 1

model = [expDesign' ones(expDuration,1)];

% model is what you believe the ground truth could be, or at least what you
% can control of, you can throw many things in there, the design matrix of
% your experiment should be the first and core component, the  ones and
% zeros, all the additional columns can be added as you see fit

%% Step 5 - solve for beta

% I advice you to look up that is happenning underneath the formula as the formula is very simple

% do it with pinv matlab function: 
b = pinv(model) * dataNoisy';

% or do it with matrix multiplication  
x = model;
y =  dataNoisy';
beta = (x'*x)^(-1)*x'*y; % this is the solve from OLS (ordinary least square)

% b(1) is the beta weights for our design matrix :)
% beta and b should be exactly same

% how does it work? 

% simply put:  

%   beta describes the linear relationship between our model the real data
%   model = design * beta
%   data = model + noise
%   noise = data - model; % often called as the residual, difference between actual data and the predicted data

%   let's call noise e, data y, design x, and beta b;
%   we have e = y - xb

%   we want to find the b that minimize e - the difference between model and real data
%   more specifically, we are minimizing the sum of squared of the
%   residual since the difference can go both negative and positive, so e'e or (y-xb)'(y-xb); a vector's transpose times itself

%   we then do the derivative d/db (y-xb)'(y-xb) to find the b = (x'*x)^(-1)*x'*y 

%   in matlab, we can imply write b = pinv(x) * y;
                
%% step 6 - try thisw

% simulate more voxels - can be hundreds, can be thousands

% try out different signal to noise level by manipulating this line: noise = 0.05 * randn(size(datafMRI)); 

% try to simulate a voxel that is inactive and doesn't care about the onset of the stimulus, what would their timecourse look like?

% try our different designs, try out event design

% plug in some real data to see 
