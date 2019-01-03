-module(survivor).
-export([start/0, entry/1, init/0]). 

start() ->
	register(survivor, spawn(?MODULE, init, [])).

entry(Data)-> 
	ets:insert(logboek, {self(), Data}). 

init() -> 
	ets:new(logboek, [named_table, ordered_set, public]),		
	loop().

delete() ->
	ets:delete_all_objects(logboek),
	ets:delete(logboek),
	ok.

loop() -> 
	receive
		stop -> delete(), ok
	end. 
