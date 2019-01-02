-module(survivor).
-export([start/0, delete/0, entry/1, init/0]). 

start() ->
	register(survivor, spawn(?MODULE, init, [])).

delete() -> %added this function to make sure the tale is deleted, this works 
    ets:delete(logboek).
	%exit(normal).

entry(Data)-> 
	ets:insert(logboek, {{now(), self()}, Data}). 

init() -> 
	ets:new(logboek, [named_table, ordered_set, public]),		
	loop().

loop() -> 
	receive
		stop -> ets:delete(logboek), ok
	end. 
