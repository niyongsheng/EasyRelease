//
//  NYSUtils.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/22.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSUtils.h"

@implementation NYSUtils

+ (void)showAlertPanel:(NSString *)info forWindow:(NSWindow *)window completionHandler:(void (^ _Nullable)(NSModalResponse returnCode))handler {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"I know"];
    [alert setMessageText:@"Warning"];
    [alert setInformativeText:info];
    [alert setAlertStyle:NSAlertStyleCritical];
    [alert beginSheetModalForWindow:window completionHandler:handler];
}

+ (NSImage *)changeImage:(NSImage *)aImage WithTintColor:(NSColor *)tintColor {
    if (aImage.isTemplate) {
        return aImage;
    }
    
    NSImage *image = aImage.copy;
    [image lockFocus];
    [tintColor set];
    
    NSRect imageRect = NSMakeRect(0, 0, image.size.width, image.size.height);
    NSRectFillUsingOperation(imageRect, NSCompositingOperationSourceAtop);
    
    [image unlockFocus];
    [image setTemplate:false];
    
    return image;
}

+ (BOOL)blankString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return  YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return  YES;
    }
    if (string == NULL || [string isEqual:nil] || [string isEqual:Nil] || string == nil) {
        return  YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return  YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return  YES;
    }
    if (string.length == 0 || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return  YES;
    }
    return NO;
}

/// 生成首字母大写的指定长度随机字符串
+ (NSString *)generateRandomString:(int)lenght {
    NSString *sourceStr = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < lenght; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        while (([sourceStr characterAtIndex:index] > 96) && ([sourceStr characterAtIndex:index] < 123) && (i==0)) {
            index = rand() % [sourceStr length];
            oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        }
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

/// 提取字符串中的大写字母
+ (NSString *)getCapitalString:(NSString *)str {
    NSInteger alength = [str length];
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i<alength; i++) {
        char commitChar = [str characterAtIndex:i];
        if ((commitChar>64) && (commitChar<91)) {
            [resultStr appendString:[str substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    if (resultStr.length == 0) {
        [resultStr appendString:@"ER"];
    }
    return resultStr;
}

@end
