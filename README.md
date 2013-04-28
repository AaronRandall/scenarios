# iOS App Acceptance Tests

## What
An application to handle running iOS acceptance tests, in a simulator or hardware device.
Brings together functionality from ios-sim, fruitstrap, transporter-chief, tuneup_js.
Sample app courtesy of ...

## Prerequisites

You will need:
A mac
Xcode (tested on 4.6.x)
ios-sim ("brew install ios-sim")


## Run the samples
bin/run --ios-app-name 'TableViewIOS5Demo' --ios-app-path sample/app/ --tests-path sample/tests/ --tests-output-path sample/output/

Note that the first time you run the tests you may be asked for your password for developer tools.

## Running the sample on hardware
To run tests against hardware, first you should make sure your hardware is part of your provisioning profile.

Open your xcode project and run against the hardware.  If this works, you're good to go with:

command here


## Running all tests

To run all acceptance tests (substituting your app path and simulator path as required, using full paths):

## Running individual tests

To run individual acceptance tests (substituting your app path and simulator path as required, using full paths):


## Recording new tests

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

## Help

See all test options:

    bin/run --help

