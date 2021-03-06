-module(digitalTwin).
-export([startNPipesPPumpsOFlowMetersMHeatex/4]).
-export([makePipes/3, makePumps/4]).
-export([makeHeatExchangers/5]).
-export([connectPipes/1]).
-export([fillCircuitWithFluidum/2]).
-export([stop/0, startSurvivor/0, getAllConnectors/1]).

-spec startNPipesPPumpsOFlowMetersMHeatex(_,_,_,_) -> {'error',[1..255,...]} | {'ok',{[any(),...],[any(),...],nonempty_maybe_improper_list(),[any()],_,[any(),...],_,[any(),...]}}.
-spec stop() -> {'ok','stopped'}.
-spec startSurvivor() -> {'ok','started'}.
-spec makePipes(_,_,_) -> [any(),...] | {'error',[32 | 78 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]}.
-spec connectPipes([any(),...]) -> any().
-spec connectPipes(_,_,[any()]) -> any().
-spec getAllConnectors([any()]) -> any().
-spec getAllConnectors([any()],_) -> any().
-spec getAllLocations([any(),...]) -> [any()].
-spec getAllLocations([any()],[any()]) -> [any()].
-spec fillCircuitWithFluidum(_,[any()]) -> 'ok'.
-spec makePumps(_,_,_,_) -> {'error',[32 | 80 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]} | {'ok',{[any(),...],[any()]}}.
-spec makeHeatExchangers(_,_,_,_,_) -> {'error',[32 | 77 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]} | {'ok',{[any(),...],[any()]}}.


startNPipesPPumpsOFlowMetersMHeatex(N, P, M, DifferenceHeatEx) ->
	
	%This function strives to:
	%1) Create N pipe instances and connect them
	%2) Fill the system with fluidum
	%3) Create P Pumps	
	%2) Create 1 Flowmeter
	%2) Create M Heatexchangers with the DifferenceHeatEx

	
    %First it is checked that there are enough pipes to support the system
	if N < P+1+M ->
		Short = (P+1+M)-N,
		io:format("There are not enough pipes to support the system! ~p more are needed~n", [Short]),
	 	{error, "There are not enough pipes to support the system!"};

	length(DifferenceHeatEx) < M ->
		io:format("There are not enough DifferenceHeatEx defined to support the system! ~p more are needed~n", [length(DifferenceHeatEx)]),
		{error, "There are not enough DifferenceHeatEx defined to support the system!"};

	true ->
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
		[C1|_Connectors2] = Connectors,
		{ok, FluidumInst} = fluidumInst:create(C1, FluidumType), %as rootConnector is chosen for P1C1
		%Adding the fluidum to the circuit
		fillCircuitWithFluidum(FluidumInst, Locations),

		%Now all the pumps will be made
		{ok, PumpTypePID} = pumpTyp:create(),
		{ok, {Pumps, PipesFreeAfterPumps}} = makePumps(P, [], PumpTypePID, Pipes),
		io:format("~p Pumps are made ~n", [P]),
		%io:format("this are the pipes free after pumps: ~p~n", [PipesFreeAfterPumps]),
	%    {ok, {Pipes, FluidumInst, Pumps}}.

		%Adding the flowmeter, One flowmeter is enough in this system
		{ok, FlowMeterTypePID} = flowMeterTyp:create(),
		%io:format("de vrije pijpen voor de flowmeter zijn: ~p ~n", [PipesFreeAfterPumps]),
		[Pijpke | PipesFreeAfterFlowMeter] = PipesFreeAfterPumps,
		RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,
		{ok, FlowMeter} = flowMeterInst:create(self(), FlowMeterTypePID, Pijpke, RealWorldCmdFnFlowMeter),
		%RealWorldCmdFnFlowMeter = fun() ->	{ok, real_flow} end,
		io:format("1 Flowmeter is made ~n"),


		%Adding the HeatExchanger
		{ok, HeatExTypePID} = heatExchangerTyp:create(),
		%To make the heatexchanger, folowing parameters are necessary: Host, HeatExchangerTyp_Pid, PipeInst_Pid, HE_link_spec
		%Difference = 1,

		{ok, {HeatExchangers, _PipesFreeAfterHeatEx}} = makeHeatExchangers(M, [], HeatExTypePID, PipesFreeAfterFlowMeter, DifferenceHeatEx), %AANPASSEN NA TOEVOEGEN FLOWMETER!!
		%io:format("The Heatexchangers are: ~p~n", [HeatExchangers]),
		io:format("~p HeatExchangers are made ~n", [M]),

		Types = [PipeTypePID, FluidumType, PumpTypePID, FlowMeterTypePID, HeatExTypePID],

		{ok, {Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers}}
	end.

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
	%io:format("De lijst met de locations: ~p~n", [Locations]),
	Locations.

fillCircuitWithFluidum(FluidumInst, [Location|OtherLocations]) ->
	location:arrival(Location, FluidumInst),
	fillCircuitWithFluidum(FluidumInst, OtherLocations);

fillCircuitWithFluidum(_FluidumInst, []) ->
	ok.


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
    %io:format("the used pipe is is ~p ~n", [PipesPumpList]),
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
        %io:format("the used pipe is ~p ~n", [PipesPumpList]),
        {ok,PumpInst} = pumpInst:create(self(), PumpTypePID, PipesPumpList, RealWorldCmdFnPump),
        NewPumpList = PumpList ++[PumpInst],
        P2 = P-1,
        makePumps(P2, NewPumpList, PumpTypePID, PipesNotUsed);
	 true ->
		%io:format("P has a negative value!~n"),
	 	{error, "P has a negative value"}
	end.


makeHeatExchangers(1, HeatExList, HeatExTypePID, Pipes, DifferenceHeatEx) ->
    {PipesHeatExList, PipesNotUsed} = lists:split(1,Pipes),
	[Difference | _RestDifference] = DifferenceHeatEx,
	HE_link_spec = #{delta => Difference},
    %io:format("the used pipe is is ~p ~n", [PipesHeatExList]),
	{ok,HeatExInst} = heatExchangerInst:create(self(), HeatExTypePID, PipesHeatExList, HE_link_spec),
    {ok,{HeatExList ++[HeatExInst], PipesNotUsed}};

makeHeatExchangers(M, HeatExList, HeatExTypePID, Pipes, DifferenceHeatEx) ->
	if M > 1 ->
		{PipesHeatExList, PipesNotUsed} = lists:split(1,Pipes),
		[Difference | RestDifference] = DifferenceHeatEx,
        HE_link_spec = #{delta => Difference},
        %io:format("the used pipe is ~p ~n", [PipesHeatExList]),
        {ok,HeatExInst} = heatExchangerInst:create(self(), HeatExTypePID, PipesHeatExList, HE_link_spec),
        NewHeatExList = HeatExList ++[HeatExInst],
        M2 = M-1,
        makeHeatExchangers(M2, NewHeatExList, HeatExTypePID, PipesNotUsed, RestDifference);
	 true ->
		io:format("M has a negative value!~n"),
	 	{error, "M has a negative value"}
	end.
