//
//  NYSAction.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/23.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSAction.h"
#include <stdlib.h>

#define NPostNotification(obj) [[NSNotificationCenter defaultCenter] postNotificationName:ActionInfoNotice object:obj];

@implementation NYSAction

BOOL regularReplacement(NSMutableString *originalString, NSString *regularExpression, NSString *newString);
void renameFile(NSString *oldPath, NSString *newPath);

#pragma mark - 公共方法
BOOL regularReplacement(NSMutableString *originalString, NSString *regularExpression, NSString *newString) {
    __block BOOL isChanged = NO;
    BOOL isGroupNo1 = [newString isEqualToString:@"\\1"];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:originalString options:0 range:NSMakeRange(0, originalString.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isChanged) {
            isChanged = YES;
        }
        if (isGroupNo1) {
            NSString *withString = [originalString substringWithRange:[obj rangeAtIndex:1]];
            [originalString replaceCharactersInRange:obj.range withString:withString];
        } else {
            [originalString replaceCharactersInRange:obj.range withString:newString];
        }
    }];
    return isChanged;
}

void renameFile(NSString *oldPath, NSString *newPath) {
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error];
    if (error) {
        NSString *obj = [NSString stringWithFormat:@"Failed to modify file name.\n  oldPath=%s\n  newPath=%s\n  ERROR:%s\n", oldPath.UTF8String, newPath.UTF8String, error.localizedDescription.UTF8String];
        NPostNotification(obj);
        abort();
    }
}

