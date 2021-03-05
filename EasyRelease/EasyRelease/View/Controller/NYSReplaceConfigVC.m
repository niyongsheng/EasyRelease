//
//  NYSReplaceConfigVC.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/19.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSReplaceConfigVC.h"

@interface NYSReplaceConfigVC ()
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

@implementation NYSReplaceConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NConfig.replaceArray = [NSMutableArray array];
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
                          @"Enable": @(true)};
    [NConfig.replaceArray addObject:dic];
    [self.tableView reloadData];
    if (NConfig.replaceArray.count > 0) {
        [self.tableView editColumn:0 row:NConfig.replaceArray.count - 1 withEvent:nil select:YES];
    }
}

- (IBAction)removeRow:(NSButton *)sender {
    NSInteger row = self.tableView.selectedRow;
    if (row < 0) {
        [ArtProgressHUD showText:@"No available data"];
        return;
    }
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
    [NConfig.replaceArray removeObjectAtIndex:row];
}

#pragma mark - NSTableViewDelegate
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    NSLog(@"点击%@ 列.", tableColumn.title);
    NSLog(@"----+---- %d", tableColumn.sortDescriptorPrototype.ascending);
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return NConfig.replaceArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *rowInfoDic = NConfig.replaceArray[row];
    NSString *key = tableColumn.identifier;
    id value = rowInfoDic[key];
    
    NSView *contentView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if ([key isEqualToString:@"NewPrefix"]) {
        NSTextField *textField = [contentView subviews][0];
        textField.stringValue = (NSString *)value;
    } else if ([key isEqualToString:@"OldPrefix"]) {
        NSTextField *textField = [contentView subviews][0];
        textField.stringValue = (NSString *)value;
    } else if ([key isEqualToString:@"Type"]) {
        NSComboBox *comboBox = [contentView subviews][0];
        comboBox.stringValue = (NSString *)value;
        
        [comboBox setTag:row];
        [comboBox setAction:@selector(comboBoxChanged:)];
    } else {
        NSButton *checkBoxButton = [contentView subviews][0];
        [checkBoxButton setState:[(NSString *)value integerValue]];
        
        [checkBoxButton setTag:row];
        [checkBoxButton setAction:@selector(checkButtonClick:)];
    }
    
    return contentView;
}

- (void)checkButtonClick:(NSButton *)sender {
    NSDictionary *rowInfoDic = NConfig.replaceArray[sender.tag];
    NSMutableDictionary *mutableReplaceDict = [NSMutableDictionary dictionaryWithDictionary:rowInfoDic];
    NSString *newValue = sender.state ? @"1" : @"0";
    [mutableReplaceDict setValue:newValue forKey:@"Enable"];
    NConfig.replaceArray[sender.tag] = mutableReplaceDict;
    [ArtProgressHUD showInfoText:@"updated"];
}

- (void)comboBoxChanged:(NSComboBox *)sender {
    NSDictionary *rowInfoDic = NConfig.replaceArray[sender.tag];
    NSMutableDictionary *mutableReplaceDict = [NSMutableDictionary dictionaryWithDictionary:rowInfoDic];
    NSString *newValue = sender.stringValue;
    [mutableReplaceDict setValue:newValue forKey:@"Type"];
    NConfig.replaceArray[sender.tag] = mutableReplaceDict;
    [ArtProgressHUD showInfoText:@"updated"];
}

- (void)RefreshConfigUINotificationHandler:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshConfNotice object:nil];
}

@end
