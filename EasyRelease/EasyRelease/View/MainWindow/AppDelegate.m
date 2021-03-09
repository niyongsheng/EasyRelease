//
//  AppDelegate.m
//  easyRelease
//
//  Created by 倪永胜 on 2021/2/4.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@interface AppDelegate ()

@property (nonatomic, strong) MainWindowController *mainWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
