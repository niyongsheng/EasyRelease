//
//  NYSImageTextButton.h
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NYSImageTextButton : NSButton

@property (nonatomic) int fontSize;

- (void)setImage:(NSString *)normal
       withHover:(NSString *)hover
         disable:(NSString *)disable;

- (void)setTitle:(NSString *)title
 withNormalColor:(NSColor *)normal
      hoverColor:(NSColor *)hover
    disableColor:(NSColor *)disable;

@end
