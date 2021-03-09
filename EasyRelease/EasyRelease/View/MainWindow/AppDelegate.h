//
//  AppDelegate.h
//  easyRelease
//
//  Created by 倪永胜 on 2021/2/4.
//

#import <Cocoa/Cocoa.h>
#import <GitHubUpdates/GitHubUpdates.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSWindowController *mainWC;

@property (nonatomic, strong) GitHubUpdater *updater;

@end

