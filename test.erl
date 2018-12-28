-module(test).
-export([foo/0]).

-type thing_id()::{thing_id, integer()}.
-type user_id()::{user_id, integer()}.

-spec tuplefy(ThingId::thing_id(), UserId::user_id()) -> {thing_id(), user_id()}.
-spec foo() -> {thing_id(), user_id()}.

tuplefy(ThingId, UserId) ->
  {ThingId, UserId}.

foo() ->
  tuplefy({thing_id, 1}, {user_id, 2}).
