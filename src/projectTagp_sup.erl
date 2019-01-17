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

-spec start_link() -> 'ignore' | {'error',_} | {'ok',pid()}.
-spec init([]) -> {'ok',{{'one_for_all',0,1},[]}}.


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
    digitalTwin:startSurvivor(),
    DifferenceHeatEx = [1.5, 0.5],
    digitalTwin:startNPipesPPumpsOFlowMetersMHeatex(10, 3, 2, DifferenceHeatEx),
    {ok, {{one_for_all, 0, 1}, []}}.

%%====================================================================
%% Internal functions
%%====================================================================
