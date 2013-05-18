# Scenarios - iOS Acceptance Testing

## Overview
Scenarios (Scenar-iOS, see what I did there?) is an application that handles running acceptance tests for iOS apps from the command-line.

Record interactions with your iOS app using Instruments, then package the JavaScript output as test files.  Scenarios enables you to easily run a collection of tests against simulated and hardware app installs, from the command-line, by running the following steps:

* Cleans any previous app installs from the target device
* Builds the latest version of the app
* Installs the app on the target device
* Runs [Tuneup_js](https://github.com/alexvollmer/tuneup_js) formatted tests against the installed app
* Reports the test results

Here's what the sample app & tests included with this project look like running on a simulator:

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
Scenarios supports tests written using Apple's UI Automation JavaScript library, and formatted using Tuneup_js' test structure.

First, create an empty test file with the prefix:

    *_test.js

e.g. login_test.js

Edit the file to add the required import statement and a stub test:

    #import "support/scenarios.js"

    test("My first test", function(target, app) {
      // Your test code will go here
    })

Now to generate the test content.

### Automatically generating test content
To generate test content by interacting with your app, do the following:

* With your application open in Xcode, select "Product" > "Profile".
* Instruments should launch. Select "Automation" from the "iOS Simulator" section, and click "Profile".
* Instruments will automatically launch the simulator and install your app.  Once this is complete, under "Scripts", select "Add" > "Create".
* Click the red "record" button from the script pane to begin collecting interactions with your app.
* Perform actions and observer JavaScript being recorded in the Instruments window.
* Copy recorded actions into the empty test class created in the step above.

Read more about using Instruments [here](http://developer.apple.com/library/mac/#documentation/developertools/Conceptual/InstrumentsUserGuide/UsingtheAutomationInstrument/UsingtheAutomationInstrument.html#//apple_ref/doc/uid/TP40004652-CH20-SW1).

### Manually writing test content
Tuneup_js is a JavaScript library which builds upon the UIAutomation library provided by Apple.  You can read more about the project and supported assertions [here](https://github.com/alexvollmer/Tuneup_js).

### Additions to Tuneup_js
Alongside the Tuneup_js library, Scenarios also adds two new test features:

* withTimout: use this for potentially long-running calls (e.g. a button click to login, where the API may be slow)
* slowTap();  Allows for slowing-down the speed at which taps are executed.  This helps to a) see what tests are doing, b) help mimic human behaviour (those tests can move pretty fast otherwise!)

## Running tests

To run the tests on a simulator, run the following (substituting as required):

    ./run --ios-app-name 'YOUR APP (CFBundleName) NAME' --ios-app-path /path/to/xcodeproject/ --tests-path /path/to/tests/ --tests-output-path /path/to/output/folder/

## Credits
Scenarios makes use of the following applications:

* Tuneup_js: https://github.com/alexvollmer/Tuneup_js
* Ios-sim: https://github.com/phonegap/ios-sim
* Transporter-Chief: http://gamua.com/img/blog/2012/transporter_chief.zip

## Help

To see all options:

    bin/run --help
