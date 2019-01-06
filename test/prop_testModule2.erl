-module(prop_testModule2).
-include_lib("proper/include/proper.hrl").

prop_test() ->
    ?FORALL(Type, term(),
        begin
            boolean(Type)
        end).

prop_testFlowInfluence() ->

    %Because starting and stopping the survivor a lot of times can cause a crash.
    %The survivor gets started only once here and all the pipes,... get put in one table.    
    %testModule2:startSurvivor(),
    survivor2:start(),
    Tests = ?FORALL(Flow, integer(0,1000),testFlowInfluence(Flow)),

    %The survivor cannot be stopped immediatly
    %therefor the timer is used to delay the stop with a second
    timer:send_after(1000, survivor, stop),
    %testModule2:stop(),
    Tests.

prop_testVoorLaurens() ->
    ?EXISTS(Integer,integer(0,10),(Integer rem 2) /= 0).

boolean(_) -> true.

testFlowInfluence(Flow)->
    {ok, {_PipeTypePID,_Pipes,_Connectors,_Locations,_FluidumTyp,_Fluidum,_PumpTypePID, PumpInst}} = testModule2:startSimpleTestFluidumPump(),
    pumpInst:switch_on(PumpInst),
    {ok, InfluenceFunction} = pumpInst:flow_influence(PumpInst),
    Influence = InfluenceFunction(Flow),
    InfluenceRef = 250 - 5*Flow-2*Flow*Flow,
    Influence == InfluenceRef.

