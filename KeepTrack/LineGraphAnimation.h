//
//  LineGraphAnimation.h
//  KeepTrack
//
//  Created by lushangshu on 15-1-20.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineGraphLine.h"
#import "LineGraphCircle.h"

@protocol LineGraphAnimationDelegate <NSObject>

@end

@interface LineGraphAnimation : NSObject
@property (assign) id <LineGraphAnimationDelegate> delegate;

- (void)animationForLine:(NSInteger)lineIndex line:(LineGraphLine *)line animationSpeed:(NSInteger)speed;
- (void)animationForDot:(NSInteger)dotIndex circleDot:(LineGraphCircle *)circleDot animationSpeed:(NSInteger)speed;

@end
