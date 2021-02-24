//
//  NYSImageTextButton.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSImageTextButton.h"

@interface NYSImageTextButton()

@property (nonatomic, strong) NSImage *normalImage;

@property (nonatomic, strong) NSImage *hoverImage;

@property (nonatomic, strong) NSImage *disableImage;

@property (nonatomic, strong) NSColor *normalColor;

@property (nonatomic, strong) NSColor *hoverColor;

@property (nonatomic, strong) NSColor *disableColor;

@property (nonatomic, strong) NSColor *textColor;

@property (nonatomic, strong) NSString *titleValue;

@property (nonatomic, strong) NSTrackingArea *trackingArea;

@end

@implementation NYSImageTextButton

@synthesize fontSize = _fontSize;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSMutableParagraphStyle *style =
    [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *att = [[NSDictionary alloc] initWithObjectsAndKeys:
           style, NSParagraphStyleAttributeName,
           _textColor,
           NSForegroundColorAttributeName, nil];
    [_titleValue drawInRect:NSMakeRect(self.bounds.origin.x+16, self.bounds.origin.y+7, self.bounds.size.width-16, self.bounds.size.height) withAttributes:att];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    [self setButtonType:NSButtonTypeMomentaryChange];
    [self setBezelStyle:NSBezelStyleRoundedDisclosure];
    [self setBordered:NO];
    [self setImagePosition:NSImageOnly];
    _fontSize = 12;
    _titleValue = @"";
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
    if (self.isEnabled == FALSE) {
        _textColor = [NSColor colorWithRGBInt:0xe4e5e7];
        self.image = _disableImage;
        return;
    }
    self.image = _hoverImage;
    _textColor = _hoverColor;
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    [self setMouseExited];
}

- (void)setMouseExited {
    if (self.isEnabled == FALSE) {
        _textColor = [NSColor colorWithRGBInt:0xe4e5e7];
        self.image = _disableImage;
        return;
    }
    self.image = _normalImage;
    _textColor = _normalColor;
}

- (void)setImage:(NSString *)normal withHover:(NSString *)hover disable:(NSString *)disable {
    _normalImage = [NSImage imageNamed:normal];
    _hoverImage = [NSImage imageNamed:hover];
    _disableImage = [NSImage imageNamed:disable];
    if (self.isEnabled == FALSE) {
        self.image = _disableImage;
    }else {
        self.image = _normalImage;
    }
    self.alternateImage = _hoverImage;
}

- (void)setTitle:(NSString *)title withNormalColor:(NSColor *)normal hoverColor:(NSColor *)hover disableColor:(NSColor *)disable {
    _titleValue = title;
    _normalColor = normal;
    _hoverColor = hover;
    _disableColor = disable;
    if (self.isEnabled == FALSE) {
        _textColor = _disableColor;
    }else {
        _textColor = _normalColor;
    }
}

@end
