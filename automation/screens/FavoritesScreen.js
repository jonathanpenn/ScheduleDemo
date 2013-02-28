"use strict";

var FavoritesScreen = {
    assertSessionCount: function(count) {
        var actual = this.sessionCount();
        assert(actual == count,
               "Expected " + count + " session(s), but saw " + actual);
    },

    sessionCount: function() {
        this.target().pushTimeout(0.1);
        var count = this.cells().length;
        this.target().popTimeout();
        return count;
    }
}

FavoritesScreen.__proto__ = ScheduleScreen;

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

