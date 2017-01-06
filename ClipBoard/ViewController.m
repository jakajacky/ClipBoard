//
//  ViewController.m
//  ClipBoard
//
//  Created by xqzh on 16/12/30.
//  Copyright © 2016年 xqzh. All rights reserved.
//

#import "ViewController.h"
#import "ClipDataModel+CoreDataClass.h"
#import <CoreData/CoreData.h>
@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *clipListView;
@property (nonatomic, strong) NSMutableArray *clipList;

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _clipList = [NSMutableArray array];
  // coreData 搭建环境
  // 从应用程序包中加载模型文件
  NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
  // 传入模型对象，初始化NSPersistentStoreCoordinator
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
  // 构建SQLite数据库文件的路径
  NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"clipData.data"]];
  // 添加持久化存储库，这里使用SQLite作为存储库
  NSError *error = nil;
  NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
  if (store == nil) { // 直接抛异常
    [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
  }
  // 初始化上下文，设置persistentStoreCoordinator属性
  _context = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
  _context.persistentStoreCoordinator = psc;
  // 用完之后，记得要[context release];
  
  [self reloadData];
  
  NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

// 初始化数据
- (void)reloadData {
  // 查询数据库
  // 初始化一个查询请求
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  // 设置要查询的实体
  request.entity = [NSEntityDescription entityForName:@"ClipDataModel" inManagedObjectContext:_context];
  // 设置排序（按照age降序）
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
  request.sortDescriptors = [NSArray arrayWithObject:sort];
  // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
  //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Itcast-1*"];
  //    request.predicate = predicate;
  // 执行请求
  NSError *error = nil;
  NSArray *objs = [_context executeFetchRequest:request error:&error];
  if (error) {
    [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
  }
  // 遍历数据
  for (ClipDataModel *obj in objs) {
    NSLog(@"content=%@", obj.content);
    [_clipList addObject: obj];
  }

}

- (void)run {
  // 获取剪切板
  NSPasteboard *board = [NSPasteboard generalPasteboard];
  
  // 记录日期
  NSDate *date = [NSDate date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *dateStr = [formatter stringFromDate:date];
  
  // 加入数据列表
  for (ClipDataModel *model in _clipList) {
    if ([model.content isEqualToString:[board stringForType:NSPasteboardTypeString]]) {
      return;
    }
  }
  
  // 构建数据模型
  ClipDataModel *clipContent = [NSEntityDescription insertNewObjectForEntityForName:@"ClipDataModel" inManagedObjectContext:_context];
  clipContent.content = [board stringForType:NSPasteboardTypeString];
  clipContent.date    = dateStr;
  
  // 插入数组
  [_clipList insertObject:clipContent atIndex:0];
  
  // 保存到数据库
  NSError *error = nil;
  BOOL success = [_context save:&error];
  if (!success) {
    [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
  }
  
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
