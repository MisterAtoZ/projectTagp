-module(testModule2).
%-define(NOTEST, 1). %This line is to disable the testing for this module
-include_lib("eunit/include/eunit.hrl").

-export([startSimpleTest/0]).
-export([startNPipes/1]).
-export([startSimpleTestFluidum/0]).
-export([startSimpleTestFluidumPump/0]).
-export([startSimpleTestFluidumPumpFlowMeter/0]).
-export([startSimpleTestFluidumPumpFlowMeterHeatEx/0]).
-export([makePipes/3]).
-export([connectPipes/1]).
-export([stop/0, startSurvivor/0, getAllConnectors/1]).

startSimpleTest() ->
	%This function makes a simple network with 3 pipes connected together
	?debugFmt("Starten van de 1e functie",[]),
	%survivor:start(),
	%survivor2:start(),
	{ok, PipeTypePID} = resource_type:create(pipeTyp,[]),
	{ok,Pipe1InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe2InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe3InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,[P1C1,P1C2]} = resource_instance:list_connectors(Pipe1InstPID),
	{ok,[P2C1,P2C2]} = resource_instance:list_connectors(Pipe2InstPID),
	{ok,[P3C1,P3C2]} = resource_instance:list_connectors(Pipe3InstPID),

	{ok,[Location1]} = resource_instance:list_locations(Pipe1InstPID),
	{ok,[Location2]} = resource_instance:list_locations(Pipe2InstPID),
	{ok,[Location3]} = resource_instance:list_locations(Pipe3InstPID),
	
	io:format("~p is the location of pipe1 ~n", [Location1]),
	io:format("~p is the location of pipe2 ~n", [Location2]),
	io:format("~p is the location of pipe2 ~n", [Location3]),

	connector:connect(P2C2,P3C1),
	connector:connect(P1C1,P3C2),
	connector:connect(P1C2,P2C1),

	Pipes = [Pipe1InstPID, Pipe2InstPID, Pipe3InstPID],
	Connectors = [[P2C2, P3C1], [P1C1, P3C2], [P1C2, P2C1]],
	Locations = [Location1, Location2, Location3],
	{ok, {Pipe1InstPID, Pipes, Connectors, Locations}}.

startNPipes(N) ->
	?debugFmt("Starten van de 2e functie",[]),
	%This function strives to:
	%1) Create N pipe instances
	%2) Create a network containing all N pipes, connecting them in a circle
	%survivor:start(),
	%survivor2:start(),
	{ok,PipeTypePID} = resource_type:create(pipeTyp,[]),
	Pipes = makePipes(N,[], PipeTypePID),
	io:format("~p pipes are made ~n", [N]),
	%now all pipes are made, the need to be connected together
	%All pipes in the list are connected with the one behind and in front of it
	%The last and first pipe in the list are also connected
	connectPipes(Pipes),
	Connectors = getAllConnectors(Pipes),
	Locations = getAllLocations(Pipes),

	{ok, {PipeTypePID, Pipes, Connectors, Locations}}.

startSimpleTestFluidum() ->
	?debugFmt("Starten van de 3e functie",[]),
	%This function makes a simple network with 3 pipes connected together
	%Afterwards it fill it up with water
	%survivor:start(),
	%survivor2:start(),
	{ok, PipeTypePID} = resource_type:create(pipeTyp,[]),
	{ok,Pipe1InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe2InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe3InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,[P1C1,P1C2]} = resource_instance:list_connectors(Pipe1InstPID),
	{ok,[P2C1,P2C2]} = resource_instance:list_connectors(Pipe2InstPID),
	{ok,[P3C1,P3C2]} = resource_instance:list_connectors(Pipe3InstPID),

	% {ok,[Location1]} = resource_instance:list_locations(Pipe1InstPID),
	% {ok,[Location2]} = resource_instance:list_locations(Pipe2InstPID),
	% {ok,[Location3]} = resource_instance:list_locations(Pipe3InstPID),
	
	% io:format("~p is the location of pipe1 ~n", [Location1]),
	% io:format("~p is the location of pipe2 ~n", [Location2]),
	% io:format("~p is the location of pipe2 ~n", [Location3]),

	connector:connect(P2C2,P3C1),
	connector:connect(P1C1,P3C2),
	connector:connect(P1C2,P2C1),

	Pipes = [Pipe1InstPID, Pipe2InstPID, Pipe3InstPID],
	Connectors = getAllConnectors(Pipes),
	Locations = getAllLocations(Pipes),

	%Adding the fluidum to the just created network
	FluidumTyp = fluidumTyp:create(),
	{ok, FluidumInst} = fluidumInst:create(P1C1, FluidumTyp), %as rootConnector is chosen for P1C1

	{ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}}.

