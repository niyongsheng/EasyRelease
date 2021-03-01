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

+ (NSString *)generateRandomString:(int)lenght {
    NSString *sourceStr = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < lenght; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


@end
