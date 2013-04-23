# iOS App Acceptance Tests

## What
An application to handle running iOS acceptance tests, in a simulator or hardware device.
Brings together functionality from ios-sim, fruitstrap, transporter-chief, tuneup_js.
Sample app courtesy of https://github.com/Frahaan/2012-Olympics-iOS--iPad-and-iPhone--source-code

## Prerequisites

A mac
Xcode (tested on 4.6.x)
brew install ios-sim

## Run the samples
bin/run --ios-app-name '2012 Olympics' --ios-app-path sample/app/ --tests-path sample/tests/ --tests-output-path sample/output/
## Running all tests

To run all acceptance tests (substituting your app path and simulator path as required, using full paths):

    bundle exec bin/run --ios-app-path "/Users/aaron/src/ios_app/Songkick/" --simulator-path "/Users/aaron/Library/Application\ Support/iPhone\ Simulator/6.0/Applications/"

## Running individual tests

To run individual acceptance tests (substituting your app path and simulator path as required, using full paths):

    bundle exec bin/run --test-name my_test.js --ios-app-path "/Users/aaron/src/ios_app/Songkick/" --simulator-path "/Users/aaron/Library/Application\ Support/iPhone\ Simulator/6.0/Applications/"

## Recording new tests

Checkout the iOS project, and select "Product" > "Profile".
Instruments should launch. Select "Automation" from the "iOS Simulator" section, and click "Profile".
Under "Choose Target", select "Choose Target" > "Songkick".
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

If errors occur, take a look at /SongkickAcceptanceTests/output/ for useful error messages and screenshots
of what the app looked like when errors occurred.  You may want to empty this directory before running stress tests.

## Help

See all test options:

    bundle exec bin/run --help

