//
//  PieGraphPiece.h
//  KeepTrack
//
//  Created by lushangshu on 15-1-22.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PieGraphPiece : CAShapeLayer

@property (nonatomic, readonly) float angle;
@property (nonatomic, readonly) float startAngle;
@property (nonatomic, readonly) BOOL accent;
@property (nonatomic) float innerRadius;
@property (nonatomic) float outerRadius;
@property (nonatomic) double value;
@property (nonatomic) float accentPrecent;

- (BOOL) animateToAccent:(float)accentPrecent;
- (void) pieceAngle:(float)angle start:(float)startAngle;


@end