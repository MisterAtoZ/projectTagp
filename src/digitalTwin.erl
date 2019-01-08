-module(digitalTwin).
-export([startNPipesPPumpsOFlowMetersMHeatex/4]).
-export([makePipes/3, makePumps/4, makeFlowMeters/4]).
-export([makeHeatExchangers/5]).
-export([connectPipes/1]).
-export([stop/0, startSurvivor/0, getAllConnectors/1]).


startNPipesPPumpsOFlowMetersMHeatex(N, P, O, M) ->
	
	%This function strives to:
	%1) Create N pipe instances
	%2) Create a network containing all N pipes, connecting them in a circle
	%survivor:start(),
	%survivor2:start(),
    %checkIfSystemPossible(N, P, O, M), %To Do
	{ok,PipeTypePID} = resource_type:create(pipeTyp,[]),
	Pipes = makePipes(N,[], PipeTypePID),
	io:format("~p pipes are made ~n", [N]),
	%now all pipes are made, the need to be connected together
	%All pipes in the list are connected with the one behind and in front of it
	%The last and first pipe in the list are also connected
	connectPipes(Pipes),
	Connectors = getAllConnectors(Pipes),
	Locations = getAllLocations(Pipes),

	%Adding the fluidum to the just created network
	FluidumType = fluidumTyp:create(),
    [C1|Connectors2] = Connectors,
	{ok, FluidumInst} = fluidumInst:create(C1, FluidumType), %as rootConnector is chosen for P1C1

	%Now all the pumps will be made
    {ok, PumpTypePID} = pumpTyp:create(),
    {ok, {Pumps, PipesFreeAfterPumps}} = makePumps(P, [], PumpTypePID, Pipes),
    io:format("this are the pipes free after pumps: ~p~n", [PipesFreeAfterPumps]),
%    {ok, {Pipes, FluidumInst, Pumps}}.

    %Adding the flowmeters
	% {ok, FlowMeterTypePID} = flowMeterTyp:create(),
    % io:format("de vrije pijpen voor de flowmeter zijn: ~p ~n", [PipesFreeAfterPumps]),
    % {ok, {FlowMeters, PipesFreeAfterFlowMeters}} = makeFlowMeters(O, [], FlowMeterTypePID, PipesFreeAfterPumps),
    % [Pijpke | Other] = PipesFreeAfterPumps,
    % RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,
    % {ok, FlowMeters} = flowMeterInst:create(self(), FlowMeterTypePID, Pijpke, RealWorldCmdFnFlowMeter),
    %io:format("de flowmeters zitten op ~p en de pijpen die over zijn zijn: ~p ~n", [FlowMeters, PipesFreeAfterFlowMeters]),
    %{ok,{FlowMeterList ++[FlowMeterInst], PipesNotUsed}};

    %{ok, {Pipes, FluidumInst, Pumps, FlowMeters}}.

	%Adding the HeatExchanger
	{ok, HeatExTypePID} = heatExchangerTyp:create(),
	%To make the heatexchanger, folowing parameters are necessary: Host, HeatExchangerTyp_Pid, PipeInst_Pid, HE_link_spec
	Difference = 1,

	{ok, {HeatExchangers, PipesFreeAfterHeatEx}} = makeHeatExchangers(M, [], HeatExTypePID, PipesFreeAfterPumps, Difference),
    io:format("The Heatexchangers are: ~p~n", [HeatExchangers]),

    {ok, {Pipes, FluidumInst, Pumps, HeatExchangers}}.

