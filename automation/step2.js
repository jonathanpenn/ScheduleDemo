"use strict";

#import "env.js";

test("Favoriting a session", function() {
    var target = UIATarget.localTarget();
    var app = target.frontMostApp();
    var window = app.mainWindow();
    var tableView = window.tableViews()[0];

    var cell = tableView.cells()[0];

    cell.logElementTree();

    assert(cell.name() == "All Day iOS Tutorial, James Dempsey",
           "Session not found");

    var options = {
      startOffset: {x:0.2,y:0.5},
      endOffset:   {x:0.5,y:0.5}
    };
    cell.flickInsideWithOptions(options);

    cell.logElementTree();

    assert(cell.name() == "* All Day iOS Tutorial, James Dempsey",
           "Couldn't find starred session");

    var tabBar = app.tabBar();
    tabBar.buttons()[1].tap();

    tableView = window.tableViews()[0];
    var cells = tableView.cells();
    assert(cells.length == 1, "Expected only one favorite session");

    cell = cells.firstWithPredicate("name contains 'All Day iOS Tutorial'");
    cell.logElementTree();

    cell.flickInsideWithOptions(options);

    target.pushTimeout(0.1);
    cells = tableView.cells();
    assert(cells.length == 0, "Swiping should remove favorite session");
    target.popTimeout();
});

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

