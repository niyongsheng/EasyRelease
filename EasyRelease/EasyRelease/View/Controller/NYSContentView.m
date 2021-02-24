//
//  NYSContentView.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSContentView.h"

@implementation NYSContentView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSBezierPath *path = [NSBezierPath bezierPath];
    NSRect rect = [self bounds];
    [path moveToPoint:NSMakePoint(0, 0)];
    [path lineToPoint:NSMakePoint(rect.size.width, 0)];
    [[NSColor colorWithRGBInt:0xdddfe4] set];
    [path stroke];
    
    [path moveToPoint:NSMakePoint(0, 0)];
    [path lineToPoint:NSMakePoint(rect.size.width, 0)];
    [path lineToPoint:NSMakePoint(rect.size.width, rect.size.height - 15)];
    [path curveToPoint:NSMakePoint(rect.size.width - 15, rect.size.height)
         controlPoint1:NSMakePoint(rect.size.width, rect.size.height)
         controlPoint2:NSMakePoint(rect.size.width, rect.size.height)];
    [path lineToPoint:NSMakePoint(0, rect.size.height)];
    [path lineToPoint:NSMakePoint(0, 0)];
    [[NSColor colorWithRGBInt:0xf1f3f7] set];
    [path appendBezierPathWithRect:NSMakeRect(-1, -1, rect.size.width, 1)];
    [path fill];
}

- (BOOL)isFlipped {
    return YES;
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

@end
