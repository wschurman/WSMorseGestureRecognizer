Morse Gesture Recognizer
========================

This library provides a UIGestureRecognizer that recognizes and parses Morse Code tap events.

Basic Usage
-----------

```objective-c
@import WSMorseGestureRecognizer;

...

UIView *aView = ...
WSMorseGestureRecognizer *morseGestureRecognizer =
  [[WSMorseGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(morseAction:)];
morseGestureRecognizer.stringToRecognize = @"SOS";
[aView addGestureRecognizer:morseGestureRecognizer];

...

- (void)morseAction:(WSMorseGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        ...
    }
}
```

Licenses
--------

All source code is licensed under the [MIT License](http://opensource.org/licenses/MIT).
