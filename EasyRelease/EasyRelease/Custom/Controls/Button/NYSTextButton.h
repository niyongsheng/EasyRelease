//
//  NYSTextButton.h
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NYSTextButton : NSButton

@property (nonatomic) int fontSize;

- (void)setTitle:(NSString *)title
       withNormalColor:(NSColor *)normal
        hoverColor:(NSColor *)hover;

- (void)setMouseEntered;

- (void)setMouseExited;

@end
