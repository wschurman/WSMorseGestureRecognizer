//
//  WSMorseNode.h
//  WSMorseGestureRecognizer
//
//  Created by William Schurman on 10/29/15.
//  Copyright © 2015 wschurman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Node in a binary search tree that stores the conversion from Morse into alphanumeric characters.
 */
@interface WSMorseNode : NSObject

/**
 * Tree of WSMorseNode. To parse, start at root returned by this function and follow dot or dash edges in order
 * specified by Morse sequence being parsed. At end of sequence, the character property represents the sequence.
 */
+ (WSMorseNode *)morseTree;

/**
 * Character for morse sequence terminating at this node.
 */
@property (nonatomic, copy) NSString *character;

/**
 * Node when next Morse unit in the sequence is a dot.
 */
@property (nonatomic) WSMorseNode *childDot;

/**
 * Node when next Morse unit in the sequence is a dash.
 */
@property (nonatomic) WSMorseNode *childDash;

@end

NS_ASSUME_NONNULL_END
