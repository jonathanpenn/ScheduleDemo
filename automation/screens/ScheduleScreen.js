"use strict";

var ScheduleScreen = {
    swipeSession: function(name) {
        log("Swiping " + name);
        var cell = this.sessionCell(name);

        var options = {
            startOffset: {x:0.2,y:0.5},
            endOffset:   {x:0.5,y:0.5}
        };

        cell.flickInsideWithOptions(options);
    },

    sessionCell: function(name) {
        var predicate = "name contains '" + name + "'";
        return this.cells().firstWithPredicate(predicate);
    },

    assertSessionIsFavorite: function(name) {
        var cell = this.sessionCell(name);
        var name = cell.name();

        assert(name[0] == "*", "Session isn't a favorite" + name);
    },

    tapSession: function(name) {
        log("Tapping session " + name);
        this.sessionCell(name).tap();
    },

    assertHere: function() {
        var button = this.app().tabBar().selectedButton();
        assert(button.isValid(), "Tab bar not visible, not on schedule list");
        assert(button.name() == "Schedule", "Schedule tab isn't selected");
    }
}

ScheduleScreen.__proto__ = Screen;

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

