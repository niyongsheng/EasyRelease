//
//  NYSAction.h
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/23.
//  Copyright © 2021 NYS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYSConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NYSAction : NSObject
- (instancetype)initWithConfig:(NYSConfigModel *)config;
- (void)action;
@end

NS_ASSUME_NONNULL_END
