//
//  WSMorseNode.m
//  WSMorseGestureRecognizer
//
//  Created by William Schurman on 10/29/15.
//  Copyright © 2015 wschurman. All rights reserved.
//

#import "WSMorseNode.h"

@implementation WSMorseNode

+ (WSMorseNode *)morseTree {
    WSMorseNode *rootNode = [[WSMorseNode alloc] init];
    [[WSMorseNode translationDictionary]
        enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [WSMorseNode addStringToTree:rootNode stringToAdd:key character:obj];
    }];
    return rootNode;
}

+ (WSMorseNode *)addStringToTree:(WSMorseNode *)currentNode
                     stringToAdd:(NSString *)stringToAdd
                       character:(NSString *)character {

    if ([stringToAdd isEqualToString:@""]) {
        NSAssert(!currentNode.character, @"Attempting to set duplicate character: %@ (%@ exists here)",
                 character,
                 currentNode.character);
        currentNode.character = character;
        return currentNode;
    }

    unichar firstMorseCharacter = [stringToAdd characterAtIndex:0];
    WSMorseNode *childNode;
    if (firstMorseCharacter == '.') {
        if (!currentNode.childDot) {
            childNode = [[WSMorseNode alloc] init];
            currentNode.childDot = childNode;
        }
        childNode = currentNode.childDot;
    } else if (firstMorseCharacter == '-') {
        if (!currentNode.childDash) {
            childNode = [[WSMorseNode alloc] init];
            currentNode.childDash = childNode;
        }
        childNode = currentNode.childDash;
    } else {
        NSAssert(NO, @"Invalid morse character: %hu", firstMorseCharacter);
    }

    NSString *nextString = stringToAdd.length > 1 ? [stringToAdd substringFromIndex:1] : @"";
    return [WSMorseNode addStringToTree:childNode stringToAdd:nextString character:character];
}

+ (NSDictionary<NSString *, NSString *> *)translationDictionary {
    return @{
             @".-" : @"A",
             @"-..." : @"B",
             @"-.-." : @"C",
             @"-.." : @"D",
             @"." : @"E",
             @"..-." : @"F",
             @"--." : @"G",
             @"...." : @"H",
             @".." : @"I",
             @".---" : @"J",
             @"-.-" : @"K",
             @".-.." : @"L",
             @"--" : @"M",
             @"-." : @"N",
             @"---" : @"O",
             @".--." : @"P",
             @"--.-" : @"Q",
             @".-." : @"R",
             @"..." : @"S",
             @"-" : @"T",
             @"..-" : @"U",
             @"...-" : @"V",
             @".--" : @"W",
             @"-..-" : @"X",
             @"-.--" : @"Y",
             @"--.." : @"Z",
             @"-----" : @"0",
             @".----" : @"1",
             @"..---" : @"2",
             @"...--" : @"3",
             @"....-" : @"4",
             @"....." : @"5",
             @"-...." : @"6",
             @"--..." : @"7",
             @"---.." : @"8",
             @"----." : @"9",
             @".-.-.-" : @".",
             @"--..--" : @",",
             @"..--.." : @"?",
             @".----." : @"'",
             @"-.-.--" : @"!",
             @"-..-." : @"/",
             @"-.--." : @"(",
             @"-.--.-" : @")",
             @".-..." : @"&",
             @"---..." : @":",
             @"-.-.-." : @";",
             @"-...-" : @"=",
             @".-.-." : @"+",
             @"-....-" : @"-",
             @"..--.-" : @"_",
             @".-..-." : @"\"",
             @"...-..-" : @"$",
             @".--.-." : @"@",
             @".-.-" : @"\n",
             @"...-." : @"*",
             };
}

@end
