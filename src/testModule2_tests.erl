-module(testModule2_tests).
%-define(NOTEST, 1). %This line is to disable the testing for this module
-include_lib("eunit/include/eunit.hrl").

% -export([reverse_test/0]).
% -export([length_test/0]).
% reverse_test() -> lists:reverse([1,2,3]).
% length_test() -> ?assert(length([1,2,3]) =:= 3).
% basic_test_() ->
%        fun () -> ?assert(1 + 1 =:= 2) end.

%===========================================================================================
%TESTS DESCRIPTIONS
%===========================================================================================

%First, the pipes are made, otherwise they can't be checked
%%%links with the inspiration and help: https://stackoverflow.com/questions/22771788/eunit-how-to-test-a-simple-process
% https://learnyousomeerlang.com/eunit
startSimpleTest_test_() ->
    {"Starting and stopping the system",
    {foreach, %here is a foreach used to test if the stop function also works
        fun return_startSimpleTest/0,
        fun stop/1, %after each test, the survivor gets stopped, because only one survivor can exist
        [fun checkPipes/1]
    }}.

startNPipes_test_() ->
    {"Tests if N Pipes are made and if they exist",
    {setup,
        fun return_startNPipes/0,
        fun stop/1,
        fun checkNPipes/1
    }}.

startSimpleTestFluidum_test_() ->
    {"Tests if the network is created and if the fluidum is added",
    {setup,
        fun return_startSimpleTestFluidum/0,
        fun stop/1,
        fun({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}) ->
            [
                checkPipesWithFluidum({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}),
                checkFluidumFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst})
            ]
        end
    }}.

startSimpleTestFluidumPump_test_() ->
    {"Tests if the network is created with a pump and if there is a fluidum",
    {setup,
        fun return_startSimpleTestFluidumPump/0,
        fun stop/1,
        fun({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}) ->
            [
                checkFluidumFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}),
                checkPipesWithFluidumPump({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}),
                checkPumpFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}),
                checkPumpFlowInfluence({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst})
            ]
        end
    }}.

startSimpleTestFluidumPumpFlowMeter_test_() ->
    {"Test if the network is created with 3 pipes, pump and Flowmeter",
    {setup,
        fun return_startSimpleTestFluidumPumpFlowMeter/0,
        fun stop/1,
        fun({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst}) ->
            [
                %The same as the previous testbuild are done for completion
                checkFluidumFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}),
                checkPipesWithFluidumPump({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}), 
                checkPumpFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}),
                checkPumpFlowInfluence({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}),
                %The new tests to check the FlowMeter
                checkFlowmeter({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst})
            ]
        end
    }}.

startSimpleTestFluidumPumpFlowMeterHeatEx_test_() ->
    {"Test if the network is created with 3 pipes, a pump, flowmeter and a heatexchanger",
    {setup,
        fun return_startSimpleTestFluidumPumpFlowMeterHeatEx/0,
        fun stop/1,
        fun({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst, HeatExTypePID, HeatExInst}) ->
            [
                %The same tests as in previous testbuilds, these are done for completion
                checkFluidumFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}),
                checkPipesWithFluidumPump({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}),
                checkPumpFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}),
                checkPumpFlowInfluence({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}),
                checkFlowmeter({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst}),
                %The tests to check the HeatExchanger
                checkHeatEx({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst, HeatExTypePID, HeatExInst})
            ]
        end
    }}.

%===========================================================================================
%SETUP FUNCTIONS
%===========================================================================================

%The processes need to be started/stopped, this happens here
return_startSimpleTest() ->
    testModule2:startSurvivor(),
    {ok, {PipeTypePID, Pipes, Connectors, Locations}} = testModule2:startSimpleTest(),
    {PipeTypePID, Pipes, Connectors, Locations}.

stop(_) ->
    %?debugFmt("Stoppen in test-file",[]),
    testModule2:stop().

return_startNPipes() ->
    testModule2:startSurvivor(),
    N = 5, %Has to be atleast 3! 
    {ok, {PipeTypePID, Pipes, Connectors, Location}} = testModule2:startNPipes(N),
    {PipeTypePID, Pipes, Connectors, Location, N}.

return_startSimpleTestFluidum() ->
    testModule2:startSurvivor(),
    {ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}} = testModule2:startSimpleTestFluidum(),
    {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}.

