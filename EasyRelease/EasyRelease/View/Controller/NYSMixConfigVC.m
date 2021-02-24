//
//  NYSMixConfigVC.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/19.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSMixConfigVC.h"

@interface NYSMixConfigVC ()
<
NSTableViewDelegate,
NSTableViewDataSource
>

@property (nonatomic, assign) NSInteger clickedRow;
@property (strong) IBOutlet NSTableView *tableView;

@property (weak) IBOutlet NSTextField *prefixOldTextField;
@property (weak) IBOutlet NSTextField *prefixNewTextField;
@property (weak) IBOutlet NSComboBox *typeBox;

@end

@implementation NYSMixConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NConfig.mixArray = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = NO;
    
    NSTableColumn *column = self.tableView.tableColumns[0];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:column.identifier ascending:YES];
    column.sortDescriptorPrototype = descriptor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshConfigUINotificationHandler:) name:RefreshConfNotice object:nil];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil]) {
        self.view.wantsLayer = YES;
        [self.view setFrame:frameRect];
        [self.view.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    }
    return self;
}

- (IBAction)addRow:(NSButton *)sender {
    if (_prefixOldTextField.stringValue.length <= 0) {
        [NYSUtils showAlertPanel:@"please input old prefix" forWindow:self.view.window completionHandler:nil];
        return;
    }
    if (_prefixNewTextField.stringValue.length <= 0) {
        [NYSUtils showAlertPanel:@"please input new prefix" forWindow:self.view.window completionHandler:nil];
        return;
    }
    if (_typeBox.stringValue.length <= 0) {
        [NYSUtils showAlertPanel:@"please select type" forWindow:self.view.window completionHandler:nil];
        return;
    }
    
    NSDictionary *dic = @{@"OldPrefix": _prefixOldTextField.stringValue,
                          @"NewPrefix": _prefixNewTextField.stringValue,
                          @"Type": _typeBox.stringValue,
                          @"Enable": @"1"};
    [NConfig.mixArray addObject:dic];
    [self.tableView reloadData];
    if (NConfig.mixArray.count > 0) {
        [self.tableView editColumn:0 row:NConfig.mixArray.count - 1 withEvent:nil select:YES];
    }
}

- (IBAction)removeRow:(NSButton *)sender {
    NSInteger row = self.tableView.selectedRow;
    if (row < 0) {
        [ArtProgressHUD showText:@"No available data"];
        return;
    }
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
    [NConfig.mixArray removeObjectAtIndex:row];
}

#pragma mark - NSTableViewDelegate
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    NSLog(@"点击%@ 列.", tableColumn.title);
    NSLog(@"----+---- %d", tableColumn.sortDescriptorPrototype.ascending);
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return NConfig.mixArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *rowInfoDic = NConfig.mixArray[row];
    NSString *key = tableColumn.identifier;
    NSString *value = rowInfoDic[key];
    
    NSView *contentView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if ([key isEqualToString:@"NewPrefix"]) {
        NSTextField *textField = [contentView subviews][0];
        textField.stringValue = value;
    } else if ([key isEqualToString:@"OldPrefix"]) {
        NSTextField *textField = [contentView subviews][0];
        textField.stringValue = value;
    } else if ([key isEqualToString:@"Type"]) {
        NSComboBox *comboBox = [contentView subviews][0];
        comboBox.stringValue = value;
    } else {
        NSButton *checkBoxButton = [contentView subviews][0];
        checkBoxButton.state = [value boolValue];
    }
    
    return contentView;
}

- (void)RefreshConfigUINotificationHandler:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshConfNotice object:nil];
}

@end
