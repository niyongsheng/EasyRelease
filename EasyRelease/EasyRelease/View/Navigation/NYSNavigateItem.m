//
//  NYSNavigateItem.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSNavigateItem.h"

@interface NSView (MouseEvent)

- (void)setMouseEntered;

- (void)setMouseExited;

@end

@implementation NYSNavigateItem

@synthesize bkColor = _bkColor;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    [_bkColor setFill];
    NSRectFill(dirtyRect);
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _bkColor = [NSColor colorWithRGBInt:SelectBackgroundColor];
    [super mouseEntered:theEvent];
    for (NSView *sub in [self subviews]) {
        [sub setMouseEntered];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    _bkColor = [NSColor colorWithRGBInt:0xffffff];
    [super mouseExited:theEvent];
    for (NSView *sub in [self subviews]) {
        [sub setMouseExited];
    }
}

- (BOOL)isFlipped {
    return YES;
}

@end
