-module(prop_testModule2).
-include_lib("proper/include/proper.hrl").

prop_test() ->
    ?FORALL(Type, term(),
        begin
            boolean(Type)
        end).

prop_testFlowInfluence() ->

    %TO DO dat alleen hier de survivor wordt gestart en gestopt    

    ?FORALL(Flow, integer(0,1000),testFlowInfluence(Flow)).

% prop_testSurvivor() ->
%     ?FORALL(L, integer(0,4711), testSurvivor()).

boolean(_) -> true.

testFlowInfluence(Flow)->
    {ok, {_PipeTypePID,_Pipes,_Connectors,_Locations,_FluidumTyp,_Fluidum,_PumpTypePID, PumpInst}} = testModule2:startSimpleTestFluidumPump(),
    pumpInst:switch_on(PumpInst),
    {ok, InfluenceFunction} = pumpInst:flow_influence(PumpInst),
    Influence = InfluenceFunction(Flow),
    InfluenceRef = 250 - 5*Flow-2*Flow*Flow,
    %testModule2:stop(),
    %survivor ! stop,
    timer:send_after(1000, survivor, stop),
    Influence == InfluenceRef.



