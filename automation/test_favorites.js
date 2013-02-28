"use strict";

#import "env.js";

test("Favoriting a session", function() {
    var name = "All Day iOS Tutorial";

    log("Favoriting " + name);
    ScheduleScreen.swipeSession(name);
    ScheduleScreen.assertSessionIsFavorite(name);

    log("Checking favorites list");
    ScheduleScreen.tapFavoritesTab();
    FavoritesScreen.assertSessionCount(1);

    log("Removing from favorites list");
    FavoritesScreen.swipeSession(name);
    FavoritesScreen.assertSessionCount(0);

    FavoritesScreen.tapScheduleTab();
});

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

