//
//  WSMorseClassifier.h
//  WSMorseGestureRecognizer
//
//  Created by William Schurman on 10/29/15.
//  Copyright © 2015 wschurman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    /**
     * The "dot", also known as a "dit" is the short signal in Morse code. It is represented by one unit of time.
     */
    MorseUnitTypeDot = 1,
    /**
     * The "dash", also known as a "dah" is the long signal in Morse code. It is represented by three units of time.
     */
    MorseUnitTypeDash = 3,
} MorseUnitType;

/**
 * Convert an instance of NSNumber to a Morse unit.
 */
MorseUnitType MorseUnitTypeFromNumber(NSNumber *number);

/**
 * Convert a Morse unit to a new instance of NSNumber.
 */
NSNumber *NumberFromMorseUnit(MorseUnitType morseUnit);

/**
 * Convert a Morse unit to a string representation, either "." or "-".
 */
NSString *StringFromMorseUnit(MorseUnitType morseUnit);

/**
 * Morse conversion and classification helpers.
 */
@interface WSMorseClassifier : NSObject

/**
 * Singleton instance of the classifier
 */
+ (instancetype)sharedInstance;

/**
 * Classify a touch duration interval as a Morse unit, based on the unit's unit of time.
 *
 * @param touchDuration The duration of the touch to classify
 *
 * @return  classified Morse unit type
 */
- (MorseUnitType)morseUnitTypeFromTouchDuration:(NSTimeInterval)touchDuration;

/**
 * Attempt to convert a sequence of Morse units to a character.
 *
 * @param unitSequence The sequence of Morse units in NSNumber form to convert into a character
 *
 * @return The string representation of the sequence if one exists, otherwise nil
 */
- (nullable NSString *)characterFromMorseUnitSequence:(NSArray<NSNumber *> *)unitSequence;

@end

NS_ASSUME_NONNULL_END
