-module(survivor).
-export([start/0, delete/1, entry/1, init/0]). 

start() ->
	register(survivor, spawn(?MODULE, init, [])).

delete(LT) -> %added this function, this works 
    ets:delete(LT, self()).

entry(Data)-> 
	ets:insert(logboek, {{self()}, Data}). 

init() -> 
	ets:new(logboek, [named_table, ordered_set, public]),		
	loop().

loop() -> 
	receive
		stop -> ok;
		'_' -> ok %ets:delete(logboek) %ok %added the delete, because logboek was not always gone!
	end. 
