"use strict";

var SpeakerDetailScreen = {
    assertSpeaker: function(name) {
        var element = this.scrollView().staticTexts()[name];
        assert(element.isValid(), "Speaker isn't " + name);
    },

    assertBioContains: function(text) {
        var textView = this.scrollView().textViews().
            firstWithPredicate("value contains '" + text + "'");
        assert(textView.isValid(), "Bio not found containing " + text);
    },

    doubleSwipeToGoHome: function() {
        log("Double swiping to go home");
        var options = {
            touchCount: 2,
            startOffset: {x:0.2,y:0.5},
            endOffset:   {x:0.5,y:0.5}
        };
        this.window().flickInsideWithOptions(options);
    }
}

SpeakerDetailScreen.__proto__ = Screen;

/* Instruments uses 4-wide tab stops. */
/* vim: set shiftwidth=4 softtabstop=4 expandtab: */

