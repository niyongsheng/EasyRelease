//
//  NYSActionVC.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/19.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSActionVC.h"
#import "YYModel.h"
#import "NYSConfigModel.h"
#import "NYSAction.h"
#import "NYSShowTipViewControlle.h"

@interface NYSActionVC ()
{
    NSString *tempStr;
    NSPipe *outputPipe;
    NSTask *task;
}
@property (weak) IBOutlet NSButton *actionBtn;
@property (weak) IBOutlet NSPathControl *uploadPathControl;
@property (weak) IBOutlet NSPathControl *downloadPathControl;
@property (unsafe_unretained) IBOutlet NSTextView *actionInfoTextView;

@property (nonatomic, strong) NSPopover *showTipPopover;

@end

@implementation NYSActionVC
- (NSPopover *)showTipPopover {
    if (!_showTipPopover) {
        _showTipPopover = [[NSPopover alloc] init];
        _showTipPopover.contentViewController = [[NYSShowTipViewControlle alloc] initWithNibName:@"NYSShowTipViewControlle" bundle:nil];
        _showTipPopover.behavior = NSPopoverBehaviorSemitransient;
    }
    return _showTipPopover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.actionInfoTextView.string = @"Hi ~\nEasy Release is already...";
//    self.actionInfoTextView.textColor = [NSColor colorWithRGBInt:ThemeColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActionInfoNotificationHandler:) name:ActionInfoNotice object:nil];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil]) {
        self.view.wantsLayer = YES;
        [self.view setFrame:frameRect];
        [self.view.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    }
    return self;
}

- (IBAction)uploadJsonFile:(NSButton *)sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:NO];
    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setCanChooseFiles:YES];
    [oPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"json", nil]];
    if ([oPanel runModal] == NSModalResponseOK) {
        NSURL *url = [[oPanel URLs] objectAtIndex:0];
        _uploadPathControl.URL = url;
        NSString *str = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfURL:url] encoding:NSUTF8StringEncoding];
        if ([NConfig yy_modelSetWithJSON:str]) {
            NYSConfigModel *model = [NYSConfigModel yy_modelWithJSON:str];
            if (model.isSasS) { // SasS环境下自动配置
                NSString *pnStr = url.path.lastPathComponent.stringByDeletingPathExtension;
                NSString *pPath = url.absoluteString.stringByDeletingLastPathComponent;
                if ([NYSUtils blankString:model.projectFileDirUrl.absoluteString]) {
                    model.projectFileDirUrl = [NSURL URLWithString:[pPath stringByAppendingFormat:@"/%@.xcodeproj", pnStr]];
                }
                if ([NYSUtils blankString:model.projectDirUrl.absoluteString]) {
                    model.projectDirUrl = [NSURL URLWithString:[pPath stringByAppendingFormat:@"/%@", pnStr]];
                }
                
                if (model.isAuto) {
                    NSString *prefixStr = [NYSUtils generateRandomString:4];
                    if ([NYSUtils blankString:model.projectNewName] && [NYSUtils blankString:model.projectOldName]) {
                        model.projectOldName = pnStr;
                        model.projectNewName = [NSString stringWithFormat:@"%@_%@", prefixStr, pnStr];
                    } else if ([NYSUtils blankString:model.projectNewName] && ![NYSUtils blankString:model.projectOldName]) {
                        model.projectNewName = [NSString stringWithFormat:@"%@_%@", prefixStr, model.projectOldName];
                    }
                    
                    for (int i = 0; i < model.replaceArray.count; i++) {
                        NSDictionary *replaceDict = model.replaceArray[i];
                        if ([NYSUtils blankString:replaceDict[@"NewPrefix"]] && ![NYSUtils blankString:replaceDict[@"OldPrefix"]]) {
                            NSMutableDictionary *mutableReplaceDict = [NSMutableDictionary dictionaryWithDictionary:replaceDict];
                            NSString *newValue = [NSString stringWithFormat:@"%@_%@", prefixStr, replaceDict[@"OldPrefix"]];
                            [mutableReplaceDict setValue:newValue forKey:@"NewPrefix"];
                            model.replaceArray[i] = mutableReplaceDict;
                        }
                    }
                } else {
                    // TODO手动配置
                    
                }
            }
            NConfig = model;
            // 发送刷新配置通知
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshConfNotice object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:ActionInfoNotice object:[NConfig yy_modelToJSONString]];
        } else {
            [ArtProgressHUD showErrorText:@"error json file"];
        }
    }
}

