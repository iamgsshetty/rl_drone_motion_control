mdl = "waypoint_drone_1";
% open_system(mdl)

actionInfo = rlNumericSpec([4 1], ...
    LowerLimit = -1', ...
    UpperLimit = 1');
actionInfo.Name = "control";
actionInfo.Description = "roll, pitch, yawrate and thrust";

observationInfo = rlNumericSpec([17 1]);
observationInfo.Name = "obs";
observationInfo.Description = "pos, vel, orientation, ang vel, thrust";

env = rlSimulinkEnv(mdl, mdl + "/RL Agent", observationInfo, actionInfo);

env.ResetFcn = @(in)localResetFcn(in);

obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

numObs = 17;
numAct = 4;

agent = createTD3Agent(numObs,obsInfo,numAct,actInfo,0.01);

Ts = 0.01;
Ts_agent = Ts;

T = 50.0;
maxepisodes = 300000;
maxsteps = ceil(T/Ts_agent); 
trainOpts = rlTrainingOptions(...
    MaxEpisodes=maxepisodes, ...
    MaxStepsPerEpisode=maxsteps, ...
    StopTrainingCriteria='EpisodeCount',...
    StopTrainingValue=maxepisodes,...
    ScoreAveragingWindowLength=500, ...
    Verbose=1, ...
    Plots="none",...
    UseParallel=false);
trainOpts.SaveAgentCriteria = 'EpisodeCount';
trainOpts.SaveAgentValue = 1000;
trainOpts.SaveAgentDirectory = '/scratch/users/gshetty/saved_agents';
trainOpts.ParallelizationOptions.Mode = 'async';
% evaluator = rlEvaluator(...
%     NumEpisodes=3,...
%     EvaluationFrequency=100);
% parpool('local',20);
profile on
doTraining = true;
if doTraining
    trainResult = train(agent, env, trainOpts);
else
    agent_loaded = load("TD3agent.mat");
    trainResult = train(agent_loaded.agent, env, trainOpts, Evaluator=evaluator);
end
profile off
save("TD3agent.mat", "agent");
% delete(gcp('nocreate'));