return_startSimpleTestFluidumPump() ->
    testModule2:startSurvivor(),
    {ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}} = testModule2:startSimpleTestFluidumPump(),
    {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst}.

return_startSimpleTestFluidumPumpFlowMeter() ->
    testModule2:startSurvivor(),
    {ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst}} = testModule2:startSimpleTestFluidumPumpFlowMeter(),
    {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst}.

return_startSimpleTestFluidumPumpFlowMeterHeatEx() ->
    testModule2:startSurvivor(),
    {ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst, HeatExTypePID, HeatExInst}} = testModule2:startSimpleTestFluidumPumpFlowMeterHeatEx(),
    {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst, HeatExTypePID, HeatExInst}.


%===========================================================================================
%THE ACTUAL TESTS
%===========================================================================================

%Next, a function to check the pipes, the actual test
%The function needs to know which pipes are used and if they are still running
%The same needs to be done for the connectors
checkPipes({PipeTypePID, Pipes, Connectors, Locations}) ->
    [Pipe1, Pipe2, Pipe3|_RestPipes] = Pipes,
    [[C11, C12], [C21, C22], [C31, C32]] = Connectors,
    [Location1, Location2, Location3] = Locations,
    %Check if the processes are running
    %If all the tests pass, all the processes are running
    [
        ?_assert(erlang:is_process_alive(PipeTypePID)),
        ?_assert(erlang:is_process_alive(Pipe1)),
        ?_assert(erlang:is_process_alive(Pipe2)),
        ?_assert(erlang:is_process_alive(Pipe3)),
        ?_assert(erlang:is_process_alive(C11)),
        ?_assert(erlang:is_process_alive(C12)),
        ?_assert(erlang:is_process_alive(C21)),
        ?_assert(erlang:is_process_alive(C22)),
        ?_assert(erlang:is_process_alive(C31)),
        ?_assert(erlang:is_process_alive(C32)),
        ?_assert(erlang:is_process_alive(Location1)),
        ?_assert(erlang:is_process_alive(Location2)),
        ?_assert(erlang:is_process_alive(Location3))
    ].

checkNPipes({PipeTypePID, Pipes, Connectors, Locations, N}) ->
    %Only the first three pipes get checked if they really exist
    [Pipe1, Pipe2, Pipe3|_RestPipes] = Pipes,
    [C11,C12,C21,C22,C31,C32|_RestConnectors] = Connectors,
    [Location1, Location2, Location3|_RestLocations] = Locations,
    %Check if the processes of the first three pipes are running
    %If all the tests pass, all the processes are running
    [
        ?_assert(erlang:is_process_alive(PipeTypePID)),
        ?_assert(erlang:is_process_alive(Pipe1)),
        ?_assert(erlang:is_process_alive(Pipe2)),
        ?_assert(erlang:is_process_alive(Pipe3)),
        ?_assert(erlang:is_process_alive(C11)),
        ?_assert(erlang:is_process_alive(C12)),
        ?_assert(erlang:is_process_alive(C21)),
        ?_assert(erlang:is_process_alive(C22)),
        ?_assert(erlang:is_process_alive(C31)),
        ?_assert(erlang:is_process_alive(C32)),
        ?_assert(erlang:is_process_alive(Location1)),
        ?_assert(erlang:is_process_alive(Location2)),
        ?_assert(erlang:is_process_alive(Location3)),
        ?_assertEqual(N, length(Pipes)), %these should be the same
        ?_assertEqual(2*N, length(Connectors)), %there are 2 connectors per pipe
        ?_assertEqual(N, length(Locations))
    ].

checkPipesWithFluidum({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, FluidumInst}) ->
    [Pipe1, Pipe2, Pipe3|_RestPipes] = Pipes,
    [C11, C12, C21, C22, C31, C32] = Connectors,
    [Location1, Location2, Location3] = Locations,
    %Check if the processes are running
    %If all the tests pass, all the processes are running
    [
        ?_assert(erlang:is_process_alive(PipeTypePID)),
        ?_assert(erlang:is_process_alive(Pipe1)),
        ?_assert(erlang:is_process_alive(Pipe2)),
        ?_assert(erlang:is_process_alive(Pipe3)),
        ?_assert(erlang:is_process_alive(C11)),
        ?_assert(erlang:is_process_alive(C12)),
        ?_assert(erlang:is_process_alive(C21)),
        ?_assert(erlang:is_process_alive(C22)),
        ?_assert(erlang:is_process_alive(C31)),
        ?_assert(erlang:is_process_alive(C32)),
        ?_assert(erlang:is_process_alive(Location1)),
        ?_assert(erlang:is_process_alive(Location2)),
        ?_assert(erlang:is_process_alive(Location3)),
        ?_assert(erlang:is_process_alive(FluidumTyp)),
        ?_assert(erlang:is_process_alive(FluidumInst))
    ].

