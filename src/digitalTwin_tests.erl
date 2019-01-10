-module(digitalTwin_tests).
%-define(NOTEST, 1). %This line is to disable the testing for this module
-include_lib("eunit/include/eunit.hrl").

%===========================================================================================
%TESTS DESCRIPTIONS
%===========================================================================================

startNPipesPPumpsOFlowMetersMHeatex_test_() ->
    {"Tests on the digitalTwin",
    {setup,
        fun return_startNPipesPPumpsOFlowMetersMHeatex/0,
        fun stop/1,
        fun({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeters, HeatExchangers, N, P, O, M}) ->
            [
                checkTypesAreAliveAndListsHaveCorrectLength({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeters, HeatExchangers, N, P, O, M}),
                checkAllPipesInst({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeters, HeatExchangers, N, P, O, M}),
                checkAllPumpInst({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeters, HeatExchangers, N, P, O, M})
            ]
        end
    }}.


%===========================================================================================
%SETUP FUNCTIONS
%===========================================================================================

return_startNPipesPPumpsOFlowMetersMHeatex() ->
    N = 10,
    P = 2,
    O = 3, 
    M = 2,
    digitalTwin:startSurvivor(),
    {ok, {Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeters, HeatExchangers}} = digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(N, P, O, M),
    {Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeters, HeatExchangers, N, P, O, M}.

stop(_) ->
    ?debugFmt("Stoppen in digitalTwin_tests-file",[]),
    digitalTwin:stop().

%===========================================================================================
%THE ACTUAL TESTS
%===========================================================================================

checkTypesAreAliveAndListsHaveCorrectLength({Types, Pipes, Connectors, Locations, FluidumInst, Pumps, FlowMeters, HeatExchangers, N, P, O, M}) ->
    %Only the first three pipes get checked if they really exist, if they are okay, the rest will also be good
    [PipeTypePID, FluidumType, PumpTypePID, FlowMeterTypePID, HeatExTypePID] = Types,

    % [Pipe1, Pipe2, Pipe3|_RestPipes] = Pipes,
    % [C11,C12,C21,C22,C31,C32|_RestConnectors] = Connectors,
    % [Location1, Location2, Location3|_RestLocations] = Locations,

    % %Check all the PumpInsts
    % Q = length(Pumps),
    % {ok, TestsPumpInst} = checkAllPumps(Q, Pumps, []),
    %Check if the processes of the first three pipes are running
    %If all the tests pass, all the processes are running
    [
        %All the alive tests for pipes
        ?_assert(erlang:is_process_alive(PipeTypePID)),
        ?_assert(erlang:is_process_alive(FluidumType)),
        ?_assert(erlang:is_process_alive(PumpTypePID)),
        ?_assert(erlang:is_process_alive(FlowMeterTypePID)),
        ?_assert(erlang:is_process_alive(HeatExTypePID)),
        % ?_assert(erlang:is_process_alive(Pipe1)),
        % ?_assert(erlang:is_process_alive(Pipe2)),
        % ?_assert(erlang:is_process_alive(Pipe3)),
        % ?_assert(erlang:is_process_alive(C11)),
        % ?_assert(erlang:is_process_alive(C12)),
        % ?_assert(erlang:is_process_alive(C21)),
        % ?_assert(erlang:is_process_alive(C22)),
        % ?_assert(erlang:is_process_alive(C31)),
        % ?_assert(erlang:is_process_alive(C32)),
        % ?_assert(erlang:is_process_alive(Location1)),
        % ?_assert(erlang:is_process_alive(Location2)),
        % ?_assert(erlang:is_process_alive(Location3)),
        ?_assertEqual(N, length(Pipes)), %these should be the same
        ?_assertEqual(2*N, length(Connectors)), %there are 2 connectors per pipe
        ?_assertEqual(N, length(Locations)),
        %All the alive tests for fluidum
        ?_assert(erlang:is_process_alive(FluidumType)),
        ?_assert(erlang:is_process_alive(FluidumInst)),
        ?_assertEqual(P, length(Pumps)),
        %?_assertEqual(O, length(FlowMeters)), %Flowmeters are not working yet
        ?_assertEqual(M, length(HeatExchangers))
    ].

%--------------------------------------------------------------------------------------------------------------------------------
%Tests of the pipeInsts

checkAllPipesInst({_Types, Pipes, Connectors, Locations,_FluidumInst,_Pumps,_FlowMeters,_HeatExchangers, N,_P,_O,_M}) ->
    Q = length(Pipes),
    checkAllPipesInst(Q, Pipes, Connectors, Locations, []).

checkAllPipesInst(1, PipesToDo, ConnectorsToDo, LocationsToDo, TestsPipeInst) ->
    [CheckPipeInst | _ToDoPipes] = PipesToDo,

    NewTestsPumpInst = [TestsPipeInst | ?_assert(erlang:is_process_alive(CheckPipeInst))],
    NewTestsPumpInst;

