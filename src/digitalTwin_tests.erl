-module(digitalTwin_tests).
-export[findRefList/2, compute/2].
%-define(NOTEST, 1). %This line is to disable the testing for this module
-include_lib("eunit/include/eunit.hrl").

-spec startNPipesPPumpsOFlowMetersMHeatex_test_() -> {[1..255,...],{'setup',fun(() -> any()),fun((_) -> any()),fun((_) -> any())}}.
-spec return_startNPipesPPumpsOFlowMetersMHeatex() -> {_,_,_,_,_,_,_,_,10,2,2,[float(),...]}.
-spec stop(_) -> any().
-spec checkTypesAreAliveAndListsHaveCorrectLength({[any(),...],_,_,_,_,_,_,_,_,_,_,_}) -> [{56 | 57 | 58 | 59 | 60 | 61 | 63 | 64 | 66 | 67 | 68 | 69 | 70,fun(() -> any())},...].
-spec checkAllPipesInst({_,[any(),...],nonempty_maybe_improper_list(),nonempty_maybe_improper_list(),_,_,_,_,_,_,_,_}) -> [{85 | 86 | 87 | 88 | 106 | 107 | 108 | 109,fun(() -> any())},...].
-spec checkAllPipesInst(pos_integer(),[any(),...],nonempty_maybe_improper_list(),nonempty_maybe_improper_list(),[{106 | 107 | 108 | 109,fun(() -> any())}]) -> [{85 | 86 | 87 | 88 | 106 | 107 | 108 | 109,fun(() -> any())},...].
-spec checkFluidumFunctions({[any(),...],[any()],[any(),...],_,_,_,_,_,_,_,_,_}) -> [[{_,_}] | {126 | 130 | 141,fun(() -> any())},...].
-spec checkAllPumpInst({_,_,_,_,_,[any()],_,_,_,_,_,_}) -> [{155 | 161 | 167 | 173 | 179 | 185 | 194 | 200 | 206 | 212 | 218 | 224,fun(() -> any())},...] | {'error',[32 | 80 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]}.
-spec checkAllPumpInst(non_neg_integer(),[any()],[{194 | 200 | 206 | 212 | 218 | 224,fun(() -> any())}]) -> [{155 | 161 | 167 | 173 | 179 | 185 | 194 | 200 | 206 | 212 | 218 | 224,fun(() -> any())},...] | {'error',[32 | 80 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]}.
-spec checkPumpFlowInfluence({_,_,_,_,_,[any()],_,_,_,_,_,_}) -> [{245 | 253 | 259 | 264 | 276 | 284 | 290 | 295,fun(() -> any())},...] | {'error',[32 | 80 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]}.
-spec checkPumpFlowInfluence(non_neg_integer(),[any()],[{276 | 284 | 290 | 295,fun(() -> any())}]) -> [{245 | 253 | 259 | 264 | 276 | 284 | 290 | 295,fun(() -> any())},...] | {'error',[32 | 80 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]}.
-spec checkFlowmeter({_,[any()],_,_,_,_,_,_,_,_,_,_}) -> [{310 | 314 | 322,fun(() -> any())},...].
-spec checkHeatEx({_,_,_,_,_,_,_,[any()],_,_,_,nonempty_maybe_improper_list()}) -> [{339 | 349 | 360 | 370,fun(() -> any())},...] | {'error',[32 | 77 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]}.
-spec checkHeatEx(non_neg_integer(),[any()],[{360 | 370,fun(() -> any())}],nonempty_maybe_improper_list()) -> [{339 | 349 | 360 | 370,fun(() -> any())},...] | {'error',[32 | 77 | 97 | 101 | 103 | 104 | 105 | 108 | 110 | 115 | 116 | 117 | 118,...]}.
-spec check_resourceCircuit([any()],_) -> [{394,fun(() -> any())}].
-spec check_resourceCircuit([any()],_,[{394,fun(() -> any())}]) -> [{394,fun(() -> any())}].
-spec findRefList([any()],_) -> any().
-spec compute({_,_},_) -> float().
-spec eval(_,[fun((_) -> any())],number()) -> number().

%===========================================================================================
%TESTS DESCRIPTIONS
%===========================================================================================

