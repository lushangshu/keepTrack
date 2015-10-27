//
//  LineGraphCircle.m
//  KeepTrack
//
//  Created by lushangshu on 15-1-20.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#import "LineGraphCircle.h"

@implementation LineGraphCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    [[UIColor whiteColor] set];
    CGContextFillPath(ctx);
}


@end
