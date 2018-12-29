projectTagp
=====

An OTP application

Build
-----

    $ rebar3 compile

or to also get the shell

    $ rebar3 shell

# Dialyzer tests
Dialyzer test are done, it did not find any warnings. It does only check each file on its own so it won't check any functions that are called in another .erl-file.

#EUnit tests
Testing on testModule and testModule2. 
Trying to check if the processes are running when testModule:start() is done, and also check if they have stopped when testModule:stop() is done.