startNPipesPPumpsOFlowMetersMHeatex_test_() ->
    {"Tests on the digitalTwin",
    {setup,
        fun return_startNPipesPPumpsOFlowMetersMHeatex/0,
        fun stop/1,
        fun({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx}) ->
            [
                checkTypesAreAliveAndListsHaveCorrectLength({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx}),
                checkAllPipesInst({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx}),
                checkFluidumFunctions({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx}),
                checkAllPumpInst({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx}),
                checkPumpFlowInfluence({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx}),
                checkFlowmeter({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx}),
                checkHeatEx({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx})
            ]
        end
    }}.


%===========================================================================================
%SETUP FUNCTIONS
%===========================================================================================

return_startNPipesPPumpsOFlowMetersMHeatex() ->
    N = 10,
    P = 2,
    M = 2,
    DifferenceHeatEx = [1.5, 0.5],
    digitalTwin:startSurvivor(),
    {ok, {Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers}} = digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(N, P, M, DifferenceHeatEx),
    {Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M, DifferenceHeatEx}.

stop(_) ->
    %?debugFmt("Stoppen in digitalTwin_tests-file",[]),
    digitalTwin:stop().


%===========================================================================================
%THE ACTUAL TESTS
%===========================================================================================
%Tests if all the types exist and if the lengths are correct

checkTypesAreAliveAndListsHaveCorrectLength({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeter, HeatExchangers, N, P, M,_DifferenceHeatEx}) ->
    [PipeTypePID, FluidumType, PumpTypePID, FlowMeterTypePID, HeatExTypePID] = Types,
    [
        %Test if all the Types are alive
        ?_assert(erlang:is_process_alive(PipeTypePID)),
        ?_assert(erlang:is_process_alive(FluidumType)),
        ?_assert(erlang:is_process_alive(PumpTypePID)),
        ?_assert(erlang:is_process_alive(FlowMeterTypePID)),
        ?_assert(erlang:is_process_alive(HeatExTypePID)),
        ?_assert(erlang:is_process_alive(FlowMeter)),
        %All the alive tests for fluidum
        ?_assert(erlang:is_process_alive(FluidumType)),
        ?_assert(erlang:is_process_alive(FluidumInst)),
        %Test if the lengts of the lists are the same as the given number
        ?_assertEqual(N, length(Pipes)),
        ?_assertEqual(2*N, length(Connectors)), %there are 2 connectors per pipe
        ?_assertEqual(N, length(Locations)),
        ?_assertEqual(P, length(Pumps)),
        ?_assertEqual(M, length(HeatExchangers))
    ].

%--------------------------------------------------------------------------------------------------------------------------------
%Tests of the pipeInsts

checkAllPipesInst({_Types, Pipes, Connectors, Locations,_FluidumInst,_Pumps,_FlowMeters,_HeatExchangers,_N,_P,_M,_DifferenceHeatEx}) ->
    Q = length(Pipes),
    checkAllPipesInst(Q, Pipes, Connectors, Locations, []).

checkAllPipesInst(1, PipesToDo, ConnectorsToDo, LocationsToDo, TestsPipeInst) ->
    [CheckPipeInst | _ToDoPipes] = PipesToDo,
    [C1, C2 | _ToDoConnectors] = ConnectorsToDo,
    [L1 | _ToDoLocations] = LocationsToDo,

    TestsPipeInst2 = [?_assert(erlang:is_process_alive(CheckPipeInst)),
                        ?_assert(erlang:is_process_alive(C1)), 
                        ?_assert(erlang:is_process_alive(C2)), 
                        ?_assert(erlang:is_process_alive(L1))],

    %?debugFmt("de testlijst ziet er zo uit: ~p~n",[TestsPipeInst2]),

    %With this way of filling this list, an improper list is created (checked with dialyzer)
    % NewTestsPipeInst = [TestsPipeInst | ?_assert(erlang:is_process_alive(CheckPipeInst))],
    % NewTestsPipeInst2 = [NewTestsPipeInst | ?_assert(erlang:is_process_alive(C1))],
    % NewTestsPipeInst3 = [NewTestsPipeInst2 | ?_assert(erlang:is_process_alive(C2))],
    % NewTestsPipeInst4 = [NewTestsPipeInst3 | ?_assert(erlang:is_process_alive(L1))],

    TestsPipeInst++TestsPipeInst2;
    

