//
//  NYSNoticeVC.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSNoticeVC.h"
#import "NYSNoticeView.h"
#import "NYSImageButton.h"
#import "NYSFitSizeTextButton.h"

@interface NYSNoticeVC ()

@property (nonatomic, strong) NYSNoticeView *noticeView;

@property (nonatomic, strong) NYSFitSizeTextButton *noticeText;

@end

@implementation NYSNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NYSImageButton *noticeIcon = [[NYSImageButton alloc]
                                 initWithFrame:NSMakeRect(0, 1, 16, 16)];
    [noticeIcon setImage:@"icon_notice" isAutoFit:NO];
    [self.view addSubview:noticeIcon];
    
    _noticeText = [[NYSFitSizeTextButton alloc] initWithFrame:NSMakeRect(22, 0, 400, 15)];
    [_noticeText setTitle:@"EasyRelease alpha 0.0.1 version"
          withNormalColor:[NSColor colorWithRGBInt:0xffffff]
               hoverColor:[NSColor colorWithRGBInt:0xffffff]];
    [_noticeText setTarget:self];
    [_noticeText setAction:@selector(noticeBtnClicked:)];
    [self.view addSubview:_noticeText];
}

- (void)loadView {
    _noticeView = [[NYSNoticeView alloc] initWithFrame:NSMakeRect(190, 21, 400, 16)];
    self.view = _noticeView;
}

- (void)noticeBtnClicked:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/niyongsheng/EasyRelease"]];
}

@end