checkFluidumFunctions({_PipeTypePID, Pipes, Connectors,_Locations, FluidumTyp, FluidumInst}) ->
    %Testing function get_locations of fluidumInst 
    %This can get done when sending the message get_locations
    {ok, LocationsFluidum} = msg:get(FluidumInst,get_locations),
    TestGetLocations = ?_assertEqual(LocationsFluidum, []),

    %Test the get_type message
    {ok, GetType} = msg:get(FluidumInst,get_type),
    TestGetType = ?_assertEqual(GetType,FluidumTyp),

    %The next thing to test is: get_resource_circuit
    {ok, GetCircuit} = msg:get(FluidumInst, get_resource_circuit),
    %This function tests if the pipe is in the map and returns the tests
    FluidumTests = check_resourceCircuit(Pipes, GetCircuit),
    
    %The last thing to test for fluidum is: discover_circuit
    [CRoot|_] = Connectors,
    {ok, {C1, DiscoveredCirvuit}} = fluidumTyp:discover_circuit(CRoot),
    FluidumDiscoverTests = check_resourceCircuit(Connectors, DiscoveredCirvuit),
    ConnectorTest = ?_assertEqual(C1, CRoot),

    [TestGetLocations, TestGetType, FluidumTests, FluidumDiscoverTests, ConnectorTest].

checkPipesWithFluidumPump({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp,_Fluidum, PumpTypePID, PumpInst}) ->
    [Pipe1, Pipe2, Pipe3|_RestPipes] = Pipes,
    [C11, C12, C21, C22, C31, C32] = Connectors,
    [Location1, Location2, Location3] = Locations,
    %Check if the processes are running
    %If all the tests pass, all the processes are running
    [
        ?_assert(erlang:is_process_alive(PipeTypePID)),
        ?_assert(erlang:is_process_alive(Pipe1)),
        ?_assert(erlang:is_process_alive(Pipe2)),
        ?_assert(erlang:is_process_alive(Pipe3)),
        ?_assert(erlang:is_process_alive(C11)),
        ?_assert(erlang:is_process_alive(C12)),
        ?_assert(erlang:is_process_alive(C21)),
        ?_assert(erlang:is_process_alive(C22)),
        ?_assert(erlang:is_process_alive(C31)),
        ?_assert(erlang:is_process_alive(C32)),
        ?_assert(erlang:is_process_alive(Location1)),
        ?_assert(erlang:is_process_alive(Location2)),
        ?_assert(erlang:is_process_alive(Location3)),
        ?_assert(erlang:is_process_alive(FluidumTyp)),
        ?_assert(erlang:is_process_alive(PumpTypePID)),
        ?_assert(erlang:is_process_alive(PumpInst))
    ].

checkPumpFunctions({_PipeTypePID,_Pipes,_Connectors,_Locations,_FluidumTyp,_Fluidum, PumpTypePID, PumpInst}) ->

    %To start, the pump should be off
    {ok, OnOffState} = pumpInst:is_on(PumpInst),
    FirstTests = [
        ?_assert(erlang:is_process_alive(PumpTypePID)),
        ?_assert(erlang:is_process_alive(PumpInst)),
        ?_assertEqual(OnOffState,off)
    ],

    %Next function checked is to turn the pump on
    pumpInst:switch_on(PumpInst),
    %Now, the pump should be turned on
    {ok, OnOffState2} = pumpInst:is_on(PumpInst),
    Test2 = ?_assertEqual(OnOffState2, on),

    %If switch_on is used again, it should still be on
    pumpInst:switch_on(PumpInst),
    %Now, the pump should still be turned on
    {ok, OnOffState3} = pumpInst:is_on(PumpInst),
    Test3 = ?_assertEqual(OnOffState3, on),

    %It should be also checked that the pump shuts off again
    pumpInst:switch_off(PumpInst),
    %Now, the pump should be turned off
    {ok, OnOffState4} = pumpInst:is_on(PumpInst),
    Test4 = ?_assertEqual(OnOffState4, off),

    %It should be also checked that the pump will stay shuts off when switch_off is used again
    pumpInst:switch_off(PumpInst),
    %Now, the pump should be turned off
    {ok, OnOffState5} = pumpInst:is_on(PumpInst),
    Test5 = ?_assertEqual(OnOffState5, off),

    [FirstTests, Test2, Test3, Test4, Test5].