#pragma mark - 初始化
- (instancetype)initWithConfig:(NYSConfigModel *)config {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

#pragma mark - 入口
static void easyReleaseDono() {
    NPostNotification(@"Easy Release Done.");
    NPostNotification(@"\n\nPlease run shell: pod install\n");
}

- (void)action {
    NPostNotification(@"\nIs being prepared\n");
    
    // 1.删除多余的空格和注释
    if (NConfig.isDelAnnotation) {
        NSMutableArray<NSString *> *ignoreDirNames = [NSMutableArray array];
        for (NSDictionary *item in NConfig.ignoreArray) {
            if ([item[@"enable"] isEqualToString:@"1"]) {
                [ignoreDirNames addObject:item[@"name"]];
            }
        }
        
        @autoreleasepool {
            deleteComments(NConfig.projectDirUrl.path, ignoreDirNames);
            NPostNotification(@"Deleting comments and blank lines...\n");
        }
        NPostNotification(@"Deleting comments and blank lines is completed\n");
    }
    
    // 2.修改图片hash
    if (NConfig.isRehashImages) {
        @autoreleasepool {
            NPostNotification(@"Modifying the resource file...");
            rehashXcassetsFiles(NConfig.projectDirUrl.path);
        }
        NPostNotification(@"Modification of the resource file is completed");
    }
    
    // 3.类前缀+方法名替换
    if (NConfig.replaceArray.count > 0) {
        
        NSMutableArray<NSString *> *ignoreDirNames = [NSMutableArray array];
        for (NSDictionary *item in NConfig.ignoreArray) {
            [ignoreDirNames addObject:item[@"name"]];
        }
        
        NPostNotification(@"Replace prefix substitution...");
        for (NSDictionary *item in NConfig.replaceArray) {
            if ([item[@"Type"] isEqualToString:@"global"] && [item[@"Enable"] isEqualToString:@"1"]) {
                NSString *oldMethodNamePrefix = item[@"OldPrefix"];
                NSString *newMethodNamePrefix = item[@"NewPrefix"];
                if ([NYSUtils blankString:oldMethodNamePrefix] || [NYSUtils blankString:newMethodNamePrefix]) {
                    NPostNotification(@"Modifying the method name prefix, Parameters are missing! \n");
                }
                
                NSString *objPrefix = [NSString stringWithFormat:@"Begin modifying the method name prefix. %s > %s\n", oldMethodNamePrefix.UTF8String, newMethodNamePrefix.UTF8String];
                NPostNotification(objPrefix);
                @autoreleasepool {
                    // 全局替换
                    NPostNotification(@"Replacing name prefixes\n");
                    modifyMethodsPrefix(NConfig.projectDirUrl.path, [NSMutableArray array], oldMethodNamePrefix, newMethodNamePrefix, YES, NSCaseInsensitiveSearch);
                    
                    NSString *objPrefix = [NSString stringWithFormat:@"Modifying the method name prefix is complete. %s > %s\n", oldMethodNamePrefix.UTF8String, newMethodNamePrefix.UTF8String];
                    NPostNotification(objPrefix);
                }
            }
        }
        
        for (NSDictionary *item in NConfig.replaceArray) {
            if ([item[@"Type"] isEqualToString:@"method"] && [item[@"Enable"] isEqualToString:@"1"]) {
                NSString *oldMethodNamePrefix = item[@"OldPrefix"];
                NSString *newMethodNamePrefix = item[@"NewPrefix"];
                if ([NYSUtils blankString:oldMethodNamePrefix] || [NYSUtils blankString:newMethodNamePrefix]) {
                    NPostNotification(@"Modifying the method name prefix, Parameters are missing! \n");
                }
                
                NSString *objPrefix = [NSString stringWithFormat:@"Begin modifying the method name prefix. %s > %s\n", oldMethodNamePrefix.UTF8String, newMethodNamePrefix.UTF8String];
                NPostNotification(objPrefix);
                @autoreleasepool {
                    // 方法名替换
                    NPostNotification(@"Replacing name prefixes\n");
                    //                    changePrefix(NConfig.projectDirUrl.path, ignoreDirNames, oldMethodNamePrefix, newMethodNamePrefix, NSCaseInsensitiveSearch);
                    modifyMethodsPrefix(NConfig.projectDirUrl.path, [NSMutableArray array], oldMethodNamePrefix, newMethodNamePrefix, NO, NSCaseInsensitiveSearch);
                    
                    NSString *objPrefix = [NSString stringWithFormat:@"Modifying the method name prefix is complete. %s > %s\n", oldMethodNamePrefix.UTF8String, newMethodNamePrefix.UTF8String];
                    NPostNotification(objPrefix);
                }
            }
        }
        
        for (NSDictionary *item in NConfig.replaceArray) {
            if ([item[@"Type"] isEqualToString:@"method"] && [item[@"Enable"] isEqualToString:@"1"]) {
                NSString *oldMethodNamePrefix = item[@"OldPrefix"];
                NSString *newMethodNamePrefix = item[@"NewPrefix"];
                if ([NYSUtils blankString:oldMethodNamePrefix] || [NYSUtils blankString:newMethodNamePrefix]) {
                    NPostNotification(@"Modifying the method name prefix, Parameters are missing! \n");
                }
                
                NSString *objPrefix = [NSString stringWithFormat:@"Begin modifying the method name prefix. %s > %s\n", oldMethodNamePrefix.UTF8String, newMethodNamePrefix.UTF8String];
                NPostNotification(objPrefix);
                @autoreleasepool {
                    // 方法名替换
                    NPostNotification(@"Replacing name prefixes\n");
                    //                    changePrefix(NConfig.projectDirUrl.path, ignoreDirNames, oldMethodNamePrefix, newMethodNamePrefix, NSCaseInsensitiveSearch);
                    modifyMethodsPrefix(NConfig.projectDirUrl.path, [NSMutableArray array], oldMethodNamePrefix, newMethodNamePrefix, NO, NSCaseInsensitiveSearch);
                    
                    NSString *objPrefix = [NSString stringWithFormat:@"Modifying the method name prefix is complete. %s > %s\n", oldMethodNamePrefix.UTF8String, newMethodNamePrefix.UTF8String];
                    NPostNotification(objPrefix);
                }
            }
        }
        
        for (NSDictionary *item in NConfig.replaceArray) {
            if ([item[@"Type"] isEqualToString:@"class"] && [item[@"Enable"] isEqualToString:@"1"]) {
                NSString *oldClassNamePrefix = item[@"OldPrefix"];
                NSString *newClassNamePrefix = item[@"NewPrefix"];
                if ([NYSUtils blankString:oldClassNamePrefix] || [NYSUtils blankString:newClassNamePrefix]) {
                    NPostNotification(@"Replacing the class name prefix, Parameters are missing! \n");
                }
                
                NSString *objPrefix = [NSString stringWithFormat:@"Begin changing the class name prefix. %s > %s\n", oldClassNamePrefix.UTF8String, newClassNamePrefix.UTF8String];
                NPostNotification(objPrefix);
                @autoreleasepool {
                    NPostNotification(@"Replacing the class name prefix\n");
                    // 打开工程文件
                    NSError *error = nil;
                    NSString *projectFilePath = [NConfig.projectFileDirUrl.path stringByAppendingPathComponent:@"project.pbxproj"];
                    NSMutableString *projectContent = [NSMutableString stringWithContentsOfFile:projectFilePath encoding:NSUTF8StringEncoding error:&error];
                    if (error) {
                        NSString *obj = [NSString stringWithFormat:@"Open project file fail: %s：%s\n", projectFilePath.UTF8String, error.localizedDescription.UTF8String];
                        NPostNotification(obj);
                        continue;
                    }
                    // 修改类前缀
                    modifyClassNamePrefix(projectContent, NConfig.projectDirUrl.path, [NSMutableArray array], oldClassNamePrefix, newClassNamePrefix);
                    [projectContent writeToFile:projectFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                    if (error) {
                        NSString *obj = [NSString stringWithFormat:@"Write to project file fail: %s \n%s\n", projectFilePath.UTF8String, error.localizedFailureReason.UTF8String];
                        NPostNotification(obj);
                        continue;
                    }
                    // 替换文件中的引用名称
                    modifyMethodsPrefix(NConfig.projectDirUrl.path, [NSMutableArray array], oldClassNamePrefix, newClassNamePrefix, NO, NSLiteralSearch);
                    NSString *objPrefix = [NSString stringWithFormat:@"Modifying the class name prefix is complete. %s > %s\n", oldClassNamePrefix.UTF8String, newClassNamePrefix.UTF8String];
                    NPostNotification(objPrefix);
                }
            }
        }
        
        NPostNotification(@"Replace prefix substitution is completed");
    }
    
    // 4.修改工程名
    if (NConfig.projectFileDirUrl && NConfig.projectOldName && NConfig.projectNewName) {
        @autoreleasepool {
            NSString *dir = NConfig.projectFileDirUrl.path.stringByDeletingLastPathComponent;
            modifyProjectName(dir, NConfig.projectOldName, NConfig.projectNewName);
            NPostNotification(@"Changing project name...\n");
        }
        NPostNotification(@"Modification of project name completed\n");
    }
    
    // 5.pod install
    if (NConfig.isAutoPodInstall) {
        @autoreleasepool {
            NPostNotification(@"Installing third framework...");
            podInstall(NConfig.projectFileDirUrl.path.stringByDeletingLastPathComponent);
        }
        NPostNotification(@"Install third framework is completed");
    }
    
    easyReleaseDono();
}


#pragma mark - Xcassets中的图片rehash
void rehashXcassetsFiles(NSString *directory) {
    NSLog(@"Xcassets dir :%@", directory);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory;
    [fm fileExistsAtPath:directory isDirectory:&isDirectory];
    if (!isDirectory) {
        NSString *info = [NSString stringWithFormat:@"\nImage resource path is not exists at path:%@\n", directory];
        NPostNotification(info);
        return;
    }
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet];
    directory = [directory stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    [task setLaunchPath:@"/bin/sh"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rehash" ofType:@"sh"];
    [task setArguments:[NSArray arrayWithObjects:path, directory, nil]];
    
    [task launch];
    
    NSFileHandle *handle = [pipe fileHandleForReading];
    [handle waitForDataInBackgroundAndNotify];
    
    __block NSInteger blankCount = 0;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                      object:handle
                                                       queue:nil
                                                  usingBlock:^(NSNotification* notification) {
        NSData *data = [handle availableData];
        NSString *result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NPostNotification(result);
        });
        
        if ([NYSUtils blankString:result]) {
            blankCount++;
        }
        
        if (blankCount < 5) {
            [handle waitForDataInBackgroundAndNotify];
        } else {
            NPostNotification(@"\nImage files rehash completed.\n");
        }
    }];
    
    [task waitUntilExit];
}

