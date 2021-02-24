//
//  NYSConfigModel.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/20.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSConfigModel.h"
#import "YYModel.h"

@implementation NYSConfigModel
- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
 return [self yy_modelIsEqual:object];
}

/// 自定义model转换
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *pfd = dic[@"projectFileDirUrl"];
    NSString *pd = dic[@"projectDirUrl"];
    if (![pfd isKindOfClass:[NSString class]] || ![pd isKindOfClass:[NSString class]]) return NO;
    _projectFileDirUrl = [NSURL URLWithString:pfd];
    _projectDirUrl = [NSURL URLWithString:pd];
    return YES;
}

@end
