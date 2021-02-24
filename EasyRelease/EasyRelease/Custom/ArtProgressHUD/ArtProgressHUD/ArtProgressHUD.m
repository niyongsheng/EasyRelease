#import "ArtProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "ArtHUDView.h"
#import "AppDelegate.h"

#define kWindowAlpha 0.86
#define kCornerRadius 12


static ArtProgressHUD *_hudProgress;

@interface ArtProgressHUD ()
@property (nonatomic, assign) EArtProgressHUDType alertType;
@property (nonatomic, strong) ArtHUDView *hudView;
@property (nonatomic, strong) NSWindow *appWindow;
@property (nonatomic, strong) NSTimer *dismissTimer;
@property (nonatomic, strong) NSEvent *clickEvent;


@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSTextField *tipTextField;
@property (weak) IBOutlet NSTextField *onlyTipTextField;
@property (weak) IBOutlet NSProgressIndicator *loadingIndicator;


@property (nonatomic, strong) NSView *popView;

@end

@implementation ArtProgressHUD

+ (void)showText:(NSString *)aText
{
    [ArtProgressHUD showText:aText type:EArtProgressHUDTypeNone inView:nil];
}


+ (void)showInfoText:(NSString *)aText
{
    [ArtProgressHUD showText:aText type:EArtProgressHUDInfo inView:nil];
}

+ (void)showErrorText:(NSString *)aText
{
    [ArtProgressHUD showText:aText type:EArtProgressHUDError inView:nil];
}


+ (void)showSuccessText:(NSString *)aText
{
    [ArtProgressHUD showText:aText type:EArtProgressHUDSuccess inView:nil];
}


+ (void)showText:(NSString *)aText type:(EArtProgressHUDType)aType inView:(NSView *)aView
{
    if (!_hudProgress) {
        _hudProgress = [[self alloc] init];
    }
    
    if (aView) {
        _hudProgress.popView = aView;
    }
    
    [ArtProgressHUD configImageNameWithType:aType];
    
    _hudProgress.tipTextField.stringValue = aText;
    _hudProgress.onlyTipTextField.stringValue = aText;
    [_hudProgress.onlyTipTextField sizeToFit];
    
    if (_hudProgress.window.parentWindow) {
        [_hudProgress.window.parentWindow removeChildWindow:_hudProgress.window];
    }
    
    AppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate.mainWC.window addChildWindow:_hudProgress.window ordered:NSWindowAbove];
    [_hudProgress showWindow:delegate.mainWC.window];
}

+ (void)showLoading
{
    [ArtProgressHUD showLoading:nil];
}

+ (void)showLoading:(NSView *)aView;

{
    if (!_hudProgress) {
        _hudProgress = [[self alloc] init];
    }
    
    if (aView) {
        _hudProgress.popView = aView;
    }
    
    [ArtProgressHUD configImageNameWithType:EArtProgressHUDLoading];
    
    if (_hudProgress.window.parentWindow) {
        [_hudProgress.window.parentWindow removeChildWindow:_hudProgress.window];
    }
    
    AppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate.mainWC.window addChildWindow:_hudProgress.window ordered:NSWindowAbove];
    [_hudProgress showWindow:delegate.mainWC.window];
}


+ (void)dismissLoading
{
    [_hudProgress dismiss:nil];
}


- (void)showImage:(NSImage*)image text:(NSString*)aText
{
    
}


#pragma mark - Private Method

+ (void)configImageNameWithType:(EArtProgressHUDType)aType
{
    NSString *iconName = nil;
    switch (aType) {
        case EArtProgressHUDError:
            iconName = @"MLHudAlertError";
            break;
        case EArtProgressHUDInfo:
            iconName = @"MLHudAlertInfo";
            break;
        case EArtProgressHUDSuccess:
            iconName = @"MLHudAlertSuccess";
            break;
        case EArtProgressHUDWarning:
            iconName = @"MLHudAlertWarn";
            break;
        default:
            break;
    }
    _hudProgress.alertType = aType;
    [ArtProgressHUD configUIWithType:aType imageName:iconName];
}

