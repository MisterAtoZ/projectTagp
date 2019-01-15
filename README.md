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

## testModule and testModule2
These two files are used to build the system step by step. With adding new functions to the circuit, more tests were added.
These two files form the basis of digitalTwin.erl.

## digitalTwin
This is the file where the digital twin system gets build. It can make a system with N pipes, P Pumps, M Heatexchangers and 1 flowmeter. To make this system, the amount of pipes needs to be atleast the amount of the sum of the pumps, heatexchangers and the flowmeter. 

## Dialyzer tests
Dialyzer test are done, it did not find any warnings. It does only check each file on its own so it won't check any functions that are called in another .erl-file.

To use these tests the following command was used:

    $ rebar3 dialyzer

### Dialyzer tests of digitalTwin
While all the eunit tests of the digitalTwin were working, the dialyzertest of it gave some faults. It gave a fault at this line: *PipeList = [PipeList | PipeInstPID],*. The fault was that an improper list was made. To solve the fault, the line was replaced with: *NewPipeList = PipeList ++[PipeInstPID],*. This solved these issues with the help of the dialyzer that eunit could not found.

## EUnit tests
The EUnit tests run with the following commands:

    $ rebar3 eunit

The eunit command can also be put in projectTagp_sup.erl and then the command *rebar3 shell* can be used.
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

#### Test startSimpleTestFluidumPumpFlowMeterHeatEx() in testModule2
This function does the same as startSimpleTestFluidumPumpFlowMeter().
Afterwards it adds a Heatexchanger to the system.
This Heatexchanger influences the temperature of the system.
The influence is tested.

### Testing on digitalTwin
#### Test startNPipesPPumpsOFlowMetersMHeatex(N, P, M)
This funcion builds the whole circuit. All the tests used in testModule and testModule2 are used to test this module.

## PropEr Tests
Proper is used to test generate a lot of system with a different amount of pipes, pumps,.... 

The command used is:

    $ rebar3 proper

### PropEr tests of testModule2
There is the PropEr test for testModule2, this test checks the flow influence.

#### prop_testFlowInfluence()
This function checks if the flow of the system with the calculated value, for the value of flow an integer between 0 and 1000.
This makes it a better check than with eunit because a random integer between 0 and 1000 is used to test.

### PropEr tests of digitalTwin
These PropEr tests are for the digitalTwin.

#### prop_testFlowInfluence()
This function is the same as in testModule2. It checks if the flow of the system with the calculated value, for the value of flow an integer between 0 and 1000.
This makes it a better check than with eunit because a random integer between 0 and 1000 is used to test.

#### prop_testEstimatedFlow()
This function generates a system with one pump, one flowmeter, one heatexchanger and a random amount of pipes between the two chosen values, here is opted for a value between 3 and 30. The lower value is chosen because there is one pump, one flowmeter and one heatexchanger. As explained above, the amount of pipes needs to be atleast the amount of the sum of pumps, heatexchangers and the flowmeter. 
