//
//  NYSProjectImportVC.m
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/19.
//  Copyright © 2021 NYS. All rights reserved.
//

#import "NYSProjectImportVC.h"

#define IconName @"icon_ignore"

@interface NYSProjectImportVC ()
<
NSTableViewDelegate,
NSTableViewDataSource
>

@property (weak) IBOutlet NSTextField *projectFileDirectory;
@property (weak) IBOutlet NSTextField *projectDirectory;

@property (weak) IBOutlet NSPathCell *pfdPathCell;

@property (strong) IBOutlet NSTableView *tableView;

@end

@implementation NYSProjectImportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectFileDirectory.editable = NO;
    self.projectDirectory.editable = NO;
    NConfig.ignoreArray = [NSMutableArray arrayWithArray:@[@{@"name": @"Pods", @"enable": @(true)}]];
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

- (IBAction)openProjectDirectoryButtonClick:(NSButton *)sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:NO];
    [oPanel setCanChooseFiles:YES];
    [oPanel setAllowedFileTypes:@[@"xcodeproj"]];
//    [oPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    if ([oPanel runModal] == NSModalResponseOK) {
        NSURL *url = [[oPanel URLs] objectAtIndex:0];
        NConfig.projectFileDirUrl = url;
        self.projectFileDirectory.stringValue = [url path];
        NSLog(@"项目文件：%@", [url absoluteString]);
    }
}

- (IBAction)openDirectoryButtonClick:(NSButton *)sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES];
    [oPanel setCanChooseFiles:NO];
    if ([oPanel runModal] == NSModalResponseOK) {
        NSURL *url = [[oPanel URLs] objectAtIndex:0];
        NConfig.projectDirUrl = url;
        self.projectDirectory.stringValue = [url path];
        NSLog(@"项目地址：%@", [url absoluteString]);
    }
}

- (IBAction)addItemOnclicked:(NSButton *)sender {
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:YES];
    [oPanel setCanChooseFiles:NO];
    if ([oPanel runModal] == NSModalResponseOK) {
        NSURL *url = [[oPanel URLs] objectAtIndex:0];
        NSString *pathStr = [url path];
        self.pfdPathCell.stringValue = pathStr;
        NSLog(@"忽略该文件夹下的文件：%@", pathStr);
        NSArray *pathArr = [pathStr componentsSeparatedByString:@"/"];
        NSDictionary *dic = @{@"name": [pathArr lastObject], @"enable": @(true)};
        [NConfig.ignoreArray addObject:dic];
        [self.tableView reloadData];
    }
}

- (IBAction)removeItemOnclicked:(NSButton *)sender {
    NSInteger row = self.tableView.selectedRow;
    if (row < 0) {
        [ArtProgressHUD showText:@"No available data"];
        return;
    }
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
    [NConfig.ignoreArray removeObjectAtIndex:row];
}

#pragma mark - NSTableViewDelegate
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    NSLog(@"点击%@ 列.", tableColumn.title);
    NSLog(@"----+---- %d", tableColumn.sortDescriptorPrototype.ascending);
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return NConfig.ignoreArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *rowInfoDic = NConfig.ignoreArray[row];
    NSString *key = tableColumn.identifier;
    
    NSView *contentView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    if ([key isEqualToString:@"Directory"]) {
        NSString *name = rowInfoDic[@"name"];
        NSTextField *textField = [contentView subviews][0];
        textField.stringValue = name;
        NSImageView *iconImageView = [contentView subviews][1];
        iconImageView.image = [NYSUtils changeImage:[NSImage imageNamed:@"icon_ignore"] WithTintColor:[NSColor colorWithRGBInt:ThemeColor]];
    }
    return contentView;
}

- (void)RefreshConfigUINotificationHandler:(NSNotification *)notification {
    self.projectFileDirectory.stringValue = NConfig.projectFileDirUrl.path;
    self.projectDirectory.stringValue = NConfig.projectDirUrl.path;
    
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshConfNotice object:nil];
}

@end