#pragma mark - pod install
void podInstall(NSString *directory) {
    NSLog(@"Pod install dir :%@", directory);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory;
    [fm fileExistsAtPath:directory isDirectory:&isDirectory];
    if (!isDirectory) {
        NSString *info = [NSString stringWithFormat:@"\nPod install path is not exists at path:%@\n", directory];
        NPostNotification(info);
        return;
    }
    directory = quotedFromString(directory);
    
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    [task setLaunchPath:@"/bin/sh"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"podInstall" ofType:@"sh"];
    [task setArguments:[NSArray arrayWithObjects:path, directory, nil]];
    
    [task launch];
    
    NSFileHandle *handle = [pipe fileHandleForReading];
    [handle waitForDataInBackgroundAndNotify];
    
    __block NSInteger blankCount = 0;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                      object:handle
                                                       queue:nil
                                                  usingBlock:^(NSNotification* notification) {
        NSData *data = [handle availableData];
        NSString *result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NPostNotification(result);
        });
        
        if ([NYSUtils blankString:result]) {
            blankCount++;
        }
        
        if (blankCount < 5) {
            [handle waitForDataInBackgroundAndNotify];
        } else {
            NPostNotification(@"\nPod Install Done.\n\nNow you can try opening this new project file.\n\nGOOD LUCK ^^\n");
        }
    }];
    
    [task waitUntilExit];
}

