"use strict";

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();
var tableView = window.tableViews()[0];

var cell = tableView.cells()[0];

cell.logElementTree();

// ------

if (cell.name() != "All Day iOS Tutorial, James Dempsey") {
    throw new Error("Session not found");
}

// ------

var options = {
    startOffset: {x:0.2,y:0.5},
    endOffset:   {x:0.5,y:0.5}
};
cell.flickInsideWithOptions(options);

cell.logElementTree();

// ------

if (cell.name() != "* All Day iOS Tutorial, James Dempsey") {
    throw new Error("Couldn't find starred session");
}

// ------

var tabBar = app.tabBar();
tabBar.buttons()[1].tap();

tableView = window.tableViews()[0];
var cells = tableView.cells();
if (cells.length != 1) {
    throw new Error("Expected only one favorite session");
}

// ------

var predicate = "name contains 'All Day iOS Tutorial'";
cell = cells.firstWithPredicate(predicate);
cell.logElementTree();

// ------

cell.flickInsideWithOptions(options);

target.pushTimeout(0.1);
cells = tableView.cells();
if (cells.length != 0) {
    throw new Error("Swiping should remove favorite session");
}
target.popTimeout();

UIALogger.logMessage("Win condition acquired");

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

