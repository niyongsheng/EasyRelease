//
//  NYSUtils.h
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/22.
//  Copyright © 2021 NYS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSUtils : NSObject

+ (void)showAlertPanel:(NSString *)info forWindow:(NSWindow *)window completionHandler:(void (^ _Nullable)(NSModalResponse returnCode))handler;

+ (NSImage *)changeImage:(NSImage *)aImage WithTintColor:(NSColor *)tintColor;

+ (BOOL)blankString:(NSString *)string;

+ (NSString *)generateRandomString:(int)lenght;

@end

NS_ASSUME_NONNULL_END
