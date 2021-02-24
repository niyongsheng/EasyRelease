//
//  NSColor+NSColor_RGBValue.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NSColor+RGBValue.h"

@implementation NSColor (NSColor_RGBValue)

+ (NSColor *)colorWithRGB:(int)red
                    green:(int)green
                     blue:(int)blue {
    CGFloat r = red / 255.0;
    CGFloat g = green / 255.0;
    CGFloat b = blue / 255.0;
    return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0];
}

+ (NSColor *)colorWithRGBA:(int)red
                     green:(int)green
                      blue:(int)blue
                     alpha:(CGFloat)alpha {
    CGFloat r = red / 255.0;
    CGFloat g = green / 255.0;
    CGFloat b = blue / 255.0;
    return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:alpha];
}

+ (NSColor *)colorWithRGBInt:(uint32_t)rgb {
    CGFloat r = ((rgb & 0xff0000) >> 16) / 255.0;
    CGFloat g = ((rgb & 0x00ff00) >> 8) / 255.0;
    CGFloat b = ((rgb & 0x0000ff) >> 0) / 255.0;
    return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0];
}

@end