startSimpleTestFluidumPump() ->
	?debugFmt("Starten van de 4e functie",[]),
	%This function makes a simple network with 3 pipes connected together
	%Add a pump and
	%Afterwards it fill it up with water
	%survivor:start(),
	%survivor2:start(),
	{ok, PipeTypePID} = resource_type:create(pipeTyp,[]),
	{ok,Pipe1InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe2InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe3InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,[P1C1,P1C2]} = resource_instance:list_connectors(Pipe1InstPID),
	{ok,[P2C1,P2C2]} = resource_instance:list_connectors(Pipe2InstPID),
	{ok,[P3C1,P3C2]} = resource_instance:list_connectors(Pipe3InstPID),

	connector:connect(P2C2,P3C1),
	connector:connect(P1C1,P3C2),
	connector:connect(P1C2,P2C1),

	%Create the pump
	{ok, PumpTypePID} = pumpTyp:create(), %Need to creat a pumpType, not a resource_type!

	RealWorldCmdFn = fun(on) -> %Local function
						{ok,on};
					(off) ->
						{ok,off}
					end,

	%to create the PumpInst, the Host, PumpTyp_Pid, PipeInst_Pid, RealWorldCmdFn are needed
	{ok,PumpInst} = pumpInst:create(self(), PumpTypePID, Pipe1InstPID, RealWorldCmdFn),

	Pipes = [Pipe1InstPID, Pipe2InstPID, Pipe3InstPID],
	Connectors = getAllConnectors(Pipes),
	Locations = getAllLocations(Pipes),

	%Adding the fluidum to the just created network
	FluidumTyp = fluidumTyp:create(),
	{ok, FluidumInst} = fluidumInst:create(P1C1, FluidumTyp), %as rootConnector is chosen for P1C1

	{ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}}.

startSimpleTestFluidumPumpFlowMeter() ->
	?debugFmt("Starten van de 5e functie",[]),
	%This function makes a simple network with 3 pipes connected together
	%Add a pump and
	%Afterwards it fill it up with water and add a Flowmeter
	%
	%survivor:start(),
	%survivor2:start(),
	{ok, PipeTypePID} = resource_type:create(pipeTyp,[]),
	{ok,Pipe1InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe2InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe3InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,[P1C1,P1C2]} = resource_instance:list_connectors(Pipe1InstPID),
	{ok,[P2C1,P2C2]} = resource_instance:list_connectors(Pipe2InstPID),
	{ok,[P3C1,P3C2]} = resource_instance:list_connectors(Pipe3InstPID),

	connector:connect(P2C2,P3C1),
	connector:connect(P1C1,P3C2),
	connector:connect(P1C2,P2C1),

	%Create the pumpType
	{ok, PumpTypePID} = pumpTyp:create(), %Need to creat a pumpType, not a resource_type!

	RealWorldCmdFnPump = fun(on) -> %Local function
						{ok,on};
					(off) ->
						{ok,off}
					end,

	%PumpInst is the actual pump
	%to create the PumpInst, the Host, PumpTyp_Pid, PipeInst_Pid, RealWorldCmdFn are needed
	{ok,PumpInst} = pumpInst:create(self(), PumpTypePID, Pipe1InstPID, RealWorldCmdFnPump),

	Pipes = [Pipe1InstPID, Pipe2InstPID, Pipe3InstPID],
	Connectors = getAllConnectors(Pipes),
	Locations = getAllLocations(Pipes),

	%Adding the FluidumInst to the just created network
	FluidumTyp = fluidumTyp:create(),
	{ok, FluidumInst} = fluidumInst:create(P1C1, FluidumTyp), %as rootConnector is chosen for P1C1

	%Adding the flowmeter
	{ok, FlowMeterTypePID} = flowMeterTyp:create(),

	%To make the flowmeter, these parameters are needed: Host, FlowMeterTyp_Pid, ResInst_Pid, RealWorldCmdFn
	RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,

	{ok, FlowMeterInst} = flowMeterInst:create(self(), FlowMeterTypePID, Pipe2InstPID, RealWorldCmdFnFlowMeter),

	{ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst}}.

