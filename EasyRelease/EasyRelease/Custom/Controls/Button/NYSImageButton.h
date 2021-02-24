//
//  NYSImageButton.h
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NYSImageButton : NSButton

- (void)setImage:(NSString *)normal
       isAutoFit:(BOOL)isAutoFit;

- (void)setImage:(NSString *)normal
       withHover:(NSString *)hover;

- (void)setImage:(NSString *)normal
       withHover:(NSString *)hover
    withDisabled:(NSString *)disabled;

- (void)setTitle:(NSString *)title
       withNormalColor:(NSColor *)normal
        hoverColor:(NSColor *)hover;

- (void)setMouseEntered;

- (void)setMouseExited;

@end
