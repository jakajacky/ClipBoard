//
//  ViewController.m
//  ClipBoard
//
//  Created by xqzh on 16/12/30.
//  Copyright © 2016年 xqzh. All rights reserved.
//

#import "ViewController.h"
#import "ClipDataModel.h"
@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *clipListView;
@property (nonatomic, strong) NSMutableArray *clipList;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _clipList = [NSMutableArray array];
  NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


- (void)run {
  // 获取剪切板
  NSPasteboard *board = [NSPasteboard generalPasteboard];
  
  // 记录日期
  NSDate *date = [NSDate date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *dateStr = [formatter stringFromDate:date];
  
  // 构建数据模型
  ClipDataModel *clipContent =
  [[ClipDataModel alloc] initClipDataModelWithDictionary:
  @{@"content":[board stringForType:NSPasteboardTypeString],
    @"date":dateStr}];
  
  // 加入数据列表
  for (ClipDataModel *model in _clipList) {
    if ([model.content isEqualToString:[board stringForType:NSPasteboardTypeString]]) {
      return;
    }
  }
  [_clipList addObject:clipContent];
  
  // 刷新界面列表
  [self.clipListView reloadData];
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];

  // Update the view, if already loaded.
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return self.clipList.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];

  ClipDataModel *model = self.clipList[row];
  if( [tableColumn.identifier isEqualToString:@"clipContent"] )
  {
    cellView.textField.stringValue = model.content;
    return cellView;
  }
  else {
    cellView.textField.stringValue = model.date;
    return cellView;
  }
}


@end
