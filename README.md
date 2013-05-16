# Scenarios - iOS Acceptance Testing

## Overview
Scenarios (Scenar-iOS, see what I did there?) is an application that handles running acceptance tests for iOS apps, on a simulator or physical device. 

Record interactions with your iOS app using Instruments, then package the output as tests.  Scenarios enables you to easily run a collection of tests against simulated and hardware app installs, and can be used ad-hoc, or connected to a continuous integration server.

Here's what the sample app & tests included with this project look like running on a simulator and iPhone:

[Scenarios demo on YouTube](http://www.youtube.com/watch?v=sdYtScmuWCk)

## Prerequisites

You will need:
* A Mac
* Xcode (tested on 4.6)

## Installation

Ensure you have the Xcode command line tools package installed: 

    Xcode → Preferences → Downloads → Command Line Tools → Install

Install ios-sim via [Homebrew](http://mxcl.github.io/homebrew/): 

    brew install ios-sim

Check-out Scenarios:

    git clone git@github.com:AaronRandall/scenarios.git

## Run the example on a simulator
From a terminal, run:

    scenarios/bin/simulator_example

The first time you run the tests you may be asked for your password for developer tools. Store this in your keychain if you wish to avoid the prompt in the future.

## Run the example on hardware
To run tests against hardware, ensure that your device is correctly setup with a provisioning profile (i.e. you can already deploy and run apps on your device via Xcode), and then from a terminal, run:

    scenarios/bin/hardware_example

# Setting up Scenarios with your project #
If you've successfully installed Scenarios, run the samples, and decided you'd like to use it with your project, complete the following:

## Project structure
Scenarios requires two folders to exist:

* A folder to contain test files
* A folder to record the output of test runs

These folders can be created anywhere, the Scenarios runner will take the paths of these two folders as inputs.  For example, create a 'tests' and 'output' folder in your existing project:

mkdir my_application/tests
mkdir my_application/tests/output

## Creating tests
Scenarios supports tests written using Apple's UI Automation JavaScript library, and tuneup_js.

First, create an empty test file with the prefix:

    *_test.js

e.g. login_test.js

Edit the file to add the required import statmement and a stub test:

    #import "support/scenarios.js"

    test("My first test", function(target, app) {
      // Your test code will go here
    })

Now to generate the test content:

### Automatically generating tests
Checkout the iOS project, and select "Product" > "Profile".
Instruments should launch. Select "Automation" from the "iOS Simulator" section, and click "Profile".
Under "Choose Target", select "Choose Target" > "AppName".
Under "Scripts", select "Add" > "Create".
Click the red Record button at the bottom of the Instruments window.  The simulator should launch.
Perform some actions (you should see JavaScript being recorded in the Instruments window).
Copy actions into step_definitions.

Read more here: http://developer.apple.com/library/mac/#documentation/developertools/Conceptual/InstrumentsUserGuide/UsingtheAutomationInstrument/UsingtheAutomationInstrument.html#//apple_ref/doc/uid/TP40004652-CH20-SW1

### Manually writing tests
Tuneup_js is JavaScript library which builds upon the UIAutomation library provided by Apple.  You can read more about the project and supported assertions here: https://github.com/alexvollmer/tuneup_js

### Additions to tuneup_js
Alongside the tuneup_js library, Scenarios also adds two new test features:

withTimout: use this for potentially long-running calls (e.g. a button click to login, where the API may be slow)
slowTap();  Allows for slowing-down the speed at which taps are executed.  This helps to a) see what tests are doing, b) help mimic human behaviour (those tests can move pretty fast!)

## Running tests

To run the tests on a simulator, run the following (substituting as required):

./run --ios-app-name 'YOUR APP (CFBundleName) NAME' --ios-app-path /path/to/xcodeproject/ --tests-path /path/to/tests/ --tests-output-path /path/to/output/folder/

## Credits
Scenarios makes use of the following applications:

* Tuneup_js: https://github.com/alexvollmer/tuneup_js
* Ios-sim: https://github.com/phonegap/ios-sim
* Transporter-Chief: http://gamua.com/img/blog/2012/transporter_chief.zip

## Help

To see all options:

    bin/run --help