startSimpleTestFluidumPumpFlowMeterHeatEx() ->
	?debugFmt("Starten van de 6e functie",[]),
	%This function makes a simple network with 3 pipes connected together
	%Add a pump and
	%Afterwards it fill it up with water and add a Flowmeter and heatexchanger
	%
	%survivor2:start(),
	%survivor:start(),
	{ok, PipeTypePID} = resource_type:create(pipeTyp,[]),
	{ok,Pipe1InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe2InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe3InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,[P1C1,P1C2]} = resource_instance:list_connectors(Pipe1InstPID),
	{ok,[P2C1,P2C2]} = resource_instance:list_connectors(Pipe2InstPID),
	{ok,[P3C1,P3C2]} = resource_instance:list_connectors(Pipe3InstPID),

	connector:connect(P2C2,P3C1),
	connector:connect(P1C1,P3C2),
	connector:connect(P1C2,P2C1),

	%Create the pumpType
	{ok, PumpTypePID} = pumpTyp:create(), %Need to creat a pumpType, not a resource_type!

	RealWorldCmdFnPump = fun(on) -> %Local function
						{ok,on};
					(off) ->
						{ok,off}
					end,

	%PumpInst is the actual pump
	%to create the PumpInst, the Host, PumpTyp_Pid, PipeInst_Pid, RealWorldCmdFn are needed
	{ok,PumpInst} = pumpInst:create(self(), PumpTypePID, Pipe1InstPID, RealWorldCmdFnPump),

	Pipes = [Pipe1InstPID, Pipe2InstPID, Pipe3InstPID],
	Connectors = getAllConnectors(Pipes),
	Locations = getAllLocations(Pipes),

	%Adding the fluidum to the just created network
	FluidumTyp = fluidumTyp:create(),
	{ok, FluidumInst} = fluidumInst:create(P1C1, FluidumTyp), %as rootConnector is chosen for P1C1

	%Adding the flowmeter
	{ok, FlowMeterTypePID} = flowMeterTyp:create(),

	%To make the flowmeter, these parameters are needed: Host, FlowMeterTyp_Pid, ResInst_Pid, RealWorldCmdFn
	RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,

	{ok, FlowMeterInst} = flowMeterInst:create(self(), FlowMeterTypePID, Pipe2InstPID, RealWorldCmdFnFlowMeter),

	%Adding the HeatExchanger
	{ok, HeatExTypePID} = heatExchangerTyp:create(),
	%To make the heatexchanger, folowing parameters are necessary: Host, HeatExchangerTyp_Pid, PipeInst_Pid, HE_link_spec
	Difference = 1,
	HE_link_spec = #{delta => Difference},

	{ok, HeatExInst} = heatExchangerInst:create(self(), HeatExTypePID, Pipe3InstPID, HE_link_spec),

	{ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst, HeatExTypePID, HeatExInst}}.

stop() ->
	?debugFmt("Stoppen in originele file",[]),
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
