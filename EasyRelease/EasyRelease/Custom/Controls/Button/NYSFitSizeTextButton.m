//
//  NYSFitSizeTextButton.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSFitSizeTextButton.h"

@interface NYSFitSizeTextButton ()

@property (nonatomic) CGFloat maxWidth;

- (void)fitIt;

@end

@implementation NYSFitSizeTextButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    [self setLineBreakMode:NSLineBreakByTruncatingTail];
    _maxWidth = NSWidth(frameRect);
    return self;
}

- (void)setTitle:(NSString *)title withNormalColor:(NSColor *)normal hoverColor:(NSColor *)hover {
    [super setTitle:title withNormalColor:normal hoverColor:hover];
    [self fitIt];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [super setMouseExited];
    [self fitIt];
}

- (void)fitIt {
    [self sizeToFit];
    NSSize newSize = self.frame.size;
    if (newSize.width > _maxWidth) {
        [self setFrameSize:NSMakeSize(_maxWidth, newSize.height)];
    }
}
@end
