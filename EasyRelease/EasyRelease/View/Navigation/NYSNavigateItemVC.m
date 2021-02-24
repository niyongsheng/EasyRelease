//
//  NYSNavigateItemVC.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSNavigateItemVC.h"
#import "NYSTextButton.h"
#import "NYSImageButton.h"
#import "NYSNavigateItem.h"

@interface NYSNavigateItemVC ()

@property (nonatomic, strong) NYSNavigateItem *navigateItem;

@property (nonatomic, strong) NYSTextButton *textButton;

@property (nonatomic, strong) NYSImageButton *imageButton;

@property (nonatomic, strong) NSString *titleValue;

@property (nonatomic, strong) NSString *normalIcon;

@property (nonatomic, strong) NSString *hoverIcon;

@property (nonatomic) NSRect viewRect;

@property (nonatomic, strong) NSColor *bkColor;

@property (nonatomic, assign) BOOL isAutoFit;

@property (nonatomic, assign) NSInteger index;

@end

@implementation NYSNavigateItemVC

- (void)setImageAndTitle:(NSString *)title withIcon:(NSString *)normal isAutoFit:(BOOL)isAutoFit index:(NSInteger)index viewRect:(NSRect)rect {
    _index = index;
    _titleValue = title;
    _normalIcon = normal;
    _isAutoFit = isAutoFit;
    _viewRect = rect;
}

- (void)setImageAndTitle:(NSString*)title withNormalIcon:(NSString*)normal hoverIcon:(NSString*)hover index:(NSInteger)index viewRect:(NSRect)rect {
    _index = index;
    _titleValue = title;
    _normalIcon = normal;
    _hoverIcon = hover;
    _viewRect = rect;
}

- (void)setBkColor:(NSColor *)color {
    _bkColor = color;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _imageButton = [[NYSImageButton alloc] initWithFrame:NSMakeRect(0, 0, 50, ItemHeight)];
    if (_isAutoFit) {
        [_imageButton setImage:_normalIcon isAutoFit:YES];
    } else {
        [_imageButton setImage:_normalIcon withHover:_hoverIcon];
    }
    [self.view addSubview:_imageButton];
    
    _textButton = [[NYSTextButton alloc] initWithFrame:NSMakeRect(50, 0, 122, ItemHeight)];
    [_textButton setFontSize:14];
    [_textButton setTitle:_titleValue withNormalColor:[NSColor colorWithRGBInt:MainFontColor] hoverColor:[NSColor colorWithRGBInt:ThemeColor]];
    [_textButton setTag:_index];
    [_textButton setTarget:self];
    [_textButton setAction:@selector(buttonOnClicked:)];
    [self.view addSubview:_textButton];
}

- (void)loadView {
    _navigateItem = [[NYSNavigateItem alloc] initWithFrame:_viewRect];
    [_navigateItem setBkColor:_bkColor];
    self.view = _navigateItem;
}

- (void)buttonOnClicked:(NSButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(navigateItemOnclicked:)]) {
        [_delegate navigateItemOnclicked:_index];
    }
}

@end