% startSimpleTestFluidumPumpFlowMeterHeatEx() ->
% 	%?debugFmt("Starten van de 6e functie",[]),
% 	%This function makes a simple network with 3 pipes connected together
% 	%Add a pump and
% 	%Afterwards it fill it up with water and add a Flowmeter and heatexchanger
% 	%
% 	%survivor2:start(),
% 	%survivor:start(),
% 	{ok, PipeTypePID} = resource_type:create(pipeTyp,[]),
% 	{ok,Pipe1InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
% 	{ok,Pipe2InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
% 	{ok,Pipe3InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
% 	{ok,[P1C1,P1C2]} = resource_instance:list_connectors(Pipe1InstPID),
% 	{ok,[P2C1,P2C2]} = resource_instance:list_connectors(Pipe2InstPID),
% 	{ok,[P3C1,P3C2]} = resource_instance:list_connectors(Pipe3InstPID),

% 	connector:connect(P2C2,P3C1),
% 	connector:connect(P1C1,P3C2),
% 	connector:connect(P1C2,P2C1),

% 	%Create the pumpType
% 	{ok, PumpTypePID} = pumpTyp:create(), %Need to creat a pumpType, not a resource_type!

% 	RealWorldCmdFnPump = fun(on) -> %Local function
% 						{ok,on};
% 					(off) ->
% 						{ok,off}
% 					end,

% 	%PumpInst is the actual pump
% 	%to create the PumpInst, the Host, PumpTyp_Pid, PipeInst_Pid, RealWorldCmdFn are needed
% 	{ok,PumpInst} = pumpInst:create(self(), PumpTypePID, Pipe1InstPID, RealWorldCmdFnPump),

% 	Pipes = [Pipe1InstPID, Pipe2InstPID, Pipe3InstPID],
% 	Connectors = getAllConnectors(Pipes),
% 	Locations = getAllLocations(Pipes),

% 	%Adding the fluidum to the just created network
% 	FluidumTyp = fluidumTyp:create(),
% 	{ok, FluidumInst} = fluidumInst:create(P1C1, FluidumTyp), %as rootConnector is chosen for P1C1

% 	%Adding the flowmeter
% 	{ok, FlowMeterTypePID} = flowMeterTyp:create(),

% 	%To make the flowmeter, these parameters are needed: Host, FlowMeterTyp_Pid, ResInst_Pid, RealWorldCmdFn
% 	RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,

% 	{ok, FlowMeterInst} = flowMeterInst:create(self(), FlowMeterTypePID, Pipe2InstPID, RealWorldCmdFnFlowMeter),

% 	%Adding the HeatExchanger
% 	{ok, HeatExTypePID} = heatExchangerTyp:create(),
% 	%To make the heatexchanger, folowing parameters are necessary: Host, HeatExchangerTyp_Pid, PipeInst_Pid, HE_link_spec
% 	Difference = 1,
% 	HE_link_spec = #{delta => Difference},

% 	{ok, HeatExInst} = heatExchangerInst:create(self(), HeatExTypePID, Pipe3InstPID, HE_link_spec),

% 	{ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst, HeatExTypePID, HeatExInst}}.


stop() ->
	survivor ! stop,
	{ok, stopped}.

startSurvivor() ->
	survivor2:start(),
	{ok, started}.

%===========================================================================================
%HELP FUNCTIONS
%===========================================================================================

%Recursive Function to make N amount of pipes
% makePipes(N,[], _PipeTypePID) when N =< 0 ->
% 	[];
%This adds the last pipe to the list
makePipes(1, PipeList, PipeTypePID) ->
	{ok,PipeInstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	%PipeList = [PipeList | PipeInstPID];
	PipeList ++[PipeInstPID];

makePipes(N, PipeList, PipeTypePID) ->
	if N > 1 ->
		{ok,PipeInstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
		%PipeList = [PipeList | PipeInstPID],
		NewPipeList = PipeList ++[PipeInstPID],
		M = N-1,
		makePipes(M, NewPipeList, PipeTypePID);
	 true ->
		io:format("N has a negative value!~n"),
	 	{error, "N has a negative value"}
	end.

connectPipes([FirstPipe|OtherPipes]) ->
	connectPipes(FirstPipe, FirstPipe, OtherPipes).

connectPipes(FirstPipe, PipeToConnect, [MiddlePipe | OtherPipes]) ->
	%The PipeToConnect gets connected with the newt pipe in the list,
	%this is the MiddlePipe
	{ok,[_P1C1,P1C2]} = resource_instance:list_connectors(PipeToConnect),
	{ok,[P2C1,_P2C2]} = resource_instance:list_connectors(MiddlePipe),
	connector:connect(P1C2, P2C1),
	connectPipes(FirstPipe, MiddlePipe, OtherPipes);

connectPipes(FirstPipe, PipeToConnect, []) ->
	%If the List of to do Pipes is empty, the first and last Pipe need to be connected
	%The end connector of the first Pipe and the end connector of the last pipe
	%are already used! this means the other pipes need to be used
	{ok,[P1C1,_P1C2]} = resource_instance:list_connectors(FirstPipe),
	{ok,[_P2C1,P2C2]} = resource_instance:list_connectors(PipeToConnect),
	connector:connect(P1C1, P2C2).


%Function to return all the connectors from the pipes
getAllConnectors(Pipes) ->
	getAllConnectors(Pipes,[]).
	
getAllConnectors([Pipe|OtherPipes],Connectors) ->
	{ok,Cs} = resource_instance:list_connectors(Pipe),
	getAllConnectors(OtherPipes,Connectors++Cs);
	
getAllConnectors([],Connectors) ->
	%io:format("~p is de lijst met connectors ~n",[Connectors]),
	Connectors.

%Function to return all the locations
getAllLocations(Pipes) ->
	getAllLocations(Pipes,[]).
	
getAllLocations([Pipe|OtherPipes],Locations) ->
	{ok,[NewLocation]} = resource_instance:list_locations(Pipe),
	LocationAdded = lists:append(Locations, [NewLocation]),
	getAllLocations(OtherPipes,LocationAdded);
	
getAllLocations([],Locations) ->
	io:format("De lijst met de locations: ~p~n", [Locations]),
	Locations.

%Recursive Function to make N amount of pipes
% makePipes(N,[], _PipeTypePID) when N =< 0 ->
% 	[];
%This adds the last pipe to the list
makePumps(1, PumpList, PumpTypePID, Pipes) ->
    RealWorldCmdFnPump = fun(on) -> %Local function
						{ok,on};
					(off) ->
						{ok,off}
					end,

	%PumpInst is the actual pump
	%to create the PumpInst, the Host, PumpTyp_Pid, PipeInst_Pid, RealWorldCmdFn are needed
    {PipesPumpList, PipesNotUsed} = lists:split(1,Pipes),
    io:format("the used pipe is is ~p ~n", [PipesPumpList]),
	{ok,PumpInst} = pumpInst:create(self(), PumpTypePID, PipesPumpList, RealWorldCmdFnPump),
    {ok,{PumpList ++[PumpInst], PipesNotUsed}};

makePumps(P, PumpList, PumpTypePID, Pipes) ->
	if P > 1 ->
        RealWorldCmdFnPump = fun(on) -> %Local function
						{ok,on};
					(off) ->
						{ok,off}
					end,
        %PumpInst is the actual pump
        %to create the PumpInst, the Host, PumpTyp_Pid, PipeInst_Pid, RealWorldCmdFn are needed
        {PipesPumpList, PipesNotUsed} = lists:split(1,Pipes),
        io:format("the used pipe is ~p ~n", [PipesPumpList]),
        {ok,PumpInst} = pumpInst:create(self(), PumpTypePID, PipesPumpList, RealWorldCmdFnPump),
        NewPumpList = PumpList ++[PumpInst],
        P2 = P-1,
        makePumps(P2, NewPumpList, PumpTypePID, PipesNotUsed);
	 true ->
		io:format("P has a negative value!~n"),
	 	{error, "P has a negative value"}
	end.

makeFlowMeters(1, FlowMeterList, FlowMeterTypePID, Pipes) ->
    RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,

    {PipesFlowMeterList, PipesNotUsed} = lists:split(1,Pipes),
    io:format("the used pipe is is ~p ~n", [PipesFlowMeterList]),
    io:format("the host is: ~p~n", [self()]),
    io:format("the flowmeterType PID is: ~p ~n", [FlowMeterTypePID]),
    io:format("the used pipe is ~p ~n", [PipesFlowMeterList]),
    io:format("the RealWorldCmdFnFlowMeter is: ~p ~n", [RealWorldCmdFnFlowMeter]),
	{ok, FlowMeterInst} = flowMeterInst:create(self(), FlowMeterTypePID, PipesFlowMeterList, RealWorldCmdFnFlowMeter),
    {ok,{FlowMeterList ++[FlowMeterInst], PipesNotUsed}};

makeFlowMeters(O, FlowMeterList, FlowMeterTypePID, Pipes) ->
	if O > 1 ->
        RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,

        {PipesFlowMeterList, PipesNotUsed} = lists:split(1,Pipes),
        io:format("the used pipe is ~p ~n", [PipesFlowMeterList]),
        io:format("the host is: ~p~n", [self()]),
        io:format("the flowmeterType PID is: ~p ~n", [FlowMeterTypePID]),
        io:format("the used pipe is ~p ~n", [PipesFlowMeterList]),
        io:format("the RealWorldCmdFnFlowMeter is: ~p ~n", [RealWorldCmdFnFlowMeter]),
        {ok,FlowMeterInst} = flowMeterInst:create(self(), FlowMeterTypePID, PipesFlowMeterList, RealWorldCmdFnFlowMeter),
        io:format("FlowMeterInst is: ~p~n",[FlowMeterInst]),
        NewFlowMeterList = FlowMeterList ++[FlowMeterInst],
        O2 = O-1,
        makeFlowMeters(O2, NewFlowMeterList, FlowMeterTypePID, PipesNotUsed);
	 true ->
		io:format("O has a negative value!~n"),
	 	{error, "O has a negative value"}
	end.




% makeFlowMeters(1, FlowMeterList, FlowMeterTypePID, PipesFreeAfterPumps) ->
%     %To make the flowmeter, these parameters are needed: Host, FlowMeterTyp_Pid, ResInst_Pid, RealWorldCmdFn
%     RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,
%     {PipesFlowMeterList, PipesNotUsed} = lists:split(1,PipesFreeAfterPumps),
%     %[PipesFlowMeterList| PipesNotUsed] = PipesFreeAfterPumps,
%     io:format("the used pipe is ~p ~n", [PipesFlowMeterList]),
%     {ok, FlowMeterInst} = flowMeterInst:create(self(), FlowMeterTypePID, PipesFlowMeterList, RealWorldCmdFnFlowMeter),
%     NewFlowMeterList = FlowMeterList ++[FlowMeterInst],
%     io:format("the new flowmeterList is: ~p ~n", [NewFlowMeterList]),

%     {ok,{NewFlowMeterList, PipesNotUsed}};

% makeFlowMeters(O, FlowMeterList, FlowMeterTypePID, PipesFreeAfterPumps) ->
% 	if O > 1 ->
% 	    RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,
%         {PipesFlowMeterList, PipesNotUsed} = lists:split(1,PipesFreeAfterPumps),
%         %[PipesFlowMeterList| PipesNotUsed] = PipesFreeAfterPumps,
%         io:format("the host is: ~p~n", [self()]),
%         io:format("the flowmeterType PID is: ~p ~n", [FlowMeterTypePID]),
%         io:format("the used pipe is ~p ~n", [PipesFlowMeterList]),
%         io:format("the RealWorldCmdFnFlowMeter is: ~p ~n", [RealWorldCmdFnFlowMeter]),
        
% 	    {ok, FlowMeterInst} = flowMeterInst:create(self(), FlowMeterTypePID, PipesFlowMeterList, RealWorldCmdFnFlowMeter),
        
%         NewFlowMeterList = FlowMeterList ++[FlowMeterInst],
%         O2 = O-1,
%         makePumps(O2, NewFlowMeterList, FlowMeterTypePID, PipesNotUsed);
% 	 true ->
% 		io:format("O has a negative value!~n"),
% 	 	{error, "O has a negative value"}
% 	end.


makeHeatExchangers(1, HeatExList, HeatExTypePID, Pipes, Difference) ->
    HE_link_spec = #{delta => Difference},
    {PipesHeatExList, PipesNotUsed} = lists:split(1,Pipes),
    io:format("the used pipe is is ~p ~n", [PipesHeatExList]),
	{ok,HeatExInst} = heatExchangerInst:create(self(), HeatExTypePID, PipesHeatExList, HE_link_spec),
    {ok,{HeatExList ++[HeatExInst], PipesNotUsed}};

makeHeatExchangers(M, HeatExList, HeatExTypePID, Pipes, Difference) ->
	if M > 1 ->
        HE_link_spec = #{delta => Difference},
        {PipesHeatExList, PipesNotUsed} = lists:split(1,Pipes),
        io:format("the used pipe is ~p ~n", [PipesHeatExList]),
        {ok,HeatExInst} = heatExchangerInst:create(self(), HeatExTypePID, PipesHeatExList, HE_link_spec),
        NewHeatExList = HeatExList ++[HeatExInst],
        M2 = M-1,
        makeHeatExchangers(M2, NewHeatExList, HeatExTypePID, PipesNotUsed, Difference);
	 true ->
		io:format("M has a negative value!~n"),
	 	{error, "M has a negative value"}
	end.
