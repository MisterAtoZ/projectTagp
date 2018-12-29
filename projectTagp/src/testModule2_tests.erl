-module(testModule2_tests).
%-define(NOTEST, 1). %This line is to disable the testing for this module
-include_lib("eunit/include/eunit.hrl").

% -export([reverse_test/0]).
% -export([length_test/0]).
% reverse_test() -> lists:reverse([1,2,3]).
% length_test() -> ?assert(length([1,2,3]) =:= 3).
% basic_test_() ->
%        fun () -> ?assert(1 + 1 =:= 2) end.

%First, the pipes are made, otherwise they can't be checked
start_test_() ->
    {"Starting the system",
    {setup,
    fun return_startNPipes/0,
    %{PipeTypePID, Pipes, Connectors},
    [fun checkPipes/1]
    }    
    }.

%The Pids of the Pipes is needed to check them
return_startNPipes() ->
    {ok, {PipeTypePID, Pipes, Connectors, Locations}} = testModule2:startNPipes(5),
    {PipeTypePID, Pipes, Connectors, Locations}.

%Next, a function to check the pipes, the actual test
%The function needs to know which pipes are used and if they are still running
%The same needs to be done for the connectors
checkPipes({PipeTypePID, Pipes, Connectors, Locations}) ->
    [Pipe1, Pipe2, Pipe3, Pipe4, Pipe5|_RestPipes] = Pipes,
    [[C11, C12], [C21, C22], [C31, C32], [C41, C42], [C51, C52]] = Connectors,
    %Check if the processes are running
    [
        ?_assert(erlang:is_process_alive(PipeTypePID)),
        ?_assert(erlang:is_process_alive(Pipe1)),
        ?_assert(erlang:is_process_alive(Pipe2)),
        ?_assert(erlang:is_process_alive(Pipe3)),
        ?_assert(erlang:is_process_alive(Pipe4)),
        ?_assert(erlang:is_process_alive(Pipe5)),
        ?_assert(erlang:is_process_alive(C11)),
        ?_assert(erlang:is_process_alive(C12)),
        ?_assert(erlang:is_process_alive(C21)),
        ?_assert(erlang:is_process_alive(C22)),
        ?_assert(erlang:is_process_alive(C31)),
        ?_assert(erlang:is_process_alive(C32)),
        ?_assert(erlang:is_process_alive(C41)),
        ?_assert(erlang:is_process_alive(C42)),
        ?_assert(erlang:is_process_alive(C51)),
        ?_assert(erlang:is_process_alive(C52))
    ].