static NSString* endSlashesDoubledFromString(NSString *aString) {
    NSUInteger            i = [aString length] - 2;
    NSMutableString    *returnString;
    
    if (![aString hasSuffix:@"\\"]) {
        return aString;
    }
    returnString = [NSMutableString stringWithFormat: @"%@\\", aString];
    while ([aString characterAtIndex: i] == '\\' && i >= 0) {
        [returnString appendString:@"\\"];
        i--;
    }
    
    return returnString;
}

static NSString* quotedFromString(NSString *aString) {
    NSString       *resultString;
    NSMutableArray  *components;
    NSUInteger            i;
    
    /* First split on "'s */
    components = [NSMutableArray arrayWithArray:[aString componentsSeparatedByString: @"\""]];
    
    /* Iterate over all but the last component and double slashes if needed */
    i = [components count];
    while (i-- > 0) {
        [components replaceObjectAtIndex:i withObject:endSlashesDoubledFromString([components objectAtIndex: i])];
    }
    
    /* Join them again with \" as separator */
    resultString = [components componentsJoinedByString: @"\\\""];
    
    /* Put in in "'s if it contains spaces */
    if ([resultString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
        resultString = [NSString stringWithFormat: @"\"%@\"", resultString];
    }
    return resultString;
}


#pragma mark - 删除注释
void deleteComments(NSString *directory, NSArray<NSString *> *ignoreDirNames) {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:directory error:nil];
    BOOL isDirectory;
    for (NSString *fileName in files) {
        if ([ignoreDirNames containsObject:fileName]) continue;
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            deleteComments(filePath, ignoreDirNames);
            continue;
        }
        if (![fileName hasSuffix:@".h"] && ![fileName hasSuffix:@".m"] && ![fileName hasSuffix:@".mm"] && ![fileName hasSuffix:@".swift"]) continue;
        NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        regularReplacement(fileContent, @"([^:/])//.*",             @"\\1");
        regularReplacement(fileContent, @"^//.*",                   @"");
        regularReplacement(fileContent, @"/\\*{1,2}[\\s\\S]*?\\*/", @"");
        regularReplacement(fileContent, @"^\\s*\\n",                @"");
        [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - 修改工程名
void resetEntitlementsFileName(NSString *projectPbxprojFilePath, NSString *oldName, NSString *newName) {
    NSString *rootPath = projectPbxprojFilePath.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent;
    NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:projectPbxprojFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *regularExpression = @"CODE_SIGN_ENTITLEMENTS = \"?([^\";]+)";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *entitlementsPath = [fileContent substringWithRange:[obj rangeAtIndex:1]];
        NSString *entitlementsName = entitlementsPath.lastPathComponent.stringByDeletingPathExtension;
        if (![entitlementsName isEqualToString:oldName]) return;
        entitlementsPath = [rootPath stringByAppendingPathComponent:entitlementsPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:entitlementsPath]) return;
        NSString *newPath = [entitlementsPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:[newName stringByAppendingPathExtension:@"entitlements"]];
        renameFile(entitlementsPath, newPath);
    }];
}

