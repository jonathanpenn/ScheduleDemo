"use strict";

#import "env.js";

test("Viewing session details and swipe to go back", function() {
    var name = "All Day iOS Tutorial";

    ScheduleScreen.tapSession(name);

    log("Checking session details");
    var d = SessionDetailScreen;
    d.assertSpeaker("James Dempsey");
    d.assertTopic(name);
    d.assertTime("Wednesday, 8:30 AM");
    d.assertAbstractContains("New to iOS programming?");

    d.swipeToGoBack();

    ScheduleScreen.assertHere();
});

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

