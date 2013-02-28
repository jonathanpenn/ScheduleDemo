"use strict";

function test(name, steps) {
    UIALogger.logStart(name);
    steps();
    UIALogger.logPass("Done");
}

function assert(truth, fail_message)
{
    if (!truth) throw new Error(fail_message);
}

function log(message) {
    UIALogger.logMessage(message);
}

#import "screens/Screen.js";
#import "screens/ScheduleScreen.js";
#import "screens/FavoritesScreen.js";
#import "screens/SpeakerDetailScreen.js";
#import "screens/SessionDetailScreen.js";

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

