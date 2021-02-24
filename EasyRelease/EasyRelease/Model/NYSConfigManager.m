//
//  NYSConfigManager.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/23.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSConfigManager.h"

@implementation NYSConfigManager

+ (NYSConfigManager *)sharedNYSConfigManager {
    static NYSConfigManager *sharedNYSConfigManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNYSConfigManager = [[self alloc] init];
    });
    return sharedNYSConfigManager;
}

- (NYSConfigModel *)configModel {
    if (!_configModel) {
        _configModel = [NYSConfigModel new];
    }
    return _configModel;
}

@end