checkAllPipesInst(Q, PipesToDo, ConnectorsToDo, LocationsToDo, TestsPipeInst) ->
    [CheckPipeInst | ToDoPipes] = PipesToDo,
    [C1, C2 | ToDoConnectors] = ConnectorsToDo,
    [L1 | ToDoLocations] = LocationsToDo,

    TestsPipeInst2 = [?_assert(erlang:is_process_alive(CheckPipeInst)),
                        ?_assert(erlang:is_process_alive(C1)), 
                        ?_assert(erlang:is_process_alive(C2)), 
                        ?_assert(erlang:is_process_alive(L1))],

    % NewTestsPipeInst = [TestsPipeInst | ?_assert(erlang:is_process_alive(CheckPipeInst))],
    % NewTestsPipeInst2 = [NewTestsPipeInst | ?_assert(erlang:is_process_alive(C1))],
    % NewTestsPipeInst3 = [NewTestsPipeInst2 | ?_assert(erlang:is_process_alive(C2))],
    % NewTestsPipeInst4 = [NewTestsPipeInst3 | ?_assert(erlang:is_process_alive(L1))],

    checkAllPipesInst(Q-1, ToDoPipes, ToDoConnectors, ToDoLocations, TestsPipeInst++TestsPipeInst2).

%-------------------------------------------------------------------------------------------------------------------------------
%Tests of the fluidum

checkFluidumFunctions({ Types, Pipes, Connectors,_Locations, FluidumInst,_Pumps,_FlowMeters,_HeatExchangers,_N,_P,_M,_DifferenceHeatEx}) ->
    [_, FluidumType, _, _, _] = Types,
    %Testing function get_locations of fluidumInst 
    %This can get done when sending the message get_locations
    {ok, LocationsFluidum} = msg:get(FluidumInst,get_locations),
    TestGetLocations = ?_assertEqual(LocationsFluidum, []),

    %Test the get_type message
    {ok, GetType} = msg:get(FluidumInst,get_type),
    TestGetType = ?_assertEqual(GetType,FluidumType),

    %The next thing to test is: get_resource_circuit
    {ok, GetCircuit} = msg:get(FluidumInst, get_resource_circuit),
    %This function tests if the pipe is in the map and returns the tests
    ResourceTests = check_resourceCircuit(Pipes, GetCircuit),
    
    %The last thing to test for fluidum is: discover_circuit
    [CRoot|_] = Connectors,
    {ok, {C1, DiscoveredCirvuit}} = fluidumTyp:discover_circuit(CRoot),
    FluidumDiscoverTests = check_resourceCircuit(Connectors, DiscoveredCirvuit),
    ConnectorTest = ?_assertEqual(C1, CRoot),

    FluidumTests = [TestGetLocations, TestGetType, ResourceTests, FluidumDiscoverTests, ConnectorTest],
    FluidumTests.

%--------------------------------------------------------------------------------------------------------------------------------
%Tests of the pumpInsts

checkAllPumpInst({_Types,_Pipes,_Connectors,_Locations,_FluidumInst, Pumps,_FlowMeters,_HeatExchangers,_N,_P,_M,_DifferenceHeatEx}) ->
    Q = length(Pumps),
    checkAllPumpInst(Q, Pumps, []).

checkAllPumpInst(1, PumpsToDo, TestsPumpInst) ->
    [CheckPumpInst|_ToDoPumps] = PumpsToDo,
    Test = ?_assert(erlang:is_process_alive(CheckPumpInst)),
    %NewTestsPumpInst = [TestsPumpInst|Test],
    
    %Now the functions of the pump will be tests
    %To start, the pump should be off
    {ok, OnOffState} = pumpInst:is_on(CheckPumpInst),
    Test2 = ?_assertEqual(OnOffState,off),

    %Next function checked is to turn the pump on
    pumpInst:switch_on(CheckPumpInst),
    %Now, the pump should be turned on
    {ok, OnOffState2} = pumpInst:is_on(CheckPumpInst),
    Test3 = ?_assertEqual(OnOffState2, on),

    %If switch_on is used again, it should still be on
    pumpInst:switch_on(CheckPumpInst),
    %Now, the pump should still be turned on
    {ok, OnOffState3} = pumpInst:is_on(CheckPumpInst),
    Test4 = ?_assertEqual(OnOffState3, on),

    %It should be also checked that the pump shuts off again
    pumpInst:switch_off(CheckPumpInst),
    %Now, the pump should be turned off
    {ok, OnOffState4} = pumpInst:is_on(CheckPumpInst),
    Test5 = ?_assertEqual(OnOffState4, off),

    %It should be also checked that the pump will stay shuts off when switch_off is used again
    pumpInst:switch_off(CheckPumpInst),
    %Now, the pump should be turned off
    {ok, OnOffState5} = pumpInst:is_on(CheckPumpInst),
    Test6 = ?_assertEqual(OnOffState5, off),

    NewTestsPumpInst = [Test, Test2, Test3, Test4, Test5, Test6],
    TestsPumpInst++NewTestsPumpInst;

