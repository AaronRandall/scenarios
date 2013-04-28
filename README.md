# Scenarios - iOS App Acceptance Testing

## What
Scenarios (Scenar-iOS, geddit?) is an application that handles running iOS acceptance tests, on a simulator or physical device. 

Record interactions with your iOS app using Instruments, then package that output as tests.  Scenarios enables you to easily run a collection of tests against simulated and real app installs, and can be used ad-hoc, or connected to a continuous integration server.

Demo here.

## Prerequisites

You will need:
* A mac
* Xcode (tested on 4.6.x)
* ios-sim ("brew install ios-sim")

## Run the samples on a simulator
    bin/sample_simulator

(Note that the first time you run the tests you may be asked for your password for developer tools).

## Running the sample on hardware
To run tests against hardware, first you should make sure your hardware is part of your provisioning profile.

Open your xcode project and run against the hardware.  If this works, you're good to go with:

    bin/sample_hardware

## Creating new tests

Checkout the iOS project, and select "Product" > "Profile".
Instruments should launch. Select "Automation" from the "iOS Simulator" section, and click "Profile".
Under "Choose Target", select "Choose Target" > "AppName".
Under "Scripts", select "Add" > "Create".
Click the red Record button at the bottom of the Instruments window.  The simulator should launch.
Perform some actions (you should see JavaScript being recorded in the Instruments window).
Copy actions into step_definitions.

Read more here: http://developer.apple.com/library/mac/#documentation/developertools/Conceptual/InstrumentsUserGuide/UsingtheAutomationInstrument/UsingtheAutomationInstrument.html#//apple_ref/doc/uid/TP40004652-CH20-SW1

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

See all options:

    bin/run --help