checkPumpFlowInfluence({_PipeTypePID,_Pipes,_Connectors,_Locations,_FluidumTyp,_Fluidum, PumpTypePID, PumpInst}) ->
    %The pump should be turned off, lets check that first
    {ok, OnOffState} = pumpInst:is_on(PumpInst),
    FirstTests = [
        ?_assert(erlang:is_process_alive(PumpTypePID)), %These are not necessary but done to be complete
        ?_assert(erlang:is_process_alive(PumpInst)),
        ?_assertEqual(OnOffState,off)],

    %A basic flow has to be set
    Flow = 5,    

    %The flow should be zero now
    {ok, FlowOff} = pumpInst:flow_influence(PumpInst),
    FlowReferenceOff = 0, %Here could also the same formula as FlowReferenceOn be used, this should ofcourse also give 0
    TestFlowOff = ?_assertEqual(FlowOff(Flow), FlowReferenceOff),

    %Now the pump is turned on and the flow is checked
    pumpInst:switch_on(PumpInst),
    {ok, OnOffState2} = pumpInst:is_on(PumpInst),
    TestPumpOn = ?_assertEqual(OnOffState2,on),

    {ok, FlowOn} = pumpInst:flow_influence(PumpInst),
    FlowReferenceOn = 250 - 5 * Flow - 2 * Flow * Flow,
    TestFlowOn = ?_assertEqual(FlowOn(Flow), FlowReferenceOn),
    
    [FirstTests, TestFlowOff, TestPumpOn, TestFlowOn].

checkFlowmeter({_PipeTypePID, Pipes,_Connectors,_Locations,_FluidumTyp,_Fluidum,_PumpTypePID,_PumpInst, FlowMeterTypePID, FlowMeterInst}) ->
    [Pipe1, Pipe2, Pipe3|_RestPipes] = Pipes,
    %First check if the processes are alive
    FirstTests = [
        ?_assert(erlang:is_process_alive(FlowMeterTypePID)),
        ?_assert(erlang:is_process_alive(FlowMeterInst))],
    
    %If the processes are alive, the functionality of the flowmeter can get tested
    {ok, FlowMeasured} = flowMeterInst:measure_flow(FlowMeterInst),
    Test2 = ?_assertEqual(FlowMeasured,{ok,real_flow}), %Why does this not work with just real_flow?

    %Testing the estimated value
    {ok, EstFlow} = flowMeterInst:estimate_flow(FlowMeterInst),
    {ok, Ref1} = apply(resource_instance, get_flow_influence, [Pipe1]),
    {ok, Ref2} = apply(resource_instance, get_flow_influence, [Pipe2]),
    {ok, Ref3} = apply(resource_instance, get_flow_influence, [Pipe3]),
    RefList = [Ref1, Ref2, Ref3],
    Interval = {0, 10},
	RefFlow = compute(Interval, RefList),
    Test3 = ?_assertEqual(EstFlow, RefFlow), 

    [FirstTests, Test2, Test3].

checkHeatEx({_PipeTypePID,_Pipes,_Connectors,_Locations,_FluidumTyp,_Fluidum,_PumpTypePID,_PumpInst,_FlowMeterTypePID,_FlowMeterInst, HeatExTypePID, HeatExInst}) ->
    %First check if the processes of the heatex are alive
    FirstTests = [
        ?_assert(erlang:is_process_alive(HeatExTypePID)),
        ?_assert(erlang:is_process_alive(HeatExInst))],

    %The heatexchangers temp_influence(HeatExchangerInst_Pid) function is tested
    {ok, {ok,Influence}} = heatExchangerInst:temp_influence(HeatExInst),
    Flow = 5,
    Difference = 1,
    Temp = 20,
    {ok, HeatExInfluence} = Influence(Flow, Temp),
    CalculateInfluence = Temp + (Difference/Flow),
    TestInfluence = ?_assertEqual(HeatExInfluence, CalculateInfluence),

    [FirstTests, TestInfluence].



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
