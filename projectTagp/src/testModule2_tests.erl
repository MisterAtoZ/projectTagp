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
% startSimpleTest_test_() ->
%     {"Starting and stopping the system",
%     {foreach, %here is a foreach used to test if the stop function also works
%         fun return_startSimpleTest/0,
%         fun stop/1, %after each test, the survivor gets stopped, because only one survivor can exist
%         [fun checkPipes/1]
%     }}.

% startNPipes_test_() ->
%     {"Tests if N Pipes are made and if they exist",
%     {setup,
%         fun return_startNPipes/0,
%         fun stop/1,
%         fun checkNPipes/1
%     }}.

% startSimpleTestFluidum_test_() ->
%     {"Tests if the network is created and if the fluidum is added",
%     {setup,
%         fun return_startSimpleTestFluidum/0,
%         fun stop/1,
%         fun checkPipesWithFluidum/1
%     }}.

% startSimpleTestFluidumPump_test_() ->
%     {"Tests if the network is created with a pump and if there is a fluidum",
%     {setup,
%         fun return_startSimpleTestFluidumPump/0,
%         fun stop/1,
%         fun({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}) ->
%             [
%                 checkPipesWithFluidumPump({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}),
%                 checkPumpFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}),
%                 checkPumpFlowInfluence({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst})
%             ]
%         end
%     }}.

startSimpleTestFluidumPumpFlowMeter_test_() ->
    {"Test if the network is created with 3 pipes, pump and Flowmeter",
    {setup,
        fun return_startSimpleTestFluidumPumpFlowMeter/0,
        fun stop/1,
        fun({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst}) ->
            [
                %The same as the previous testbuild are done for completion
                checkPipesWithFluidumPump({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}), 
                checkPumpFunctions({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}),
                checkPumpFlowInfluence({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}),
                %The new tests to check the FlowMeter
                checkFlowmeter({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst})
            ]
        end
    }}.

%===========================================================================================
%SETUP FUNCTIONS
%===========================================================================================

%The processes need to be started/stopped, this happens here
return_startSimpleTest() ->
    {ok, {PipeTypePID, Pipes, Connectors, Locations}} = testModule2:startSimpleTest(),
    {PipeTypePID, Pipes, Connectors, Locations}.

stop(_) ->
    testModule2:stop().

return_startNPipes() ->
    N = 5, %Has to be atleast 3! 
    {ok, {PipeTypePID, Pipes, Connectors, Location}} = testModule2:startNPipes(N),
    {PipeTypePID, Pipes, Connectors, Location, N}.

return_startSimpleTestFluidum() ->
    {ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum}} = testModule2:startSimpleTestFluidum(),
    {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum}.

return_startSimpleTestFluidumPump() ->
    {ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}} = testModule2:startSimpleTestFluidumPump(),
    {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}.

return_startSimpleTestFluidumPumpFlowMeter() ->
    {ok, {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst}} = testModule2:startSimpleTestFluidumPumpFlowMeter(),
    {PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst, FlowMeterTypePID, FlowMeterInst}.

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

checkPipesWithFluidum({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp,_Fluidum}) ->
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
        ?_assert(erlang:is_process_alive(FluidumTyp))
        %Check something for fluidum
    ].

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

checkFlowmeter({_PipeTypePID,_Pipes,_Connectors,_Locations,_FluidumTyp,_Fluidum,_PumpTypePID,_PumpInst, FlowMeterTypePID, FlowMeterInst}) ->
    %First check if the processes are alive
    FirstTests = [
        ?_assert(erlang:is_process_alive(FlowMeterTypePID)),
        ?_assert(erlang:is_process_alive(FlowMeterInst))],
    
    %If the processes are alive, the functionality of the flowmeter can get tested
    {ok, FlowMeasured} = flowMeterInst:measure_flow(FlowMeterInst),
    Test2 = ?_assertEqual(FlowMeasured,{ok,real_flow}), %Why does this not work with just real_flow?

    %Testing the estimated value
    {ok, EstFlow} = flowMeterInst:estimate_flow(FlowMeterInst),
    Test3 = ?_assertEqual(EstFlow,iets), %This function does not work well

    [FirstTests, Test2],%.
    [FirstTests, Test2, Test3].


%===========================================================================================
%HELP FUNCTIONS
%===========================================================================================

