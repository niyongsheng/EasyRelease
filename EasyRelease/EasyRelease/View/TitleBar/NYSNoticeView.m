//
//  NYSNoticeView.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSNoticeView.h"

@interface NSView (MouseEvent)

- (void)setMouseEntered;

- (void)setMouseExited;

@end

@interface NYSNoticeView ()

@property (nonatomic, strong) NSTrackingArea *trackingArea;

@end

@implementation NYSNoticeView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateTrackingAreas {
    if (self.trackingArea != nil) {
        [self removeTrackingArea:self.trackingArea];
    }
    int ops = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                     options:ops
                                                       owner:self
                                                    userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    for (NSView *sub in [self subviews]) {
        [sub setMouseEntered];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    for (NSView *sub in [self subviews]) {
        [sub setMouseExited];
    }
}

- (BOOL)isFlipped {
    return YES;
}

@end
