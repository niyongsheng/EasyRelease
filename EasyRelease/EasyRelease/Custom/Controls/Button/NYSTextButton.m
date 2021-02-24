//
//  NYSTextButton.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSTextButton.h"

@interface NYSTextButton ()

@property (nonatomic, strong) NSColor *normalColor;

@property (nonatomic, strong) NSColor *hoverColor;

@property (nonatomic, strong) NSTrackingArea *trackingArea;

- (void)setTextColor:(NSColor *)color;

@end

@implementation NYSTextButton

@synthesize fontSize = _fontSize;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    [self setButtonType:NSButtonTypeMomentaryChange];
    [self setAlignment:NSTextAlignmentLeft];
    [self setBordered:NO];
    [self setImage:nil];
    _fontSize = 12;
    return self;
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
    [self setMouseEntered];
}

- (void)setMouseEntered {
    [self setTextColor:_hoverColor];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    [self setMouseExited];
}

- (void)setMouseExited {
    [self setTextColor:_normalColor];
}

- (void)setTitle:(NSString *)title
 withNormalColor:(NSColor *)normal
      hoverColor:(NSColor *)hover {
    [super setTitle:title];
    _normalColor = normal;
    _hoverColor = hover;
    [self setTextColor:normal];
}

- (void)setTextColor:(NSColor *)color {
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [self.title length]);
    [textAttr addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[NSFont systemFontOfSize:_fontSize] forKey:NSFontAttributeName];
    [textAttr addAttributes:attributes range:titleRange];
    [self setAttributedTitle:textAttr];
}

@end
