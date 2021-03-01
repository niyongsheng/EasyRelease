//
//  AppDelegate.m
//  easyRelease
//
//  Created by 倪永胜 on 2021/2/4.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import <GitHubUpdates/GitHubUpdates.h>

@interface AppDelegate ()

@property (nonatomic, strong) MainWindowController *mainWindowController;

@property (nonatomic, strong) GitHubUpdater *updater;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.mainWindowController = [[MainWindowController alloc] init];
    [[_mainWindowController window] center];
    [_mainWindowController showWindow:self];
    self.mainWC = _mainWindowController;
    
    self.updater = [GitHubUpdater new];
    self.updater.user = @"niyongsheng";
    self.updater.repository = @"EasyRelease";
    [self.updater checkForUpdatesInBackground];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
