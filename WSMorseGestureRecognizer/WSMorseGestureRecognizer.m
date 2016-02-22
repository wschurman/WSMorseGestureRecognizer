//
//  WSMorseGestureRecognizer.m
//  WSMorseGestureRecognizer
//
//  Created by William Schurman on 10/29/15.
//  Copyright © 2015 wschurman. All rights reserved.
//

#import "WSMorseGestureRecognizer.h"

#import "WSMorseClassifier.h"

/**
 * Default time intervals for parse delays
 */
static const NSTimeInterval kDefaultCharacterParseDelayInterval = 0.3;
static const NSTimeInterval kDefaultWordParseDelayInterval = 1.5;

@interface WSMorseGestureRecognizer ()

/**
 * Full parsed character history for this instance, with words separated by spaces.
 */
@property (nonatomic) NSString *letterHistory;

/**
 * The current sequence of morse units (stored as NSNumbers) that will be converted to a character 
 * after the character parse delay.
 */
@property (nonatomic) NSMutableArray<NSNumber *> *currentSequence;

/**
 * Timestamp of the start of the last touch. Used to determine dot vs dash.
 */
@property (nonatomic) NSTimeInterval timeOfLastTouchStart;

@end

@implementation WSMorseGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        _letterHistory = @"";
        _currentSequence = [NSMutableArray array];

        _characterParseDelay = kDefaultCharacterParseDelayInterval;
        _wordParseDelay = kDefaultWordParseDelayInterval;
    }
    return self;
}


#pragma mark - UIGestureRecognizerSubclass

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(morseGestureRecognizerDidBeginTap:)]) {
        [self.delegate morseGestureRecognizerDidBeginTap:self];
    }

    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    }

    [self cancelTimerRequests];

    self.timeOfLastTouchStart = [[NSDate date] timeIntervalSince1970];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(morseGestureRecognizerDidEndTap:)]) {
        [self.delegate morseGestureRecognizerDidEndTap:self];
    }

    NSTimeInterval timeOfTouchEnd = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval durationOfTouch = timeOfTouchEnd - self.timeOfLastTouchStart;

    MorseUnitType unitType = [[WSMorseClassifier sharedInstance] morseUnitTypeFromTouchDuration:durationOfTouch];
    [self.currentSequence addObject:NumberFromMorseUnit(unitType)];

    if ([self.delegate respondsToSelector:@selector(morseGestureRecognizer:didRecognizeMorseUnit:)]) {
        [self.delegate morseGestureRecognizer:self didRecognizeMorseUnit:StringFromMorseUnit(unitType)];
    }

    [self performSelector:@selector(endRecognizerForCurrentCharacter) withObject:nil afterDelay:self.characterParseDelay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
    [self cancelTimerRequests];
}


#pragma mark - Timed Method Calls

- (void)cancelTimerRequests {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(endRecognizerForCurrentCharacter)
                                               object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(endRecognizerForCurrentWord)
                                               object:nil];
}

- (void)endRecognizerForCurrentCharacter {
    self.state = UIGestureRecognizerStateChanged;

    NSString *possibleCurrentCharacter = [[WSMorseClassifier sharedInstance] characterFromMorseUnitSequence:self.currentSequence];
    if (possibleCurrentCharacter) {
        self.letterHistory = [self.letterHistory stringByAppendingString:possibleCurrentCharacter];

        if ([self.delegate respondsToSelector:@selector(morseGestureRecognizer:didRecognizeCharacter:)]) {
            [self.delegate morseGestureRecognizer:self didRecognizeCharacter:possibleCurrentCharacter];
        }
    }

    [self.currentSequence removeAllObjects];

    [self performSelector:@selector(endRecognizerForCurrentWord)
               withObject:nil
               afterDelay:self.wordParseDelay];
}

- (void)endRecognizerForCurrentWord {
    self.state = UIGestureRecognizerStateChanged;

    NSRange wordMatch = [self.letterHistory rangeOfString:@" " options:(NSCaseInsensitiveSearch | NSBackwardsSearch)];
    NSString *word = wordMatch.location != NSNotFound ? [self.letterHistory substringFromIndex:wordMatch.location + 1] : self.letterHistory;

    if (self.stringToRecognize) {
        NSRange match = [self.letterHistory rangeOfString:self.stringToRecognize
                                                  options:(NSCaseInsensitiveSearch | NSBackwardsSearch)];
        if (match.location == self.letterHistory.length - self.stringToRecognize.length &&
            word.length == self.stringToRecognize.length) {
            self.state = UIGestureRecognizerStateRecognized;
        }
    }

    if ([self.delegate respondsToSelector:@selector(morseGestureRecognizer:didRecognizeWord:)]) {
        [self.delegate morseGestureRecognizer:self didRecognizeWord:word];
    }

    self.letterHistory = [self.letterHistory stringByAppendingString:@" "];
}

@end
