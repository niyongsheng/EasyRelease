//
//  NYSNavigateItemVC.h
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol NYSNavigateItemVCDelegate <NSObject>

@required
- (void)navigateItemOnclicked:(NSInteger)index;

@end

@interface NYSNavigateItemVC : NSViewController

- (void)setImageAndTitle:(NSString *)title withIcon:(NSString *)normal isAutoFit:(BOOL)isAutoFit index:(NSInteger)index viewRect:(NSRect)rect;

- (void)setImageAndTitle:(NSString*)title withNormalIcon:(NSString*)normal hoverIcon:(NSString*)hover index:(NSInteger)index viewRect:(NSRect)rect;

- (void)setBkColor:(NSColor*)color;

@property (nonatomic, weak) id<NYSNavigateItemVCDelegate> delegate;

@end
