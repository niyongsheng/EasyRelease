//
//  MainWindow.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    if (self != nil) {
        [self setOpaque:NO];
        [self setStyleMask:NSWindowStyleMaskBorderless];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setMovableByWindowBackground:YES];
    }
    return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

@end
