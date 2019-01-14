-module(prop_digitalTwin).
-include_lib("proper/include/proper.hrl").

prop_testFlowInfluence() ->

    %Because starting and stopping the survivor a lot of times can cause a crash.
    %The survivor gets started only once here and all the pipes,... get put in one table.    
    %testModule2:startSurvivor(),
    io:format("Flow influence gets tested in testModule2~n"),
    survivor2:start(),
    Tests = ?FORALL(Flow, integer(0,1000),testFlowInfluence(Flow)),

    %The survivor cannot be stopped immediatly
    %therefor the timer is used to delay the stop with a second
    timer:send_after(1000, survivor, stop),
    %testModule2:stop(),
    Tests.

prop_testEstimatedFlow() ->
    %digitalTwin:startSurvivor(),
    survivor2:start(),
    Tests = ?FORALL(NPipes, integer(3,30), testEstimatedFlow(NPipes)),
    timer:send_after(1000, survivor, stop),
    Tests.

%===========================================================================================
%HELP FUNCTIONS
%===========================================================================================

testFlowInfluence(Flow)->
    {ok, {_PipeTypePID,_Pipes,_Connectors,_Locations,_FluidumTyp,_Fluidum,_PumpTypePID, PumpInst}} = testModule2:startSimpleTestFluidumPump(),
    pumpInst:switch_on(PumpInst),
    {ok, InfluenceFunction} = pumpInst:flow_influence(PumpInst),
    Influence = InfluenceFunction(Flow),
    InfluenceRef = 250 - 5*Flow-2*Flow*Flow,
    Influence == InfluenceRef.


testEstimatedFlow(N) ->
    %Makes a system with one pump, one flowmeter and one heatex but with more pipes to influence the flow
    {ok, {_Types, Pipes,_Connectors,_Locations,_FluidumInst,_Pumps, FlowMeter,_HeatExchangers}} = digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(N, 1, 1),
    {ok, EstFlow} = flowMeterInst:estimate_flow(FlowMeter),
    %io:format("dit is de EstFlow: ~p~n", [EstFlow]),
    %io:format("dit is de lijst van Pipes: ~p~n", [Pipes]),
    %Return the RefList for every pipe in the system
    RefList = digitalTwin_tests:findRefList(Pipes, []),
    Interval = {0, 10},
	RefFlow = digitalTwin_tests:compute(Interval, RefList),
    io:format("dit is de RefFlow: ~p~n", [RefFlow]),
    timer:sleep(1),
    RefFlow==EstFlow.