checkAllPipesInst(Q, PipesToDo, ConnectorsToDo, LocationsToDo, TestsPipeInst) ->
    [CheckPipeInst | ToDoPipes] = PipesToDo,

    NewTestsPumpInst = [TestsPipeInst | ?_assert(erlang:is_process_alive(CheckPipeInst))],
    checkAllPipesInst(Q-1, ToDoPipes, ConnectorsToDo, LocationsToDo, NewTestsPumpInst).

%--------------------------------------------------------------------------------------------------------------------------------
%Tests of the pumpInsts

checkAllPumpInst({_Types,_Pipes,_Connectors,_Locations,_FluidumInst, Pumps,_FlowMeters,_HeatExchangers,_N, P,_O,_M}) ->
    Q = length(Pumps),
    checkAllPumpInst(Q, Pumps, []).

checkAllPumpInst(1, PumpsToDo, TestsPumpInst) ->
    [CheckPumpInst|_ToDoPumps] = PumpsToDo,
    Test = ?_assert(erlang:is_process_alive(CheckPumpInst)),
    NewTestsPumpInst = [TestsPumpInst|Test],
    
    %Now the functions of the pump will be tests
    %To start, the pump should be off
    {ok, OnOffState} = pumpInst:is_on(CheckPumpInst),
    NewTestsPumpInst2 = [NewTestsPumpInst | ?_assertEqual(OnOffState,off)],

    %Next function checked is to turn the pump on
    pumpInst:switch_on(CheckPumpInst),
    %Now, the pump should be turned on
    {ok, OnOffState2} = pumpInst:is_on(CheckPumpInst),
    NewTestsPumpInst3 = [NewTestsPumpInst2 | ?_assertEqual(OnOffState2, on)],

    %If switch_on is used again, it should still be on
    pumpInst:switch_on(CheckPumpInst),
    %Now, the pump should still be turned on
    {ok, OnOffState3} = pumpInst:is_on(CheckPumpInst),
    NewTestsPumpInst4 = [NewTestsPumpInst3 | ?_assertEqual(OnOffState3, on)],

    %It should be also checked that the pump shuts off again
    pumpInst:switch_off(CheckPumpInst),
    %Now, the pump should be turned off
    {ok, OnOffState4} = pumpInst:is_on(CheckPumpInst),
    NewTestsPumpInst5 = [NewTestsPumpInst4 | ?_assertEqual(OnOffState4, off)],

    %It should be also checked that the pump will stay shuts off when switch_off is used again
    pumpInst:switch_off(CheckPumpInst),
    %Now, the pump should be turned off
    {ok, OnOffState5} = pumpInst:is_on(CheckPumpInst),
    NewTestsPumpInst6 = [NewTestsPumpInst5 | ?_assertEqual(OnOffState5, off)],

    NewTestsPumpInst6;

checkAllPumpInst(Q, PumpsToDo, TestsPumpInst) ->
    if Q > 0 ->
        %Grab the pump to test and check if it is alive
        [CheckPumpInst|_ToDoPumps] = PumpsToDo,
        Test = ?_assert(erlang:is_process_alive(CheckPumpInst)),
        NewTestsPumpInst = [TestsPumpInst|Test],
        %TestsPumpInst = lists:append(TestsPumpInst, [Test]),
        %TestsPumpInst = TestsPumpInst ++[Test],

        %Now the functions of the pump will be tests
        %To start, the pump should be off
        {ok, OnOffState} = pumpInst:is_on(CheckPumpInst),
        NewTestsPumpInst2 = [NewTestsPumpInst | ?_assertEqual(OnOffState,off)],

        %Next function checked is to turn the pump on
        pumpInst:switch_on(CheckPumpInst),
        %Now, the pump should be turned on
        {ok, OnOffState2} = pumpInst:is_on(CheckPumpInst),
        NewTestsPumpInst3 = [NewTestsPumpInst2 | ?_assertEqual(OnOffState2, on)],

        %If switch_on is used again, it should still be on
        pumpInst:switch_on(CheckPumpInst),
        %Now, the pump should still be turned on
        {ok, OnOffState3} = pumpInst:is_on(CheckPumpInst),
        NewTestsPumpInst4 = [NewTestsPumpInst3 | ?_assertEqual(OnOffState3, on)],

        %It should be also checked that the pump shuts off again
        pumpInst:switch_off(CheckPumpInst),
        %Now, the pump should be turned off
        {ok, OnOffState4} = pumpInst:is_on(CheckPumpInst),
        NewTestsPumpInst5 = [NewTestsPumpInst4 | ?_assertEqual(OnOffState4, off)],

        %It should be also checked that the pump will stay shuts off when switch_off is used again
        pumpInst:switch_off(CheckPumpInst),
        %Now, the pump should be turned off
        {ok, OnOffState5} = pumpInst:is_on(CheckPumpInst),
        NewTestsPumpInst6 = [NewTestsPumpInst5 | ?_assertEqual(OnOffState5, off)],

        checkAllPumpInst(Q-1, PumpsToDo, NewTestsPumpInst6);
    true ->
        io:format("P has a negative value!~n"),
	 	{error, "P has a negative value"}
    end.


%===========================================================================================
%HELP FUNCTIONS
%===========================================================================================
