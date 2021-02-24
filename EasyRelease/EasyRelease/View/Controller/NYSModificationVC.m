//
//  NYSModificationVC.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/19.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSModificationVC.h"

@interface NYSModificationVC ()
@property (weak) IBOutlet NSTextField *nameOldTextField;
@property (weak) IBOutlet NSTextField *nameNewTextField;
@property (weak) IBOutlet NSSwitch *delAnnotationSwitch;
@property (weak) IBOutlet NSSwitch *rehashImgSwitch;
@end

@implementation NYSModificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSControlTextDidChangeNotification object:_nameOldTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSControlTextDidChangeNotification object:_nameNewTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshConfigUINotificationHandler:) name:RefreshConfNotice object:nil];
    
    self.delAnnotationSwitch.layer.backgroundColor = [NSColor colorWithRGBInt:ThemeColor].CGColor;
    self.rehashImgSwitch.layer.backgroundColor = [NSColor colorWithRGBInt:ThemeColor].CGColor;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil]) {
        self.view.wantsLayer = YES;
        [self.view setFrame:frameRect];
        [self.view.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    }
    return self;
}

- (IBAction)delAnnotationSwitched:(NSSwitch *)sender {
    NConfig.isDelAnnotation = sender.state;
}

- (IBAction)rehashImgSwitched:(NSSwitch *)sender {
    if (sender.state == YES) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Installed"];
        [alert addButtonWithTitle:@"Uninstall"];
        [alert setIcon:[NSImage imageNamed:@"terminal"]];
        [alert setMessageText:@"Install shell"];
        [alert setInformativeText:@"`brew install imagemagick`"];
        [alert setAlertStyle:NSAlertStyleInformational];
        [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn) {
                NConfig.isRehashImages = sender.state;
            } else if (returnCode == NSAlertSecondButtonReturn) {
                sender.state = NO;
                NSLog(@"onclicked uninstall");
            }
        }];
    } else {
        NConfig.isRehashImages = sender.state;
    }
}


- (void)contextDidChange:(NSNotification *)notification {
    if (notification.object == _nameOldTextField) {
        if (_nameOldTextField.stringValue.length <= 0) {
            [ArtProgressHUD showInfoText:@"please input old project name"];
        }
        NConfig.projectOldName = _nameOldTextField.stringValue;
    } else if (notification.object == _nameNewTextField) {
        if (_nameNewTextField.stringValue.length <= 0) {
            [ArtProgressHUD showInfoText:@"please input new project name"];
        }
        NConfig.projectNewName = _nameNewTextField.stringValue;
    }
}

- (void)RefreshConfigUINotificationHandler:(NSNotification *)notification {
    self.delAnnotationSwitch.state = NConfig.isDelAnnotation;
    self.rehashImgSwitch.state = NConfig.isRehashImages;
    
    self.nameOldTextField.stringValue = NConfig.projectOldName;
    self.nameNewTextField.stringValue = NConfig.projectNewName;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshConfNotice object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidChangeNotification object:nil];
}

@end
