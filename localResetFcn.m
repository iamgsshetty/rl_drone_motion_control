function in = localResetFcn(in)
    % Your reset logic goes here
    % This function should return a randomly generated initial state
    
    % Example: Set initial state with random values
    % position_xy = rand(2, 1) * 5;        % Random position in the range [0, 5]
    position_z = -5 - (rand * 10);
    pos = [0; 0; position_z];
    velocity = rand(3, 1) - 0.5;       % Random velocity in the range [-0.5, 0.5]
    orientation = rand(3, 1);   % Random orientation in the range [0, 2*pi]
    % angularRates = rand(3, 1) - 0.5;   % Random angular rates in the range [-0.5, 0.5]
    
    in = setBlockParameter(in, ...
    "waypoint_drone_1/Integrator", ...
    "InitialCondition", mat2str([pos;velocity;orientation;0;0;0;0]));
    
end