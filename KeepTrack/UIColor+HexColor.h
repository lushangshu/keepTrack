//
//  UIColor+HexColor.h
//  KeepTrack
//
//  Created by lushangshu on 15-1-22.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#ifndef _WOL_UICOLOR_HEX_COLOR_H__
#define _WOL_UICOLOR_HEX_COLOR_H__

//This file is just for customizing pie graph colors

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (HexColor)

- (NSString *) hexString;

+ (UIColor *) colorWithHex:(int)color;
+ (UIColor *) colorWithHexRed:(int)red green:(char)green blue:(char)blue alpha:(char)alpha;
+ (UIColor *) colorWithHexString:(NSString *)hexString;
+ (UIColor *) colorWithIntegerRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
@end


#endif
