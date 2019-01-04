-module(testModule).
-export([start/0, stop/0]).


start() ->
	survivor2:start(),
	%survivor:start(),
	%observer:start(),
	{ok, PipeTypePID} = resource_type:create(pipeTyp,[]),
	{ok,Pipe1InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe2InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,Pipe3InstPID} = resource_instance:create(pipeInst,[self(),PipeTypePID]),
	{ok,[P1C1,P1C2]} = resource_instance:list_connectors(Pipe1InstPID),
	{ok,[P2C1,P2C2]} = resource_instance:list_connectors(Pipe2InstPID),
	{ok,[P3C1,P3C2]} = resource_instance:list_connectors(Pipe3InstPID),

	{ok,[Location1]} = resource_instance:list_locations(Pipe1InstPID),
	{ok,[Location2]} = resource_instance:list_locations(Pipe2InstPID),
	{ok,[Location3]} = resource_instance:list_locations(Pipe3InstPID),
	
	io:format("~p is the location of pipe1 ~n", [Location1]),
	io:format("~p is the location of pipe2 ~n", [Location2]),
	io:format("~p is the location of pipe2 ~n", [Location3]),

	connector:connect(P2C2,P3C1),
	connector:connect(P1C1,P3C2),
	connector:connect(P1C2,P2C1),

	Pipes = [Pipe1InstPID, Pipe2InstPID, Pipe3InstPID],
	Connectors = [[P2C2, P3C1], [P1C1, P3C2], [P1C2, P2C1]],
	Locations = [Location1, Location2, Location3],
	{ok, {Pipe1InstPID, Pipes, Connectors, Locations}}.

stop() ->
	survivor ! stop,
	{ok, stopped}.
