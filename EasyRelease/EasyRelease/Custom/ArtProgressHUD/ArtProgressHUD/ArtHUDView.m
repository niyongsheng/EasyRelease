#import "ArtHUDView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ArtHUDView

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag
{
    if (self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag])
    {
        [self setStyleMask:NSWindowStyleMaskBorderless];
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
    }
    
    return self;
}

- (void)setContentView:(NSView *)aView {
    [aView setWantsLayer:YES];
//    aView.layer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
    aView.layer.backgroundColor = [NSColor systemGrayColor].CGColor;
    aView.layer.cornerRadius = 20;
    aView.layer.masksToBounds = YES;
    [super setContentView:aView];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    NSView *view = self.contentView;
    view.layer.cornerRadius = cornerRadius;
}
@end
