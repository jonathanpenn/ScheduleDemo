"use strict";

var Screen = {
    target: function() {
        return UIATarget.localTarget();
    },

    app: function() {
        return this.target().frontMostApp();
    },

    window: function() {
        return this.app().mainWindow();
    },

    tableView: function() {
        return this.window().tableViews()[0];
    },

    scrollView: function() {
        return this.window().scrollViews()[0];
    },

    cells: function() {
        return this.tableView().cells();
    },

    tabBar: function() {
        return this.app().tabBar();
    },

    tapScheduleTab: function() {
        log("Tapping Schedule Tab");
        return this.tabBar().buttons()[0].tap();
    },

    tapFavoritesTab: function() {
        log("Tapping Favorites Tab");
        return this.tabBar().buttons()[1].tap();
    },

    swipeToGoBack: function() {
        log("Swiping to go back");
        var options = {
            startOffset: {x:0.2,y:0.5},
            endOffset:   {x:0.5,y:0.5}
        };
        this.window().flickInsideWithOptions(options);
    }
};

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

