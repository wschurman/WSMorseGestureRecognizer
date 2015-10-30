//
//  ViewController.m
//  WSMorseGestureRecognizerDemo
//
//  Created by William Schurman on 10/29/15.
//  Copyright © 2015 wschurman. All rights reserved.
//

#import "ViewController.h"

@import WSMorseGestureRecognizer;

typedef enum : NSUInteger {
    LabelTypeUnit,
    LabelTypeCharacter,
    LabelTypeWord,
} LabelType;

@interface ViewController () <WSMorseGestureRecognizerDelegate>

@property (nonatomic) UIImageView *image;
@property (nonatomic) UILabel *eventLabel;

@property (nonatomic) LabelType lastLabelType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"WSMorseGestureRecognizer Demo";
    self.view.backgroundColor = [UIColor whiteColor];

    self.eventLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.eventLabel.textColor = [UIColor blackColor];
    self.eventLabel.font = [UIFont systemFontOfSize:70 weight:UIFontWeightBlack];
    self.eventLabel.textAlignment = NSTextAlignmentCenter;
    self.eventLabel.text = @"";
    [self.view addSubview:self.eventLabel];

    self.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"morse_up"]
                                   highlightedImage:[UIImage imageNamed:@"morse_down"]];
    [self.view addSubview:self.image];

    WSMorseGestureRecognizer *gestureRecognizer = [[WSMorseGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(morseAction:)];
    gestureRecognizer.stringToRecognize = @"SOS";
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidLayoutSubviews {
    self.eventLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 70);
    self.eventLabel.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * .3);
    self.image.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * .8);
}

- (void)morseAction:(WSMorseGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        [UIView animateWithDuration:0.1 animations:^{
            self.view.backgroundColor = [UIColor greenColor];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.7 animations:^{
                self.view.backgroundColor = [UIColor whiteColor];
            }];
        }];
    }
}


#pragma mark - WSMorseGestureRecognizerDelegate

- (void)morseGestureRecognizer:(WSMorseGestureRecognizer *)morseGestureRecognizer
         didRecognizeMorseUnit:(NSString *)morseUnit {
    [self showLabel:morseUnit labelType:LabelTypeUnit];
}

- (void)morseGestureRecognizer:(WSMorseGestureRecognizer *)morseGestureRecognizer
         didRecognizeCharacter:(NSString *)character {
    [self showLabel:character labelType:LabelTypeCharacter];
}

- (void)morseGestureRecognizer:(WSMorseGestureRecognizer *)morseGestureRecognizer
              didRecognizeWord:(NSString *)word {
    [self showLabel:word labelType:LabelTypeWord];
}

- (void)morseGestureRecognizerDidBeginTap:(WSMorseGestureRecognizer *)morseGestureRecognizer {
    [self.image setHighlighted:YES];
}

- (void)morseGestureRecognizerDidEndTap:(WSMorseGestureRecognizer *)morseGestureRecognizer {
    [self.image setHighlighted:NO];
}


#pragma mark - Private

- (void)showLabel:(NSString *)string labelType:(LabelType)labelType {
    NSString *afterLabel = string;
    if (labelType == LabelTypeUnit && self.lastLabelType == LabelTypeUnit) {
        afterLabel = [self.eventLabel.text stringByAppendingString:string];
    }

    self.lastLabelType = labelType;

    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.eventLabel.text = afterLabel;
        self.eventLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.eventLabel.alpha = 0.0;
        } completion:^(BOOL finished) {

        }];
    }];
}

@end