- (IBAction)downloadJsonFile:(NSButton *)sender {
    if ([NYSUtils blankString:NConfig.projectFileDirUrl.path]) {
        [NYSUtils showAlertPanel:@"Missing project file parameter" forWindow:self.view.window completionHandler:nil];
        return;
    }
    
    if ([NYSUtils blankString:NConfig.projectDirUrl.path]) {
        [NYSUtils showAlertPanel:@"Missing project Directory parameter" forWindow:self.view.window completionHandler:nil];
        return;
    }
    
    NSSavePanel *sPanel = [NSSavePanel savePanel];
    [sPanel setTitle:@"Save File"];
    [sPanel setMessage:@"Save Config Json File"];
    [sPanel setPrompt:NULL];
    [sPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"json", nil]];
    [sPanel setCanCreateDirectories:YES];
    [sPanel setCanSelectHiddenExtension:YES];
    [sPanel setNameFieldStringValue:NConfig.projectFileDirUrl.path.lastPathComponent.stringByDeletingPathExtension];
    NSString *pPath = NConfig.projectFileDirUrl.absoluteString.stringByDeletingLastPathComponent;
    [sPanel setDirectoryURL:[NSURL URLWithString:pPath]];
    
    __block NSString *chooseFile;
    [sPanel beginSheetModalForWindow:[NSApp mainWindow] completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            chooseFile = [[sPanel URL] path];
            self->_downloadPathControl.URL = [sPanel URL];
            NSData *data = [NConfig yy_modelToJSONData];
            [data writeToFile:chooseFile atomically:true];
            [ArtProgressHUD showSuccessText:@"save success"];
            NSLog(@"Click OK Choose files : %@",chooseFile);
        } else if (result == NSModalResponseCancel)
            NSLog(@"Click cancle");
    }];
}

- (IBAction)action:(NSButton *)sender {
    // 项目配置校验
    if ([NYSUtils blankString:NConfig.projectFileDirUrl.path]) {
        [NYSUtils showAlertPanel:@"Missing project file parameter" forWindow:self.view.window completionHandler:nil];
        return;
    }
    
    if ([NYSUtils blankString:NConfig.projectDirUrl.path]) {
        [NYSUtils showAlertPanel:@"Missing project Directory parameter" forWindow:self.view.window completionHandler:nil];
        return;
    }
    
    [sender setEnabled:NO];
    // action change...
    @try {
        NYSAction *action = [[NYSAction alloc] initWithConfig:NConfig];
        [action action];
        [ArtProgressHUD showSuccessText:@"ER Finish"];
    } @catch (NSException *exception) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ActionInfoNotice object:exception.reason];
        [ArtProgressHUD showErrorText:@"ER Error"];
    } @finally {
        [sender setEnabled:YES];
    }
}

- (IBAction)tip:(NSButton *)sender {
    [self.showTipPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:NSRectEdgeMinY];
}

- (void)ActionInfoNotificationHandler:(NSNotification *)notification {
    NSString *newOutput = notification.object;
    
    NSString *previousOutput = self.actionInfoTextView.string;
    NSString *nextOutput = [NSString stringWithFormat:@"%@\n%@", previousOutput, newOutput];
    self.actionInfoTextView.string = nextOutput;
    // 滚动到可视位置
    NSRange range = {nextOutput.length, 0};
    [self.actionInfoTextView scrollRangeToVisible:range];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ActionInfoNotice object:nil];
}

@end
