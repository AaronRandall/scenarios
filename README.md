# Scenarios - iOS Acceptance Testing

## Overview
Scenarios (Scenar-iOS, geddit?) is an application that handles running acceptance tests for iOS apps, on a simulator or physical device. 

Record interactions with your iOS app using Instruments, then package the output as tests.  Scenarios enables you to easily run a collection of tests against simulated and hardware app installs, and can be used ad-hoc, or connected to a continuous integration server.

Here's what the sample app & tests included with this project look like running on a simulator and iPhone:

Demo video here.

## Prerequisites

You will need:
* A Mac
* Xcode (tested on 4.6)

## Installation

Ensure you have the Xcode command line tools package installed: 

    from Xcode → Preferences → Downloads → Command Line Tools → Install

Install ios-sim via [Homebrew](http://mxcl.github.io/homebrew/): 

    brew install ios-sim

Check-out Scenarios:

    git clone git@github.com:AaronRandall/scenarios.git

## Run the example on a simulator
From a terminal, run:

    scenarios/bin/simulator_example

The first time you run the tests you may be asked for your password for developer tools.

## Run the example on hardware
To run tests against hardware, first you should make sure your hardware is part of your provisioning profile, and then from a terminal, run:

    scenarios/bin/hardware_example

## Writing tests

Checkout the iOS project, and select "Product" > "Profile".
Instruments should launch. Select "Automation" from the "iOS Simulator" section, and click "Profile".
Under "Choose Target", select "Choose Target" > "AppName".
Under "Scripts", select "Add" > "Create".
Click the red Record button at the bottom of the Instruments window.  The simulator should launch.
Perform some actions (you should see JavaScript being recorded in the Instruments window).
Copy actions into step_definitions.

Read more here: http://developer.apple.com/library/mac/#documentation/developertools/Conceptual/InstrumentsUserGuide/UsingtheAutomationInstrument/UsingtheAutomationInstrument.html#//apple_ref/doc/uid/TP40004652-CH20-SW1

Scenarios uses tuneup_fs to format tests.  You can see the markup here: or simply use the output from recording in Instruments.

## Stress-testing

After making changes to the tests, you can perform a "stress test" to make sure the new tests are stable.
This is a simple script that reruns the tests multiple times (either against the simulator or hardware),
and logs any errors.  Edit the script to change the constants as required, then run:

    bin/scripts/stress_test

If errors occur, take a look at the output folder (specified for the runner) for useful error messages and screenshots
of what the app looked like when errors occurred.  You may want to empty this directory before running stress tests.

## Credits
Scenarios makes use of the following applications:

* Ios-sim: https://github.com/phonegap/ios-sim
* Transporter-Chief: http://gamua.com/img/blog/2012/transporter_chief.zip
* Tuneup_js: https://github.com/alexvollmer/tuneup_js

## Help

To see all options:

    bin/run --help
