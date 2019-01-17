-module(prop_digitalTwin).
-include_lib("proper/include/proper.hrl").

% The survivor gets started in the first test and gets closed in the last test
% This means that not every test a new survivor is created, this means less chance of crashing the survivor

prop_testFlowInfluence() ->

    %Because starting and stopping the survivor a lot of times can cause a crash.
    %The survivor gets started only once here and all the pipes,... get put in one table.    
    %testModule2:startSurvivor(),
    io:format("Flow influence gets tested in testModule2~n"),
    survivor2:start(),
    Tests = ?FORALL(Flow, integer(0,1000),testFlowInfluence(Flow)),

    %The survivor cannot be stopped immediatly
    %therefor the timer is used to delay the stop with a second
    %timer:send_after(1000, survivor, stop),
    %testModule2:stop(),
    Tests.

prop_testEstimatedFlow() ->
    %digitalTwin:startSurvivor(),
    %survivor2:start(),
    Tests = ?FORALL(NPipes, integer(3,30), testEstimatedFlow(NPipes)),
   % timer:send_after(1000, survivor, stop),
    Tests.

%The heatexchangers changes the temperature based on the flow and the difference
%First the influence of the temperature will be tested with a Flow of 1 and a difference of 1
prop_testHeatExTempInfluence() ->
    %survivor2:start(),
    Tests = ?FORALL(Temp, integer(0,100), testHeatExTempInfluence(Temp)),
    %timer:send_after(1000, survivor, stop),
    Tests.

prop_testHeatExFlowInfluence() ->
    %survivor2:start(),
    Tests = ?FORALL(Flow, integer(1,100), testHeatExFlowInfluence(Flow)), % Goes from 1-100 because 0 is impossible with the pumps on
    %timer:send_after(1000, survivor, stop),
    Tests.

prop_testHeatExDifferenceInfluence() ->
    %survivor2:start(),
    Tests = ?FORALL(Difference, integer(0,100), testHeatExDifferenceInfluence(Difference)), 
    timer:send_after(1000, survivor, stop),
    Tests.

%===========================================================================================
%HELP FUNCTIONS
%===========================================================================================

testFlowInfluence(Flow)->
    N = 5,
    DifferenceHeatEx = [1.5, 0.5],
    {ok, {_Types,_Pipes,_Connectors,_Locations,_FluidumInst, Pumps,_FlowMeter,_HeatExchangers}} = digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(N, 1, 1, DifferenceHeatEx),
    [PumpInst|_Rest] = Pumps,
    pumpInst:switch_on(PumpInst),
    {ok, InfluenceFunction} = pumpInst:flow_influence(PumpInst),
    Influence = InfluenceFunction(Flow),
    InfluenceRef = 250 - 5*Flow-2*Flow*Flow,
    Influence == InfluenceRef.


testEstimatedFlow(N) ->
    DifferenceHeatEx = [1.5, 0.5], 
    %Makes a system with one pump, one flowmeter and one heatex but with more pipes to influence the flow
    {ok, {_Types, Pipes,_Connectors,_Locations,_FluidumInst,_Pumps, FlowMeter,_HeatExchangers}} = digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(N, 1, 1, DifferenceHeatEx),
    {ok, EstFlow} = flowMeterInst:estimate_flow(FlowMeter),
    %io:format("dit is de EstFlow: ~p~n", [EstFlow]),
    %io:format("dit is de lijst van Pipes: ~p~n", [Pipes]),
    %Return the RefList for every pipe in the system
    RefList = digitalTwin_tests:findRefList(Pipes, []),
    Interval = {0, 10},
	RefFlow = digitalTwin_tests:compute(Interval, RefList),
    %io:format("dit is de RefFlow: ~p~n", [RefFlow]),
    timer:sleep(1),
    RefFlow==EstFlow.

testHeatExTempInfluence(Temp) ->
    N = 5,
    DifferenceHeatEx = [1, 0.5], %The 0.5 has no influence because it is never used
    {ok, {_Types,_Pipes,_Connectors,_Locations,_FluidumInst,_Pumps,_FlowMeter, HeatExchangers}} = digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(N, 1, 1, DifferenceHeatEx),
    
    %There is only one heatexchanger made and with all the tests done, checking one is good enough for this system
    [CheckHeatEx |_Other] = HeatExchangers,
    Flow = 1,
    [Difference | _Rest] = DifferenceHeatEx,
    {ok, {ok,Influence}} = heatExchangerInst:temp_influence(CheckHeatEx),
    {ok, HeatExInfluence} = Influence(Flow, Temp),
    CalculateInfluence = Temp + (Difference/Flow),
    HeatExInfluence ==CalculateInfluence.

testHeatExFlowInfluence(Flow) ->
    N = 5,
    DifferenceHeatEx = [1, 0.5], %The 0.5 has no influence because it is never used
    {ok, {_Types,_Pipes,_Connectors,_Locations,_FluidumInst,_Pumps,_FlowMeter, HeatExchangers}} = digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(N, 1, 1, DifferenceHeatEx),
    
    %There is only one heatexchanger made and with all the tests done, checking one is good enough for this system
    [CheckHeatEx |_Other] = HeatExchangers,
    Temp = 20,
    [Difference | _Rest] = DifferenceHeatEx,
    {ok, {ok,Influence}} = heatExchangerInst:temp_influence(CheckHeatEx),
    {ok, HeatExInfluence} = Influence(Flow, Temp),
    CalculateInfluence = Temp + (Difference/Flow),
    HeatExInfluence ==CalculateInfluence.

testHeatExDifferenceInfluence(Difference) ->
    N = 5,
    DifferenceHeatEx = [Difference, 0.5], %The 0.5 has no influence because it is never used
    {ok, {_Types,_Pipes,_Connectors,_Locations,_FluidumInst,_Pumps,_FlowMeter, HeatExchangers}} = digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(N, 1, 1, DifferenceHeatEx),
    
    %There is only one heatexchanger made and with all the tests done, checking one is good enough for this system
    [CheckHeatEx |_Other] = HeatExchangers,
    Temp = 20,
    Flow = 1,
    [Difference | _Rest] = DifferenceHeatEx,
    {ok, {ok,Influence}} = heatExchangerInst:temp_influence(CheckHeatEx),
    {ok, HeatExInfluence} = Influence(Flow, Temp),
    CalculateInfluence = Temp + (Difference/Flow),
    HeatExInfluence ==CalculateInfluence.