+ (void)configUIWithType:(EArtProgressHUDType)aType imageName:(NSString *)aName
{
    if (aType == EArtProgressHUDLoading) {
        [_hudProgress.iconImageView setHidden:YES];
        [_hudProgress.loadingIndicator setHidden:NO];
        [_hudProgress.loadingIndicator startAnimation:nil];
        [_hudProgress.tipTextField setHidden:YES];
        [_hudProgress.onlyTipTextField setHidden:YES];
    } else if (aType == EArtProgressHUDTypeNone) {
        [_hudProgress.iconImageView setHidden:YES];
        [_hudProgress.loadingIndicator setHidden:YES];
        [_hudProgress.tipTextField setHidden:YES];
        [_hudProgress.onlyTipTextField setHidden:NO];
        
        [_hudProgress.iconImageView removeConstraints:_hudProgress.iconImageView.constraints];
        [_hudProgress.loadingIndicator removeConstraints:_hudProgress.loadingIndicator.constraints];
        [_hudProgress.tipTextField removeConstraints:_hudProgress.tipTextField.constraints];
    }  else {
        [_hudProgress.loadingIndicator setHidden:YES];
        [_hudProgress.iconImageView setHidden:NO];
        _hudProgress.iconImageView.image = [NSImage imageNamed:aName];
        [_hudProgress.onlyTipTextField setHidden:YES];
    }
}




- (void)updateWindowPosition {
    if (!self.window.parentWindow) {
        return;
    }

    NSRect parentRect = self.window.parentWindow.frame;
    if (_hudProgress.popView) {
        parentRect = NSMakeRect(parentRect.origin.x+_hudProgress.popView.frame.origin.x, parentRect.origin.y+_hudProgress.popView.frame.origin.y, _hudProgress.popView.frame.size.width, _hudProgress.popView.frame.size.height);
        
        CGFloat width = _hudProgress.popView.frame.size.width>150?150:_hudProgress.popView.frame.size.width;
        CGFloat height = _hudProgress.popView.frame.size.height > 100?100:_hudProgress.popView.frame.size.height;
        [self.window setContentSize:NSMakeSize(width, height)];
    } else {
        [self.window setContentSize:NSMakeSize(150, 100)];
    }
    [self.window setFrameOrigin:NSMakePoint(NSMidX(parentRect) - NSWidth(self.window.frame) / 2, NSMidY(parentRect) - NSHeight(self.window.frame) / 2)];
}

- (void)showWindow:(id)sender {
    self.window.alphaValue = 0;
    [super showWindow:sender];
    [self updateWindowPosition];
    [[self.window animator] setAlphaValue:kWindowAlpha];
    
    if (self.alertType != EArtProgressHUDLoading) {
        // 延迟关闭
        [self.dismissTimer invalidate];
        self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismiss:) userInfo:nil repeats:NO];
        
        // 点击任何区域关闭 Hud
        if (self.clickEvent) {
            [NSEvent removeMonitor:self.clickEvent];
        }
        
         __weak typeof(self) weakSelf = self;
        self.clickEvent = [NSEvent addLocalMonitorForEventsMatchingMask:(NSEventMaskLeftMouseDown | NSEventMaskRightMouseDown) handler:^NSEvent *(NSEvent *e) {
            if (!NSPointInRect(NSEvent.mouseLocation, self.window.frame)) {
                if (weakSelf.clickEvent) {
                    [NSEvent removeMonitor:weakSelf.clickEvent];
                    weakSelf.clickEvent = nil;
                }
                
                [self dismiss:nil];
            }
            return e;
        }];
    } else {
        
    }
}

- (void)dismiss:(id)sender {
    [[self.window animator] setAlphaValue:0.0];
    _hudProgress = nil;
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadNibNamed:@"ArtProgressHUD" owner:self];
    }
    return self;
}


- (void)loadNibNamed:(NSString *)nibName owner:(id)owner {
    [[NSBundle mainBundle] loadNibNamed:nibName owner:owner topLevelObjects:nil];
}

- (void)awakeFromNib {
    [(ArtHUDView *)self.window setCornerRadius:kCornerRadius];
    [self.tipTextField setTextColor:[NSColor whiteColor]];
    [self.tipTextField.cell setBackgroundStyle:NSBackgroundStyleLowered];
    self.tipTextField.preferredMaxLayoutWidth = 120;
    
    [self.iconImageView setImageScaling:NSImageScaleAxesIndependently];
//    self.loadingIndicator.controlTint = NSBlueControlTint;
    
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setDefaults];
    [lighten setValue:@1 forKey:@"inputBrightness"];
    [self.loadingIndicator setContentFilters:[NSArray arrayWithObjects:lighten, nil]];
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.alertType != EArtProgressHUDLoading) {
        [self dismiss:nil];
    }
}



@end
