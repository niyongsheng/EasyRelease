//
//  NYSConfigManager.h
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/23.
//  Copyright © 2021 NYS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYSConfigModel.h"

#define NConfig [NYSConfigManager sharedNYSConfigManager].configModel

NS_ASSUME_NONNULL_BEGIN

@interface NYSConfigManager : NSObject

+ (NYSConfigManager *)sharedNYSConfigManager;

@property (nonatomic, strong) NYSConfigModel *configModel;


@end

NS_ASSUME_NONNULL_END
