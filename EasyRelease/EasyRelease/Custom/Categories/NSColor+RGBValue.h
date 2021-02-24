//
//  NSColor+NSColor_RGBValue.h
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (NSColor_RGBValue)

+ (NSColor *)colorWithRGB:(int)red
                   green:(int)green
                    blue:(int)blue;

+ (NSColor *)colorWithRGBA:(int)red
                    green:(int)green
                     blue:(int)blue
                    alpha:(CGFloat)alpha;

+ (NSColor *)colorWithRGBInt:(uint32_t)rgb;

@end
