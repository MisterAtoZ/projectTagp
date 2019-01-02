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
        fun checkPipesWithFluidum/1
    }}.

startSimpleTestFluidumPump_test_() ->
    {"Tests if the network is created with a pump and if there is a fluidum",
    {setup,
        fun return_startSimpleTestFluidumPump/0,
        fun stop/1,
        fun checkPipesWithFluidumPump/1
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
    %survivor ! stop, %Double check that the survivor closes
	%{ok, stopped}.

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

checkPipesWithFluidum({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum}) ->
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

checkPipesWithFluidumPump({PipeTypePID, Pipes, Connectors, Locations, FluidumTyp, Fluidum, PumpTypePID, PumpInst}) ->
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
%===========================================================================================
%HELP FUNCTIONS
%===========================================================================================

