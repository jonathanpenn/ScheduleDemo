Schedule (a UI Automation Demonstration)
========================================

This demo app pulls from a fake JSON feed scraped from the CocoaConf 2013 Chicago schedule. I use it to live demonstrate writing automation tests for behavior and performance against an application that uses Core Data and external network services.

## Walkthrough

In my talk, I go through several steps to build up some simple tests for this app that we eventually run from the command line on both the simulator and an attached iOS device.

### Step 1 - Favoriting sessions

The file `automation/step1.js` is a script that tests the application to make sure you can swipe to favorite the first session, that favorited sessions show up in the favorites tab, and that swiping to unfavorite a session in the favorites tab makes it vanish. This is a raw script of all the UI Automation commands that get refactored over the next few steps.

### Step 2 - Group output, simplify assertions

The file `automation/step2.js` starts the refactoring process by importing a reusable testing environment in `automation/env.js` that defines a few helper functions to make our testing a little easier. We wrap our test activity in a function we pass to a `test()` function that wraps our output in a log group. And we define a simple assertion function that throws the error for us if the given value isn't true.

### Step 3 - Describing the app with screen objects

Just like UI Automation exposes individual UI elements to us through an object interface, we build objects that represent screens the user interact with. These screen objects use the simplest form of prototypical inheritance to share common behavior with a base `Screen` prototype, and the methods are composed into higher level methods that act and assert on the screen.

You can see this in action in `automation/test_favorites.js`.

### Step 4 - Performance testing

Using the language of our screen objects, we can build simple automation scripts that help us discover performance bugs. The `automation/performance.js` script is used in an Instruments document that has the UI Automation and Allocations instrument to recreate the steps to expose a memory leak in the `CMSFlipThroughContainerViewController`.

### Step 5 - External Dependencies

Our tests are brittle because they depend on the starting state of the app and on a network resource we don't control. This step demonstrates using environment variables to direct the `CMSTestSetup` object to reset our Core Data database and stub the `CMSDataLoader` so that it pulls from a JSON file and image file in the bundle instead of from the network. Run the app with the `ScheduleUITests` scheme, and the app will be completely isolated for the tests.

### Step 6 - Command Line

The `test_run.sh` is the raw commands to build the app for the simulator, run the `test_favorites.js` automation script in the simulator, and then run that same automation script on an attached device. The device needs to have the app already built and installed with the `ScheduleUITests` scheme, before that part of the script works.

The `Rakefile` is a Ruby script for the `rake` command that comes with OS X. In it, I take the raw commands in `test_run.sh` and abstract them into two Rake tasks to make it easier to run several tests. By simply running:

    rake

...from the command line, the app is built and automation tests run in the simulator. For effect, I've written two more behavior tests that are run as well.

These tests can easily be run on an attached device. Just make sure the app is installed on the device already, and type this at the commadn line:

    rake device

That will trigger Instruments to run the application on the attached device and execute the three behavior test scripts one after the other.


## Contact

Questions? Ask!

Jonathan Penn

- http://cocoamanifest.net
- http://github.com/jonathanpenn
- http://twitter.com/jonathanpenn
- http://alpha.app.net/jonathanpenn
- jonathan@cocoamanifest.net

## License

Schedule is available under the MIT license. See the LICENSE file for more info.

