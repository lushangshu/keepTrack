//
//  PieGraphChart.h
//  KeepTrack
//
//  Created by lushangshu on 15-1-22.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, PieGraphChartAnimationOptions) {
    PieGraphChartAnimationFanAll                     = 1 <<  0,
    PieGraphChartAnimationGrowth                     = 1 <<  1,
    PieGraphChartAnimationGrowthAll                  = 1 <<  2,
    PieGraphChartAnimationGrowthBack                 = 1 <<  3,
    PieGraphChartAnimationGrowthBackAll              = 1 <<  4,
    PieGraphChartAnimationFan                        = 1 <<  5,
    
    PieGraphChartAnimationTimingEaseInOut            = 1 << 16,
    PieGraphChartAnimationTimingEaseIn               = 2 << 16,
    PieGraphChartAnimationTimingEaseOut              = 3 << 16,
    PieGraphChartAnimationTimingLinear               = 4 << 16, 
    
};

@interface PieGraphChart : UIView
@property (nonatomic, strong) NSArray *chartValues;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic) BOOL enableStrokeColor;
@property (nonatomic) BOOL enableInteractive;
@property (nonatomic) BOOL showLabels;
@property (nonatomic) float holeRadiusPrecent;
@property (nonatomic) float radiusPrecent;
@property (nonatomic) float maxAccentPrecent;
@property (nonatomic) float length;
@property (nonatomic) float startAngle;

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation;
- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation options:(PieGraphChartAnimationOptions)options;
- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(float)duration options:(PieGraphChartAnimationOptions)options;

@end
