%%%-------------------------------------------------------------------
%% @doc projectTagp top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(projectTagp_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    observer:start(),
	%survivor2:start(),
    %testModule2:startNPipes(5),
    %testModule:start(),
    %testModule_tests:test(),
    eunit:test(testModule2),
    %testModule2:startSurvivor(),
    %testModule2:startSimpleTestFluidumPump(),
    %digitalTwin:startSurvivor(),
    %testModule2:startSimpleTestFluidumPumpFlowMeter(),
    %digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(8, 3, 2, 2),
    % {ok, FlowMeterTypePID} = flowMeterTyp:create(),
    % digitalTwin:makeFlowMeters(2, [], FlowMeterTypePID, Pipes),
    {ok, {{one_for_all, 0, 1}, []}}.

%%====================================================================
%% Internal functions
%%====================================================================
