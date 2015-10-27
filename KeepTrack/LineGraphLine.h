//
//  LineGraphLine.h
//  KeepTrack
//
//  Created by lushangshu on 15-1-20.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LineGraphLine : UIView

@property (assign, nonatomic) CGPoint  firstPoint;
@property (assign, nonatomic) CGPoint  secondPoint;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *topColor;
@property (strong, nonatomic) UIColor *bottomColor;
@property (nonatomic) float topAlpha;
@property (nonatomic) float bottomAlpha;
@property (nonatomic) float lineAlpha;
@property (nonatomic) float lineWidth;

@end