//
//  NYSRoundImageButton.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSRoundImageButton.h"

@interface NSImage (ScaleToRound)

- (NSImage *)getRoundImage:(CGFloat)radius;

@end

@implementation NSImage (ScaleToRound)

- (NSImage *)getRoundImage:(CGFloat)radius {
    NSSize roundSize = NSMakeSize(radius, radius);
    NSImage *roundImage = [[NSImage alloc] initWithSize:roundSize];
    
    [roundImage lockFocus];
    [self setSize:roundSize];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    NSRect imageFrame = NSMakeRect(0, 0, radius, radius);
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:imageFrame xRadius:radius yRadius:radius];
    [clipPath setWindingRule:NSWindingRuleEvenOdd];
    [clipPath addClip];
    [self drawAtPoint:NSZeroPoint fromRect:imageFrame operation:NSCompositingOperationSourceOver fraction:1];
    [roundImage unlockFocus];
    
    return roundImage;
}

@end

@interface NYSRoundImageButton ()

@property (nonatomic) CGFloat radius;

@end

@implementation NYSRoundImageButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (frameRect.size.width != frameRect.size.height) {
        NSLog(@"Not a round button!");
    }
    _radius = frameRect.size.width;
    [self setButtonType:NSButtonTypeMomentaryChange];
    [self setBezelStyle:NSBezelStyleRoundedDisclosure];
    [self setBordered:NO];
    [self setImagePosition:NSImageOnly];
    return self;
}

- (void)setImage:(NSImage *)image {
    NSImage *roundImage = [image getRoundImage:_radius];
    [super setImage:roundImage];
    [super setAlternateImage:roundImage];
}

@end