checkAllPumpInst(Q, PumpsToDo, TestsPumpInst) ->
    if Q > 0 ->
        %Grab the pump to test and check if it is alive
        [CheckPumpInst|_ToDoPumps] = PumpsToDo,
        Test = ?_assert(erlang:is_process_alive(CheckPumpInst)),
        %NewTestsPumpInst = [TestsPumpInst|Test],
        
        %Now the functions of the pump will be tests
        %To start, the pump should be off
        {ok, OnOffState} = pumpInst:is_on(CheckPumpInst),
        Test2 = ?_assertEqual(OnOffState,off),

        %Next function checked is to turn the pump on
        pumpInst:switch_on(CheckPumpInst),
        %Now, the pump should be turned on
        {ok, OnOffState2} = pumpInst:is_on(CheckPumpInst),
        Test3 = ?_assertEqual(OnOffState2, on),

        %If switch_on is used again, it should still be on
        pumpInst:switch_on(CheckPumpInst),
        %Now, the pump should still be turned on
        {ok, OnOffState3} = pumpInst:is_on(CheckPumpInst),
        Test4 = ?_assertEqual(OnOffState3, on),

        %It should be also checked that the pump shuts off again
        pumpInst:switch_off(CheckPumpInst),
        %Now, the pump should be turned off
        {ok, OnOffState4} = pumpInst:is_on(CheckPumpInst),
        Test5 = ?_assertEqual(OnOffState4, off),

        %It should be also checked that the pump will stay shuts off when switch_off is used again
        pumpInst:switch_off(CheckPumpInst),
        %Now, the pump should be turned off
        {ok, OnOffState5} = pumpInst:is_on(CheckPumpInst),
        Test6 = ?_assertEqual(OnOffState5, off),

        NewTestsPumpInst = [Test, Test2, Test3, Test4, Test5, Test6],
        checkAllPumpInst(Q-1, PumpsToDo, TestsPumpInst++NewTestsPumpInst);
    true ->
        io:format("P has a negative value!~n"),
	 	{error, "P has a negative value"}
    end.

%-------------------------------------------------------------------------------------------
%Tests if the flow influence of the pumps

checkPumpFlowInfluence({_Types,_Pipes,_Connectors,_Locations,_FluidumInst, Pumps,_FlowMeters,_HeatExchangers,_N,_P,_M,_DifferenceHeatEx}) ->
    QF = length(Pumps),
    checkPumpFlowInfluence(QF, Pumps, []).

checkPumpFlowInfluence(1, PumpsToDo, TestsPumpFlow) ->
    [CheckPumpFlow|_ToDoPumps] = PumpsToDo,

    %The pump should be turned off, lets check that first
    {ok, OnOffState} = pumpInst:is_on(CheckPumpFlow),
    FirstTests = ?_assertEqual(OnOffState,off),
    %NewTestsPumpFlow = [TestsPumpFlow | FirstTests],
    %A basic flow has to be set
    Flow = 5,    

    %The flow should be zero now
    {ok, FlowOff} = pumpInst:flow_influence(CheckPumpFlow),
    FlowReferenceOff = 0, %Here could also the same formula as FlowReferenceOn be used, this should ofcourse also give 0
    TestFlowOff = ?_assertEqual(FlowOff(Flow), FlowReferenceOff),
    %NewTestsPumpFlow2 = [NewTestsPumpFlow | TestFlowOff],

    %Now the pump is turned on and the flow is checked
    pumpInst:switch_on(CheckPumpFlow),
    {ok, OnOffState2} = pumpInst:is_on(CheckPumpFlow),
    TestPumpOn = ?_assertEqual(OnOffState2,on),
    %NewTestsPumpFlow3 = [NewTestsPumpFlow2 | TestPumpOn],

    {ok, FlowOn} = pumpInst:flow_influence(CheckPumpFlow),
    FlowReferenceOn = 250 - 5 * Flow - 2 * Flow * Flow,
    TestFlowOn = ?_assertEqual(FlowOn(Flow), FlowReferenceOn),
    %NewTestsPumpFlow4 = [NewTestsPumpFlow3 | TestFlowOn],
    
    NewTestsPumpFlow = [FirstTests, TestFlowOff, TestPumpOn, TestFlowOn],
    TestsPumpFlow++NewTestsPumpFlow;

