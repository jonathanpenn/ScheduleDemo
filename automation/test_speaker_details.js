"use strict";

#import "env.js";

test("Viewing speaker details and swipe to go back", function() {
    var name = "All Day iOS Tutorial";

    ScheduleScreen.tapSession(name);
    SessionDetailScreen.tapSpeaker();

    log("Checking speaker details");
    var d = SpeakerDetailScreen;
    d.assertSpeaker("James Dempsey");
    d.assertBioContains("fifteen-year Apple veteran");

    d.doubleSwipeToGoHome();

    ScheduleScreen.assertHere();
});

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

