//
//  NYSContentVC.m
//  EasyRelease
//
//  Created by NYS on 21/02/05.
//  Copyright © 2021年 ER. All rights reserved.
//

#import "NYSContentVC.h"

#import "NYSProjectImportVC.h"
#import "NYSModificationVC.h"
#import "NYSMixConfigVC.h"
#import "NYSActionVC.h"

#define MARGIN_SPACE 16

@interface NYSContentVC ()

@property (nonatomic, strong) NSViewController *currentVC;

@property (nonatomic, strong) NYSProjectImportVC *projectImportVC;
@property (nonatomic, strong) NYSModificationVC *modification;
@property (nonatomic, strong) NYSMixConfigVC *mixConfigVC;
@property (nonatomic, strong) NYSActionVC *actionVC;
@end

@implementation NYSContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNavigationTargetNotificationHandler:) name:ChangeNavNotice object:nil];
    
    _projectImportVC = [[NYSProjectImportVC alloc] initWithFrame:NSMakeRect(MARGIN_SPACE/2, MARGIN_SPACE/2, self.view.frame.size.width - MARGIN_SPACE, self.view.frame.size.height - MARGIN_SPACE)];
    [self addChildViewController:_projectImportVC];
    [self.view addSubview:_projectImportVC.view];
    self.currentVC = _projectImportVC;
    
    _modification = [[NYSModificationVC alloc] initWithFrame:NSMakeRect(MARGIN_SPACE/2, MARGIN_SPACE/2, self.view.frame.size.width - MARGIN_SPACE, self.view.frame.size.height - MARGIN_SPACE)];
    [self addChildViewController:_modification];
    
    _mixConfigVC = [[NYSMixConfigVC alloc] initWithFrame:NSMakeRect(MARGIN_SPACE/2, MARGIN_SPACE/2, self.view.frame.size.width - MARGIN_SPACE, self.view.frame.size.height - MARGIN_SPACE)];
    [self addChildViewController:_mixConfigVC];
    
    _actionVC = [[NYSActionVC alloc] initWithFrame:NSMakeRect(MARGIN_SPACE/2, MARGIN_SPACE/2, self.view.frame.size.width - MARGIN_SPACE, self.view.frame.size.height - MARGIN_SPACE)];
    [self addChildViewController:_actionVC];
}

- (void)ChangeNavigationTargetNotificationHandler:(NSNotification*)notification {
    NSNumber *indexNumber = (NSNumber *)notification.userInfo[@"target"];
    NSLog(@"on clicked page %ld", indexNumber.integerValue);
    
    switch (indexNumber.intValue) {
        case 0:
            [self replaceController:_projectImportVC];
            break;
            
        case 1:
            [self replaceController:_modification];
            break;
            
        case 2:
            [self replaceController:_mixConfigVC];
            break;
            
        case 3:
            [self replaceController:_actionVC];
            break;
            
        default:
            break;
    }
}

- (void)replaceController:(NSViewController *)newController {
    [self transitionFromViewController:self.currentVC toViewController:newController options:NSViewControllerTransitionSlideDown completionHandler:nil];
    self.currentVC = newController;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ChangeNavNotice object:nil];
}

@end