checkPumpFlowInfluence(Q, PumpsToDo, TestsPumpFlow) ->
    if Q > 0 ->
        [CheckPumpFlow| ToDoPumps] = PumpsToDo,

        %The pump should be turned off, lets check that first
        {ok, OnOffState} = pumpInst:is_on(CheckPumpFlow),
        FirstTests = ?_assertEqual(OnOffState,off),
        %NewTestsPumpFlow = [TestsPumpFlow | FirstTests],
        %A basic flow has to be set
        Flow = 5,    

        %The flow should be zero now
        {ok, FlowOff} = pumpInst:flow_influence(CheckPumpFlow),
        FlowReferenceOff = 0, %Here could also the same formula as FlowReferenceOn be used, this should ofcourse also give 0
        TestFlowOff = ?_assertEqual(FlowOff(Flow), FlowReferenceOff),
        %NewTestsPumpFlow2 = [NewTestsPumpFlow | TestFlowOff],

        %Now the pump is turned on and the flow is checked
        pumpInst:switch_on(CheckPumpFlow),
        {ok, OnOffState2} = pumpInst:is_on(CheckPumpFlow),
        TestPumpOn = ?_assertEqual(OnOffState2,on),
        %NewTestsPumpFlow3 = [NewTestsPumpFlow2 | TestPumpOn],

        {ok, FlowOn} = pumpInst:flow_influence(CheckPumpFlow),
        FlowReferenceOn = 250 - 5 * Flow - 2 * Flow * Flow,
        TestFlowOn = ?_assertEqual(FlowOn(Flow), FlowReferenceOn),
        %NewTestsPumpFlow4 = [NewTestsPumpFlow3 | TestFlowOn],
        
        NewTestsPumpFlow = [FirstTests, TestFlowOff, TestPumpOn, TestFlowOn],
        checkPumpFlowInfluence(Q-1, ToDoPumps, TestsPumpFlow++NewTestsPumpFlow);
    true ->
        io:format("P has a negative value!~n"),
	 	{error, "P has a negative value"}
    end.

%--------------------------------------------------------------------------------------------------
%Tests of the Flowmeter

checkFlowmeter({_Types, Pipes,_Connectors,_Locations,_FluidumInst,_Pumps, FlowMeter,_HeatExchangers,_N,_P,_M,_DifferenceHeatEx}) ->
    %First check if the processes are alive
    FirstTests = ?_assert(erlang:is_process_alive(FlowMeter)),
    
    %If the process is alive, the functionality of the flowmeter can get tested
    {ok, FlowMeasured} = flowMeterInst:measure_flow(FlowMeter),
    Test2 = ?_assertEqual(FlowMeasured,{ok,real_flow}), 

    %Testing the estimated value
    {ok, EstFlow} = flowMeterInst:estimate_flow(FlowMeter),
    %Return the RefList for every pipe in the system
    RefList = findRefList(Pipes, []),
    Interval = {0, 10},
	RefFlow = compute(Interval, RefList),
    Test3 = ?_assertEqual(EstFlow, RefFlow), 

    FlowMeterTests = [FirstTests, Test2, Test3],
    FlowMeterTests.
    %[FirstTests, Test2, Test3].


%----------------------------------------------------------------------------------------------------
%Tests of the HeatExchangers
checkHeatEx({_Types,_Pipes,_Connectors,_Locations,_FluidumInst,_Pumps,_FlowMeter, HeatExchangers,_N,_P,_M, DifferenceHeatEx}) ->
    QH = length(HeatExchangers),
    checkHeatEx(QH, HeatExchangers, [], DifferenceHeatEx).

