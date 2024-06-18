function agent = createTD3Agent(numObs, obsInfo, numAct, actInfo, Ts)
% Walking Robot -- TD3 Agent Setup Script
% Copyright 2024 The MathWorks, Inc.

%% Create the actor and critic networks using the createNetworks helper function
[criticNetwork1,criticNetwork2,actorNetwork] = createNetworks(numObs,numAct); % Use of 2 Critic networks

%% Specify options for the critic and actor representations using rlOptimizerOptions
criticOptions = rlRepresentationOptions('Optimizer','adam','LearnRate',1e-3,... 
                                        'GradientThreshold',1);
actorOptions = rlRepresentationOptions('Optimizer','adam','LearnRate',1e-3,...
                                       'GradientThreshold',1);

%% Create critic and actor representations using specified networks and
% options
critic1 = rlQValueRepresentation(criticNetwork1,obsInfo,actInfo,'Observation',{'observation'},'Action',{'action'},criticOptions);
critic2 = rlQValueRepresentation(criticNetwork2,obsInfo,actInfo,'Observation',{'observation'},'Action',{'action'},criticOptions);
actor  = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'observation'},'Action',{'ActorTanh1'},actorOptions);
% critic1.UseDevice = "gpu";
% critic2.UseDevice = "gpu";
% actor.UseDevice = "gpu";

%% Specify TD3 agent options
agentOptions = rlTD3AgentOptions;
agentOptions.SampleTime = Ts;
agentOptions.DiscountFactor = 0.99;
agentOptions.MiniBatchSize = 256;
agentOptions.ExperienceBufferLength = 1e6;
agentOptions.TargetSmoothFactor = 5e-3;

% agentOptions.NumEpoch = 3;
% agentOptions.MaxMiniBatchPerEpoch = 100;
% agentOptions.LearningFrequency = -1;
agentOptions.PolicyUpdateFrequency = 1;
agentOptions.TargetUpdateFrequency = 1;

% agentOptions.TargetPolicySmoothModel.StandardDeviationMin = 0.05; % target policy noise
% agentOptions.TargetPolicySmoothModel.StandardDeviation = 0.05; % target policy noise
% agentOptions.TargetPolicySmoothModel.StandardDeviationMin = -0.5;
% agentOptions.TargetPolicySmoothModel.StandardDeviationMax = 0.5;
agentOptions.ExplorationModel = rl.option.OrnsteinUhlenbeckActionNoise; % set up OU noise as exploration noise (default is Gaussian for rlTD3AgentOptions)
agentOptions.ExplorationModel.MeanAttractionConstant = 1;
agentOptions.ExplorationModel.StandardDeviation = 0.1;

% agentOptions.ActorOptimizerOptions = actorOptions;
% agentOptions.CriticOptimizerOptions = criticOptions;

%% Create agent using specified actor representation, critic representations and agent options
agent = rlTD3Agent(actor, [critic1,critic2], agentOptions);