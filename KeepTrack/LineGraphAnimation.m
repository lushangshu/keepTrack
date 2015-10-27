//
//  LineGraphAnimation.m
//  KeepTrack
//
//  Created by lushangshu on 15-1-20.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#import "LineGraphAnimation.h"

@implementation LineGraphAnimation
- (void)animationForDot:(NSInteger)dotIndex circleDot:(LineGraphCircle *)circleDot animationSpeed:(NSInteger)speed {
    if (speed == 0) {
        circleDot.alpha = 0;
    } else {
        [UIView animateWithDuration:0.5 delay:dotIndex/(speed*2.0) options:UIViewAnimationOptionCurveEaseOut animations:^{
            circleDot.alpha = 0.7;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                circleDot.alpha = 0;
            } completion:nil];
        }];
    }
}

// Animation of the graph
- (void)animationForLine:(NSInteger)lineIndex line:(LineGraphLine *)line animationSpeed:(NSInteger)speed {
    if (speed == 0) {
        line.alpha = 1.0;
    } else {
        [UIView animateWithDuration:1.0 delay:lineIndex/(speed*2.0) options:UIViewAnimationOptionCurveEaseOut animations:^{
            line.alpha = 1.0;
        } completion:nil];
    }
}

@end