void resetBridgingHeaderFileName(NSString *projectPbxprojFilePath, NSString *oldName, NSString *newName) {
    NSString *rootPath = projectPbxprojFilePath.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent;
    NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:projectPbxprojFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *regularExpression = @"SWIFT_OBJC_BRIDGING_HEADER = \"?([^\";]+)";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *entitlementsPath = [fileContent substringWithRange:[obj rangeAtIndex:1]];
        NSString *entitlementsName = entitlementsPath.lastPathComponent.stringByDeletingPathExtension;
        if (![entitlementsName isEqualToString:oldName]) return;
        entitlementsPath = [rootPath stringByAppendingPathComponent:entitlementsPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:entitlementsPath]) return;
        NSString *newPath = [entitlementsPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:[newName stringByAppendingPathExtension:@"h"]];
        renameFile(entitlementsPath, newPath);
    }];
}

void replacePodfileContent(NSString *filePath, NSString *oldString, NSString *newString) {
    NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *regularExpression = [NSString stringWithFormat:@"target +'%@", oldString];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [fileContent replaceCharactersInRange:obj.range withString:[NSString stringWithFormat:@"target '%@", newString]];
        }
    }];
    
    regularExpression = [NSString stringWithFormat:@"project +'%@.", oldString];
    expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:nil];
    matches = [expression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fileContent replaceCharactersInRange:obj.range withString:[NSString stringWithFormat:@"project '%@.", newString]];
    }];
    
    [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

void replaceProjectFileContent(NSString *filePath, NSString *oldString, NSString *newString) {
    NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *regularExpression = [NSString stringWithFormat:@"\\b%@\\b", oldString];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fileContent replaceCharactersInRange:obj.range withString:newString];
    }];
    
    [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

void modifyFilesClassName(NSString *sourceCodeDir, NSString *oldClassName, NSString *newClassName);

void modifyProjectName(NSString *projectDir, NSString *oldName, NSString *newName) {
    NSString *sourceCodeDirPath = [projectDir stringByAppendingPathComponent:oldName];
    NSString *xcodeprojFilePath = [sourceCodeDirPath stringByAppendingPathExtension:@"xcodeproj"];
    NSString *xcworkspaceFilePath = [sourceCodeDirPath stringByAppendingPathExtension:@"xcworkspace"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory;
    
    // old-Swift.h > new-Swift.h
    modifyFilesClassName(projectDir, [oldName stringByAppendingString:@"-Swift.h"], [newName stringByAppendingString:@"-Swift.h"]);
    
    // 改 Podfile 中的工程名
    NSString *podfilePath = [projectDir stringByAppendingPathComponent:@"Podfile"];
    if ([fm fileExistsAtPath:podfilePath isDirectory:&isDirectory] && !isDirectory) {
        replacePodfileContent(podfilePath, oldName, newName);
    }
    
    // 改工程文件内容
    if ([fm fileExistsAtPath:xcodeprojFilePath isDirectory:&isDirectory] && isDirectory) {
        // 替换 project.pbxproj 文件内容
        NSString *projectPbxprojFilePath = [xcodeprojFilePath stringByAppendingPathComponent:@"project.pbxproj"];
        if ([fm fileExistsAtPath:projectPbxprojFilePath]) {
            resetBridgingHeaderFileName(projectPbxprojFilePath, [oldName stringByAppendingString:@"-Bridging-Header"], [newName stringByAppendingString:@"-Bridging-Header"]);
            resetEntitlementsFileName(projectPbxprojFilePath, oldName, newName);
            replaceProjectFileContent(projectPbxprojFilePath, oldName, newName);
        }
        // 替换 project.xcworkspace/contents.xcworkspacedata 文件内容
        NSString *contentsXcworkspacedataFilePath = [xcodeprojFilePath stringByAppendingPathComponent:@"project.xcworkspace/contents.xcworkspacedata"];
        if ([fm fileExistsAtPath:contentsXcworkspacedataFilePath]) {
            replaceProjectFileContent(contentsXcworkspacedataFilePath, oldName, newName);
        }
        // xcuserdata 本地用户文件
        NSString *xcuserdataFilePath = [xcodeprojFilePath stringByAppendingPathComponent:@"xcuserdata"];
        if ([fm fileExistsAtPath:xcuserdataFilePath]) {
            [fm removeItemAtPath:xcuserdataFilePath error:nil];
        }
        // 改名工程文件
        renameFile(xcodeprojFilePath, [[projectDir stringByAppendingPathComponent:newName] stringByAppendingPathExtension:@"xcodeproj"]);
    }
    
    // 改工程组文件内容
    if ([fm fileExistsAtPath:xcworkspaceFilePath isDirectory:&isDirectory] && isDirectory) {
        // 替换 contents.xcworkspacedata 文件内容
        NSString *contentsXcworkspacedataFilePath = [xcworkspaceFilePath stringByAppendingPathComponent:@"contents.xcworkspacedata"];
        if ([fm fileExistsAtPath:contentsXcworkspacedataFilePath]) {
            replaceProjectFileContent(contentsXcworkspacedataFilePath, oldName, newName);
        }
        // xcuserdata 本地用户文件
        NSString *xcuserdataFilePath = [xcworkspaceFilePath stringByAppendingPathComponent:@"xcuserdata"];
        if ([fm fileExistsAtPath:xcuserdataFilePath]) {
            [fm removeItemAtPath:xcuserdataFilePath error:nil];
        }
        // 改名工程文件
        renameFile(xcworkspaceFilePath, [[projectDir stringByAppendingPathComponent:newName] stringByAppendingPathExtension:@"xcworkspace"]);
    }
    
    // 改源代码文件夹名称
    if ([fm fileExistsAtPath:sourceCodeDirPath isDirectory:&isDirectory] && isDirectory) {
        renameFile(sourceCodeDirPath, [projectDir stringByAppendingPathComponent:newName]);
    }
}

#pragma mark - 修改类名前缀
void modifyFilesClassName(NSString *sourceCodeDir, NSString *oldClassName, NSString *newClassName) {
    // 文件内容 Const > DDConst (h,m,swift,xib,storyboard)
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    BOOL isDirectory;
    for (NSString *filePath in files) {
        NSString *path = [sourceCodeDir stringByAppendingPathComponent:filePath];
        // 继续向下搜索
        if ([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            modifyFilesClassName(path, oldClassName, newClassName);
            continue;
        }
        
        NSString *fileName = filePath.lastPathComponent;
        if ([fileName hasSuffix:@".h"] || [fileName hasSuffix:@".m"] || [fileName hasSuffix:@".pch"] || [fileName hasSuffix:@".swift"] || [fileName hasSuffix:@".xib"] || [fileName hasSuffix:@".storyboard"]) {
            
            NSError *error = nil;
            NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSString *obj = [NSString stringWithFormat:@"open file %s fail：%s\n", path.UTF8String, error.localizedDescription.UTF8String];
                NPostNotification(obj);
                abort();
            }
            
            NSString *regularExpression = [NSString stringWithFormat:@"\\b%@\\b", oldClassName];
            BOOL isChanged = regularReplacement(fileContent, regularExpression, newClassName);
            if (!isChanged) continue;
            error = nil;
            [fileContent writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSString *obj = [NSString stringWithFormat:@"save file %s fail：%s\n", path.UTF8String, error.localizedDescription.UTF8String];
                NPostNotification(obj);
                abort();
            }
        }
    }
}

void modifyClassNamePrefix(NSMutableString *projectContent, NSString *sourceCodeDir, NSArray<NSString *> *ignoreDirNames, NSString *oldName, NSString *newName) {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对，swift
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    BOOL isDirectory;
    for (NSString *filePath in files) {
        NSString *path = [sourceCodeDir stringByAppendingPathComponent:filePath];
        if ([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            if (![ignoreDirNames containsObject:filePath]) {
                modifyClassNamePrefix(projectContent, path, ignoreDirNames, oldName, newName);
            }
            continue;
        }
        
        NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;
        NSString *fileExtension = filePath.pathExtension;
        NSString *newClassName;
        if ([fileName hasPrefix:oldName]) {
            newClassName = [newName stringByAppendingString:[fileName substringFromIndex:oldName.length]];
            
            // 文件名 Const.ext > DDConst.ext
            if ([fileExtension isEqualToString:@"h"]) {
                NSString *mFileName = [fileName stringByAppendingPathExtension:@"m"];
                if ([files containsObject:mFileName]) {
                    NSString *oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"h"];
                    NSString *newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"h"];
                    renameFile(oldFilePath, newFilePath);
                    oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"m"];
                    newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"m"];
                    renameFile(oldFilePath, newFilePath);
                    oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"xib"];
                    if ([fm fileExistsAtPath:oldFilePath]) {
                        newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"xib"];
                        renameFile(oldFilePath, newFilePath);
                    }
                    
//                    @autoreleasepool {
//                        modifyFilesClassName(sourceCodeDir, fileName, newClassName);
//                    }
                } else {
                    continue;
                }
            } else if ([fileExtension isEqualToString:@"swift"]) {
                NSString *oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"swift"];
                NSString *newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"swift"];
                renameFile(oldFilePath, newFilePath);
                oldFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"xib"];
                if ([fm fileExistsAtPath:oldFilePath]) {
                    newFilePath = [[sourceCodeDir stringByAppendingPathComponent:newClassName] stringByAppendingPathExtension:@"xib"];
                    renameFile(oldFilePath, newFilePath);
                }
                