checkHeatEx(1, HeatExToDo, TestsHeatEx, [Difference|_Rest]) ->
    [CheckHeatEx|_ToDoHeatEx] = HeatExToDo,

    %First check if the processes of the heatex are alive
    FirstTests = ?_assert(erlang:is_process_alive(CheckHeatEx)),
    %NewTestsHeatEx = [TestsHeatEx | FirstTests],

    %The heatexchangers temp_influence(HeatExchangerInst_Pid) function is tested
    {ok, {ok,Influence}} = heatExchangerInst:temp_influence(CheckHeatEx),
    Flow = 5,
    %Difference = 1,
    Temp = 20,
    {ok, HeatExInfluence} = Influence(Flow, Temp),
    CalculateInfluence = Temp + (Difference/Flow),
    TestInfluence = ?_assertEqual(HeatExInfluence, CalculateInfluence),
    %NewTestsHeatEx2 = [NewTestsHeatEx | TestInfluence],

    NewTestsHeatEx = [FirstTests, TestInfluence],
    TestsHeatEx++NewTestsHeatEx;

checkHeatEx(Q, HeatExToDo, TestsHeatEx, [Difference| RestDifference]) ->
    if Q > 0 ->
        [CheckHeatEx| ToDoHeatEx] = HeatExToDo,

    %First check if the processes of the heatex are alive
    FirstTests = ?_assert(erlang:is_process_alive(CheckHeatEx)),
    %NewTestsHeatEx = [TestsHeatEx | FirstTests],

    %The heatexchangers temp_influence(HeatExchangerInst_Pid) function is tested
    {ok, {ok,Influence}} = heatExchangerInst:temp_influence(CheckHeatEx),
    Flow = 5,
    %Difference = 1,
    Temp = 20,
    {ok, HeatExInfluence} = Influence(Flow, Temp),
    CalculateInfluence = Temp + (Difference/Flow),
    TestInfluence = ?_assertEqual(HeatExInfluence, CalculateInfluence),
    %NewTestsHeatEx2 = [NewTestsHeatEx | TestInfluence],

    NewTestsHeatEx = [FirstTests, TestInfluence],
    checkHeatEx(Q-1, ToDoHeatEx, TestsHeatEx++NewTestsHeatEx, RestDifference);

    true ->
        io:format("M has a negative value!~n"),
	 	{error, "M has a negative value"}
    end.

%===========================================================================================
%HELP FUNCTIONS
%===========================================================================================

check_resourceCircuit(Pipes, GetCircuit) ->
    check_resourceCircuit(Pipes, GetCircuit, []).


check_resourceCircuit([PipeToCheck | Rest], GetCircuit, Checks) ->
    %?debugFmt("The CToCheck looks like: ~p~n", [PipeToCheck]),
    %?debugFmt("And the map of the circuit looks like: ~p~n", [GetCircuit]),
    {ok, PipeInMap} = maps:find(PipeToCheck, GetCircuit),
    %?debugFmt("PipeInMap looks like: ~p~n", [PipeInMap]),
    NewChecks = [?_assertEqual(PipeInMap, processed)],
    check_resourceCircuit(Rest, GetCircuit, Checks++NewChecks);


check_resourceCircuit([], _GetCircuit, Checks) -> %%Can not be at the top!!
    Checks.


findRefList([Pipe|ToDoPipes], RefList)->
    {ok, Ref} = apply(resource_instance, get_flow_influence, [Pipe]),
    findRefList(ToDoPipes, RefList++[Ref]);

findRefList([], RefList) ->
    RefList.

compute({Low, High}, _InflFnCircuit) when (High - Low) < 1 -> 
	%Todo convergentiewaarde instelbaar maken. 
	(Low + High) / 2 ;
	
compute({Low, High}, InflFnCircuit) ->
	L = eval(Low, InflFnCircuit, 0),
	H = eval(High, InflFnCircuit, 0),
	L = eval(Low, InflFnCircuit, 0),
	H = eval(High, InflFnCircuit, 0),
	Mid = (H + L) / 2, M = eval(Mid, InflFnCircuit, 0),
	if 	M > 0 -> 
			compute({Low, Mid}, InflFnCircuit);
        true -> % works as an 'else' branch
            compute({Mid, High}, InflFnCircuit)
    end.

eval(Flow, [Fn | RemFn] , Acc) ->
	eval(Flow, RemFn, Acc + Fn(Flow));

eval(_Flow, [], Acc) -> Acc. 
