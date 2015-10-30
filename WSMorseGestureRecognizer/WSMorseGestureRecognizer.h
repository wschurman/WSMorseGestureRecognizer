//
//  WSMorseGestureRecognizer.h
//  WSMorseGestureRecognizer
//
//  Created by William Schurman on 10/29/15.
//  Copyright © 2015 wschurman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

//! Project version number for WSMorseGestureRecognizer.
FOUNDATION_EXPORT double WSMorseGestureRecognizerVersionNumber;

//! Project version string for WSMorseGestureRecognizer.
FOUNDATION_EXPORT const unsigned char WSMorseGestureRecognizerVersionString[];

NS_ASSUME_NONNULL_BEGIN

@class WSMorseGestureRecognizer;

@protocol WSMorseGestureRecognizerDelegate <UIGestureRecognizerDelegate>

@optional

/**
 * Called when a morse tap began.
 *
 * @param morseGestureRecognizer The current Morse gesture recognizer
 */
- (void)morseGestureRecognizerDidBeginTap:(WSMorseGestureRecognizer *)morseGestureRecognizer;

/**
 * Called when a morse tap ended.
 *
 * @param morseGestureRecognizer The current Morse gesture recognizer
 */
- (void)morseGestureRecognizerDidEndTap:(WSMorseGestureRecognizer *)morseGestureRecognizer;

/**
 * Called when the gesture recognizer recognized a tap as a dot or dash
 *
 * @param morseGestureRecognizer The current Morse gesture recognizer
 * @param morseUnit              The string representation of the dot or dash
 */
- (void)morseGestureRecognizer:(WSMorseGestureRecognizer *)morseGestureRecognizer
         didRecognizeMorseUnit:(NSString *)morseUnit;

/**
 * Called when the gesture recognizer recognized a sequence of morse units as a character
 *
 * @param morseGestureRecognizer The current Morse gesture recognizer
 * @param morseUnit              The string representation of character recognized
 */
- (void)morseGestureRecognizer:(WSMorseGestureRecognizer *)morseGestureRecognizer
         didRecognizeCharacter:(NSString *)character;

/**
 * Called when the gesture recognizer recognized a sequence of characters as a word
 *
 * @param morseGestureRecognizer The current Morse gesture recognizer
 * @param morseUnit              The string representation of the last word recognized
 */
- (void)morseGestureRecognizer:(WSMorseGestureRecognizer *)morseGestureRecognizer
              didRecognizeWord:(NSString *)word;

@end

/**
 * UIGestureRecognizer subclass for recognizing and detecting Morse Code.
 */
@interface WSMorseGestureRecognizer : UIGestureRecognizer

@property (nonatomic, weak) id<WSMorseGestureRecognizerDelegate> delegate;

/**
 * String of alphanumeric characters to recognize in Morse Code.
 */
@property (nonatomic, copy) NSString *stringToRecognize;

/**
 * Delay after touch up before which the tapped Morse sequence is converted into a character. Reset on touch down.
 * Defaults to 0.3 seconds.
 */
@property (nonatomic) NSTimeInterval characterParseDelay;

/**
 * Delay after character parse before which the character sequence is converted into a word. Reset on touch down.
 * Defaults to 1.5 seconds.
 */
@property (nonatomic) NSTimeInterval wordParseDelay;

@end

NS_ASSUME_NONNULL_END