//                @autoreleasepool {
//                    modifyFilesClassName(sourceCodeDir, fileName.stringByDeletingPathExtension, newClassName);
//                }
            } else {
                continue;
            }
            
            // 修改工程文件中的文件名
            NSString *regularExpression = [NSString stringWithFormat:@"\\b%@\\b", fileName];
            regularReplacement(projectContent, regularExpression, newClassName);
        }
    }
}

#pragma mark - 替换方法名前缀
void modifyMethodsPrefix(NSString *sourceCodeDir, NSArray<NSString *> *ignoreDirNames,NSString *oldName, NSString *newName, bool isGlobal, NSStringCompareOptions options){
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 遍历源代码文件 h 与 m 配对
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:sourceCodeDir error:nil];
    BOOL isDirectory;
    for (NSString *filePath in files) {
        NSString *path = [sourceCodeDir stringByAppendingPathComponent:filePath];
        if ([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            if ([ignoreDirNames containsObject:filePath]) continue;
            modifyMethodsPrefix(path, ignoreDirNames, oldName, newName, isGlobal, options);
        }
        
        NSString *fileName = filePath.lastPathComponent.stringByDeletingPathExtension;
        NSString *fileExtension = filePath.pathExtension;
        if ([fileExtension isEqualToString:@"h"]) {
            NSString *mFileName = [fileName stringByAppendingPathExtension:@"m"];
            NSString *mmFileName = [fileName stringByAppendingPathExtension:@"mm"];
            if ([files containsObject:mFileName]) {
                NSString *hFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"h"];
                NSString *mFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"m"];
                NSError *error = nil;
                NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:mFilePath encoding:NSUTF8StringEncoding error:&error];
                if ([fileContent containsString:oldName]) {
                    [fileContent replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, fileContent.length)];
                    [fileContent writeToFile:mFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }
                NSMutableString *hfileConten = [NSMutableString stringWithContentsOfFile:hFilePath encoding:NSUTF8StringEncoding error:nil];
                if ([hfileConten containsString:oldName]) {
                    [hfileConten replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, hfileConten.length)];
                    [hfileConten writeToFile:hFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }
            } else if ([files containsObject:mmFileName]) {
                NSString *hFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"h"];
                NSString *mFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"mm"];
                NSError *error = nil;
                NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:mFilePath encoding:NSUTF8StringEncoding error:&error];
                if ([fileContent containsString:oldName]) {
                    [fileContent replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, fileContent.length)];
                    [fileContent writeToFile:mFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }
                NSMutableString *hfileConten = [NSMutableString stringWithContentsOfFile:hFilePath encoding:NSUTF8StringEncoding error:nil];
                if ([hfileConten containsString:oldName]) {
                    [hfileConten replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, hfileConten.length)];
                    [hfileConten writeToFile:hFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }
            } else {
                NSString *hFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"h"];
                NSMutableString *hfileConten = [NSMutableString stringWithContentsOfFile:hFilePath encoding:NSUTF8StringEncoding error:nil];
                if ([hfileConten containsString:oldName]) {
                    [hfileConten replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, hfileConten.length)];
                    [hfileConten writeToFile:hFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }
            }
        } else if ([fileExtension isEqualToString:@"pch"]) {
            NSString *pchFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"pch"];
            NSMutableString *pchfileConten = [NSMutableString stringWithContentsOfFile:pchFilePath encoding:NSUTF8StringEncoding error:nil];
            if ([pchfileConten containsString:oldName]) {
                [pchfileConten replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, pchfileConten.length)];
                [pchfileConten writeToFile:pchFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
        } else if ([fileExtension isEqualToString:@"xib"]) {
            NSString *xibFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"xib"];
            NSMutableString *xibfileConten = [NSMutableString stringWithContentsOfFile:xibFilePath encoding:NSUTF8StringEncoding error:nil];
            if ([xibfileConten containsString:oldName]) {
                [xibfileConten replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, xibfileConten.length)];
                [xibfileConten writeToFile:xibFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
        } else if ([fileExtension isEqualToString:@"storyboard"] && isGlobal) {
            NSString *storyboardFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"storyboard"];
            NSMutableString *storyboardfileConten = [NSMutableString stringWithContentsOfFile:storyboardFilePath encoding:NSUTF8StringEncoding error:nil];
            if ([storyboardfileConten containsString:oldName]) {
                [storyboardfileConten replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, storyboardfileConten.length)];
                [storyboardfileConten writeToFile:storyboardFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
        } else if ([fileExtension isEqualToString:@"xml"] && isGlobal) {
            NSString *xmlFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"xml"];
            NSMutableString *xmlfileConten = [NSMutableString stringWithContentsOfFile:xmlFilePath encoding:NSUTF8StringEncoding error:nil];
            if ([xmlfileConten containsString:oldName]) {
                [xmlfileConten replaceOccurrencesOfString:oldName withString:newName options:options range:NSMakeRange(0, xmlfileConten.length)];
                [xmlfileConten writeToFile:xmlFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
        } else if ([fileExtension isEqualToString:@"imageset"] && isGlobal) {
            NSString *imagesetFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"imageset"];
            NSString *fileNameNew = [fileName stringByReplacingOccurrencesOfString:oldName withString:newName];
            NSString *imagesetNewFilePath = [[sourceCodeDir stringByAppendingPathComponent:fileNameNew] stringByAppendingPathExtension:@"imageset"];
            renameFile(imagesetFilePath, imagesetNewFilePath);
        }
    }
}

@end

