"use strict";

var SessionDetailScreen = {
    tapSpeaker: function() {
        this.scrollView().buttons()[1].tap();
    },

    swipeToNext: function() {
        var options = {
            duration: 0.7,
            startOffset: {x:0.5,y:0.9},
            endOffset:   {x:0.5,y:0.1}
        };
        this.scrollView().dragInsideWithOptions(options);
        this.target().delay(0.5);
    },

    swipeToPrev: function() {
        var options = {
            duration: 0.7,
            startOffset: {x:0.5,y:0.1},
            endOffset:   {x:0.5,y:0.9}
        };
        this.scrollView().dragInsideWithOptions(options);
        this.target().delay(0.5);
    },

    scrollView: function() {
        return this.window().scrollViews()[0];
    },

    assertSpeaker: function(name) {
        this.assertAStaticTextIs(name, "Session details don't show speaker " + name);
    },

    assertTopic: function(name) {
        this.assertAStaticTextIs(name, "Session details don't show topic " + name);
    },

    assertTime: function(timeString) {
        this.assertAStaticTextIs(timeString, "Session details don't show time " + timeString);
    },

    assertAStaticTextIs: function(text, message) {
        var element = this.scrollView().staticTexts()[text];
        assert(element.isValid(), message);
    },

    assertAbstractContains: function(text) {
        var abstractTextView = this.scrollView().textViews()[0];
        var abstract = abstractTextView.value();
        assert(abstract.match(text), "Abstract doesn't contain " + text);
    }
}

SessionDetailScreen.__proto__ = Screen;

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

