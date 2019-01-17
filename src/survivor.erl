-module(survivor).
-export([start/0, entry/1, init/0]). 

-spec start() -> 'true'.
-spec entry(_) -> 'true'.
-spec init() -> 'ok'.
-spec delete() -> 'true'.
-spec loop() -> 'ok'.


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
	unregister(survivor).
	%loop().

loop() -> 
	receive
		stop -> delete(), ok
	end. 
