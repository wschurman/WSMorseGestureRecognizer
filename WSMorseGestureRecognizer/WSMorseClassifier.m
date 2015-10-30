//
//  WSMorseClassifier.m
//  WSMorseGestureRecognizer
//
//  Created by William Schurman on 10/29/15.
//  Copyright © 2015 wschurman. All rights reserved.
//

#import "WSMorseClassifier.h"

#import "WSMorseNode.h"

MorseUnitType MorseUnitTypeFromNumber(NSNumber *number) {
    NSUInteger intValue = [number unsignedIntegerValue];
    assert(intValue == MorseUnitTypeDot || intValue == MorseUnitTypeDash);
    return intValue;
}

NSNumber *NumberFromMorseUnit(MorseUnitType morseUnit) {
    return @(morseUnit);
}

NSString *StringFromMorseUnit(MorseUnitType morseUnit) {
    switch (morseUnit) {
        case MorseUnitTypeDot:
            return @".";
        case MorseUnitTypeDash:
            return @"-";
    }
}

/**
 * Threshold at which a dot touch duration becomes a dash.
 */
static const NSTimeInterval kDashTouchDurationThreshold = ((float)MorseUnitTypeDot + (float)MorseUnitTypeDash) / 2 / 10;

@interface WSMorseClassifier ()

@property (nonatomic) WSMorseNode *rootNode;

@end

@implementation WSMorseClassifier

+ (instancetype)sharedInstance {
    static WSMorseClassifier *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[WSMorseClassifier alloc] init];
    }
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _rootNode = [WSMorseNode morseTree];
    }
    return self;
}

- (MorseUnitType)morseUnitTypeFromTouchDuration:(NSTimeInterval)touchDuration {
    double __unused wat = kDashTouchDurationThreshold;
    return (touchDuration > kDashTouchDurationThreshold) ? MorseUnitTypeDash : MorseUnitTypeDot;
}

- (NSString *)characterFromMorseUnitSequence:(NSArray<NSNumber *> *)unitSequence {
    WSMorseNode *currentNode = self.rootNode;
    for (NSNumber *unitNumber in unitSequence) {
        MorseUnitType unitType = MorseUnitTypeFromNumber(unitNumber);
        switch (unitType) {
            case MorseUnitTypeDot:
                currentNode = currentNode.childDot;
                break;

            case MorseUnitTypeDash:
                currentNode = currentNode.childDash;
                break;
        }

        if (!currentNode) {
            return nil;
        }
    }
    return currentNode.character;
}

@end
