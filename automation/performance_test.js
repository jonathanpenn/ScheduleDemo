"use strict";

#import "env.js";

ScheduleScreen.tapSession("All Day iOS Tutorial");

for (var count = 20, i = 0; i < count; i++) {
    test("Swiping iteration " + i + " of " + count, function() {
        SessionDetailScreen.swipeToNext();
        SessionDetailScreen.swipeToPrev();
    });
}

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

