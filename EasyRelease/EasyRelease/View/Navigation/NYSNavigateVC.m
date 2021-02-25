//
//  NYSNavigateVC.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSNavigateVC.h"
#include "NYSNavigateItemVC.h"
#include "NSColor+RGBValue.h"

@interface NYSNavigateVC () <NYSNavigateItemVCDelegate>

@property (nonatomic, strong) NYSNavigateItemVC *projectImportItemVC;

@property (nonatomic, strong) NYSNavigateItemVC *modificationItemVC;

@property (nonatomic, strong) NYSNavigateItemVC *mixConfigItemVC;

@property (nonatomic, strong) NYSNavigateItemVC *actionItemVC;

@end

@implementation NYSNavigateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _projectImportItemVC = [[NYSNavigateItemVC alloc] init];
    [_projectImportItemVC setImageAndTitle:@"Project Import" withIcon:@"icon_nav_normal_import" isAutoFit:YES index:0 viewRect:NSMakeRect(0, 0 * ItemHeight, 168, ItemHeight)];
    [_projectImportItemVC setBkColor:[NSColor colorWithRGBInt:SelectBackgroundColor]];
    [_projectImportItemVC setDelegate:self];
    [self addChildViewController:_projectImportItemVC];
    [self.view addSubview:_projectImportItemVC.view];
    
    _modificationItemVC = [[NYSNavigateItemVC alloc] init];
    [_modificationItemVC setImageAndTitle:@"modify Config" withIcon:@"icon_nav_normal_modify" isAutoFit:YES index:1 viewRect:NSMakeRect(0, 1 * ItemHeight, 168, ItemHeight)];
    [_modificationItemVC setBkColor:[NSColor colorWithRGBInt:0xffffff]];
    [_modificationItemVC setDelegate:self];
    [self addChildViewController:_modificationItemVC];
    [self.view addSubview:_modificationItemVC.view];
    
    _mixConfigItemVC = [[NYSNavigateItemVC alloc] init];
    [_mixConfigItemVC setImageAndTitle:@"Replace Config" withIcon:@"icon_nav_normal_mix" isAutoFit:YES index:2 viewRect:NSMakeRect(0, 2 * ItemHeight, 168, ItemHeight)];
    [_mixConfigItemVC setBkColor:[NSColor colorWithRGBInt:0xffffff]];
    [_mixConfigItemVC setDelegate:self];
    [self addChildViewController:_mixConfigItemVC];
    [self.view addSubview:_mixConfigItemVC.view];
    
    _actionItemVC = [[NYSNavigateItemVC alloc] init];
    [_actionItemVC setImageAndTitle:@"Action" withIcon:@"icon_nav_normal_action" isAutoFit:YES index:3 viewRect:NSMakeRect(0, 3 * ItemHeight, 168, ItemHeight)];
    [_actionItemVC setBkColor:[NSColor colorWithRGBInt:0xffffff]];
    [_actionItemVC setDelegate:self];
    [self addChildViewController:_actionItemVC];
    [self.view addSubview:_actionItemVC.view];
}

- (void)navigateItemOnclicked:(NSInteger)index {
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeNavNotice object:nil userInfo:@{@"target": [NSNumber numberWithInteger:index]}];
}

@end
