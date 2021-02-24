//
//  NYSNavigateView.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSNavigateView.h"

@implementation NYSNavigateView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSBezierPath *path = [NSBezierPath bezierPath];
    NSRect rect = [self bounds];
    [path moveToPoint:NSMakePoint(rect.size.width - 1, 0)];
    [path lineToPoint:NSMakePoint(rect.size.width - 1, rect.size.height)];
    
    [[NSColor colorWithRGBInt:0xdddfe4] set];
    [path setLineWidth:1.0];
    [path stroke];
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (BOOL)isFlipped {
    return YES;
}

@end
