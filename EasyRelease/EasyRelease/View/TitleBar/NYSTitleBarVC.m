//
//  NYSTitleBarVC.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSTitleBarVC.h"
#import "NYSImageButton.h"
#import "NYSTextButton.h"
#import "NYSNoticeVC.h"

@interface NYSTitleBarVC ()

@property (nonatomic, strong) NSImageView *logo;

@property (nonatomic, strong) NSTextField *titleLabel;

@property (nonatomic, strong) NYSImageButton *closeBtn;

@property (nonatomic, strong) NYSImageButton *minBtn;

@property (nonatomic, strong) NYSImageButton *settingBtn;

@property (nonatomic, strong) NYSTextButton *feedbackBtn;

@property (nonatomic, strong) NYSNoticeVC *noticeVC;

@end

@implementation NYSTitleBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSRect rect = [self.view bounds];
    
    // Do view setup here.
    _logo = [[NSImageView alloc] initWithFrame:NSMakeRect(40, 15, 36, 36)];
    [_logo setImage:[NSImage imageNamed:@"logo"]];
    [_logo setTarget:self];
    [self.view addSubview:_logo];
    
    _titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(80, 15, 150, 40)];
    _titleLabel.editable = NO;
    _titleLabel.bordered = NO;
    _titleLabel.stringValue = @"ER";
    _titleLabel.backgroundColor = [NSColor clearColor];
    _titleLabel.textColor = [NSColor whiteColor];
    _titleLabel.font = [NSFont boldSystemFontOfSize:30];
    _titleLabel.alignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    
    _noticeVC = [[NYSNoticeVC alloc] init];
    [self addChildViewController:_noticeVC];
    [self.view addSubview:_noticeVC.view];
    
    _settingBtn = [[NYSImageButton alloc] initWithFrame:NSMakeRect(rect.size.width - 109, 22, 16, 16)];
    [_settingBtn setImage:@"icon_setting" isAutoFit:NO];
    [_settingBtn setTarget:self];
    [_settingBtn setAction:@selector(settingBtnClicked:)];
    [self.view addSubview:_settingBtn];
    
    _minBtn = [[NYSImageButton alloc] initWithFrame:NSMakeRect(rect.size.width - 63, 22, 16, 16)];
    [_minBtn setImage:@"icon_minimize" isAutoFit:NO];
    [_minBtn setTarget:self];
    [_minBtn setAction:@selector(minBtnClicked:)];
    [self.view addSubview:_minBtn];
    
    _closeBtn = [[NYSImageButton alloc] initWithFrame:NSMakeRect(rect.size.width - 34, 22, 16, 16)];
    [_closeBtn setImage:@"icon_close" isAutoFit:NO];
    [_closeBtn setTarget:self];
    [_closeBtn setAction:@selector(closeBtnClicked:)];
    [self.view addSubview:_closeBtn];

}

- (void)closeBtnClicked:(id)sender {
    [self.view.window close];
}

- (void)minBtnClicked:(id)sender {
    [self.view.window miniaturize:self];
    [[NSApp mainWindow] miniaturize:nil];
    [[NSApp mainWindow] performMiniaturize:self];
}

- (void)settingBtnClicked:(id)sender {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Issues"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Easy Release"];
    [alert setInformativeText:app_Version];
    [alert setAlertStyle:NSAlertStyleInformational];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/niyongsheng/EasyRelease/issues/new"]];
        } else if (returnCode == NSAlertSecondButtonReturn) {
            NSLog(@"onclicked cancel");
        }
    }];
}

@end
