//
//  NYSPanelWindow.m
//  EasyRelease
//
//  Created by niyongsheng on 2021/3/3.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSPanelWindow.h"
#import "YYModel.h"

@interface NYSPanelWindow ()
@property (weak) IBOutlet NSTextField *projectNameField;

@end

@implementation NYSPanelWindow

- (IBAction)okOnclicked:(NSButtonCell *)sender {
    if ([NYSUtils blankString:_projectNameField.stringValue]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ActionInfoNotice object:@"\nnull value\n"];
        return;
    }
    
    [self close];
    
    NSString *prefixStr = _projectNameField.stringValue;
    NSString *capitalStr = [NYSUtils getCapitalString:prefixStr];
    if (![NYSUtils blankString:NConfig.projectNewName]) {
        capitalStr = [NYSUtils getCapitalString:NConfig.projectNewName];
    }
    if ([NYSUtils blankString:NConfig.projectNewName] && [NYSUtils blankString:NConfig.projectOldName]) {
        NConfig.projectOldName = _oldProjectName;
        NConfig.projectNewName = prefixStr;
    } else if ([NYSUtils blankString:NConfig.projectNewName] && ![NYSUtils blankString:NConfig.projectOldName]) {
        NConfig.projectNewName = prefixStr;
    } else if (![NYSUtils blankString:NConfig.projectNewName] && [NYSUtils blankString:NConfig.projectOldName]) {
        NConfig.projectOldName = _oldProjectName;
    }
    
    for (int i = 0; i < NConfig.replaceArray.count; i++) {
        NSDictionary *replaceDict = NConfig.replaceArray[i];
        if ([NYSUtils blankString:replaceDict[@"NewPrefix"]] && ![NYSUtils blankString:replaceDict[@"OldPrefix"]]) {
            NSMutableDictionary *mutableReplaceDict = [NSMutableDictionary dictionaryWithDictionary:replaceDict];
            NSString *newValue = [NSString stringWithFormat:@"%@_%@", capitalStr, replaceDict[@"OldPrefix"]];
            if ([replaceDict[@"Type"] isEqual:@"global"]) {
                newValue = [NSString stringWithFormat:@"%@_", capitalStr];
            }
            [mutableReplaceDict setValue:newValue forKey:@"NewPrefix"];
            NConfig.replaceArray[i] = mutableReplaceDict;
        }
    }
    
    // 发送刷新配置通知
    NSString *objStr = [NConfig yy_modelToJSONString];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshConfNotice object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ActionInfoNotice object:objStr];
}

@end
