projectTagp
=====

An OTP application

Build
-----

    $ rebar3 clean
    $ rebar3 compile

or to also get the shell

    $ rebar3 clean
    $ rebar3 shell

## Dialyzer tests
Dialyzer test are done, it did not find any warnings. It does only check each file on its own so it won't check any functions that are called in another .erl-file.

## EUnit tests
### Testing on testModule and testModule2. 
#### Test startSimpleTest() in testModule2 or start() in testModule
This function makes 3 pipes and connects them together.
Tests to check if the processes are running when testModule:start() is done, and also tests if they have stopped when testModule:stop() is done.

#### Test startNPipes(N) in testModule2
This function makes N pipes and connects them all together.
The tests check if only the first 3 pipes with their connectors and locations are active.
It also checks how many pipes, connectors and locations are made.
If this amount is equal to what is expected, then it is assumed that everything has been made right.

*This test only works when 3 or more pipes are used! In the final setup, there will always be at least 3 pipes so this is no problem*

#### Test startSimpleTestFluidum() in testModule2
This function makes 3 pipes and connects them together just like in startSimpleTest().
It then ads a fluidum to the system.

#### Test startSimpleTestFluidumPump() in testModule2
This function first does the same as startSimpleTestFluidum().
Afterwards it will also add a pump to the system.
This pump is tested on shutting it on and off and the flow through the system.

#### Test startSimpleTestFluidumPumpFlowMeter() in testModule2
This function first does the same as startSimpleTestFluidumPump().
Afterwards it adds a flowmeter to the system.
This flowmeter gives a measure flow and an estimated flow. These are not tested propperly yet.
