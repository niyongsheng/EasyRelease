//
//  MainWindowView.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "MainWindowView.h"

@implementation MainWindowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor clearColor] set];
    NSRectFill(dirtyRect);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [[NSColor whiteColor] set];
    [path fill];
}

@end
