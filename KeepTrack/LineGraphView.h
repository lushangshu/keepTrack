//
//  LineGraphView.h
//  KeepTrack
//
//  Created by lushangshu on 15-1-20.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineGraphAnimation.h"
#import "LineGraphCircle.h"
#import "LineGraphLine.h"

@protocol LineGraphDelegate <NSObject>

@required
-(int)numberOfPointsInGraph;
-(float)valueForIndex:(NSInteger)index;
@optional
-(void)didTouchGraphWithClosestIndex:(int)index;
-(int)numberOfGapsBetweenLabels;
-(NSString *)labelOnXAxisForIndex:(NSInteger)index;
@end
@interface LineGraphView : UIView <LineGraphAnimationDelegate,UIGestureRecognizerDelegate>

@property (assign) IBOutlet id <LineGraphDelegate> delegate;
@property (strong, nonatomic) LineGraphAnimation *animationDelegate;
@property (strong, nonatomic) UIView *verticalLine;
@property (strong, nonatomic) UIFont *labelFont;
@property (nonatomic) NSInteger animationGraphEntranceSpeed;
@property (nonatomic) BOOL enableTouchReport;
@property (strong, nonatomic) UIColor *colorBottom;
@property (nonatomic) float alphaBottom;
@property (strong, nonatomic) UIColor *colorTop;
@property (nonatomic) float alphaTop;
@property (strong, nonatomic) UIColor *colorLine;
@property (nonatomic) float alphaLine;
@property (nonatomic) float widthLine;
@property (strong, nonatomic) UIColor *colorXaxisLabel;

- (void)reloadGraph;

@end
