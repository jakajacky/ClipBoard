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
#import "CustomCellView.h"
#import "CustomImgContentCellView.h"
#import "CoreDataContext.h"

typedef enum : NSUInteger {
  ContentTypeString,
  ContentTypeFile,
} ContentType;

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *clipListView;

@property (nonatomic, strong) NSMutableArray *clipList;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, assign) BOOL ascending;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)awakeFromNib {
  [self.clipListView registerNib:[[NSNib alloc] initWithNibNamed:@"CustomCellView" bundle:nil] forIdentifier:@"customCell"];
  [self.clipListView registerNib:[[NSNib alloc] initWithNibNamed:@"CustomImgContentCellView" bundle:nil] forIdentifier:@"clipContent"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // 刷新内容
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:self selector:@selector(updateData) name:UpdateNotification object:nil];
  
  _clipList = [NSMutableArray array];
//  // coreData 搭建环境
//  // 从应用程序包中加载模型文件
//  NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
//  // 传入模型对象，初始化NSPersistentStoreCoordinator
//  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//  // 构建SQLite数据库文件的路径
//  NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//  NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"clipData.data"]];
//  
//  /*
//   * 在未加清空本地缓存数据功能之前，暂时这样，为了不让测试数据过多
//   */
//  [[NSFileManager defaultManager] removeItemAtURL:url error:nil]; // 清空coredata数据库
//  
//  // 添加持久化存储库，这里使用SQLite作为存储库
//  NSError *error = nil;
//  NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
//  if (store == nil) { // 直接抛异常
//    [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
//  }
//  // 初始化上下文，设置persistentStoreCoordinator属性
//  _context = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
//  _context.persistentStoreCoordinator = psc;
//  // 用完之后，记得要[context release];
  _context = [CoreDataContext DefaultContext].context;
  
  [self reloadData];
  
  _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
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
  else {
    // 遍历数据
    for (ClipDataModel *obj in objs) {
  //    NSLog(@"content=%@", obj.content);
      [_clipList addObject: obj];
    }
    
    // 刷新界面列表
    [self.clipListView reloadData];
  }
}

- (void)run {
  
//  NSLog(@"美妙跑一次");
  // 获取剪切板
  NSPasteboard *board = [NSPasteboard generalPasteboard];
  
  // 记录日期
  NSDate *date = [NSDate date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *dateStr = [formatter stringFromDate:date];
  
  // 尝试获取file类型内容
  NSArray *urls = [[board readObjectsForClasses:@[[NSURL class]] options:@{NSPasteboardURLReadingFileURLsOnlyKey: @(YES)}] valueForKey:@"path"];
  
  // 加入数据列表
  for (ClipDataModel *model in _clipList) {
//    NSLog(@"%@", [board stringForType:NSPasteboardTypeString]);
    
    if (!urls.firstObject) {
      if ([model.content isEqualToString:[board stringForType:NSPasteboardTypeString]] || [board stringForType:NSPasteboardTypeString] == nil) {
        return;
      }
      if ([board stringForType:NSPasteboardTypeString] == nil) {
        return;
      }
    }
    else {
      if ([model.content isEqualToString:urls.firstObject]) {
        return;
      }
    }
  }
  
  
  
  // 构建数据模型
  ClipDataModel *clipContent = [NSEntityDescription insertNewObjectForEntityForName:@"ClipDataModel" inManagedObjectContext:_context];
  clipContent.content = urls.firstObject? urls.firstObject : [board stringForType:NSPasteboardTypeString];
  clipContent.date    = dateStr;
  clipContent.type    = urls.firstObject? ContentTypeFile : ContentTypeString;
  
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
  
  /*
   * 下面是剪切板有新数据，显示到列表的处理逻辑
   */
  // 有新数据插入，默认选中第一行
  NSTableRowView *ro = [self.clipListView rowViewAtRow:0 makeIfNecessary:YES];
  ro.selected = YES;
  
  // 显示选中row的操作栏
  CustomCellView *newRowCell = (CustomCellView *)[self.clipListView viewAtColumn:2 row:0 makeIfNecessary:YES];
  newRowCell.deleteButton.hidden = NO;
  
  // 取消旧的选中row
  for (int i = 1 ; i < self.clipList.count; i++) {
    CustomCellView *newRowCell = (CustomCellView *)[self.clipListView viewAtColumn:2 row:i makeIfNecessary:YES];
    newRowCell.deleteButton.hidden = YES;
  }
  
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];

  // Update the view, if already loaded.
}

// 按时间排序
- (IBAction)orderByDate:(id)sender {
  NSButton *btn = sender;
  if (btn.state == 1) {
    _ascending = NO;
    // 升序
    [self.clipList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      ClipDataModel *m1 = obj1;
      ClipDataModel *m2 = obj2;
      if (m1.date > m2.date) {
        return YES;
      }
      return NO;
    }];
  }
  else {
    _ascending = YES;
    // 降序
    [self.clipList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      ClipDataModel *m1 = obj1;
      ClipDataModel *m2 = obj2;
      if (m1.date < m2.date) {
        return YES;
      }
      return NO;
    }];
  }
  
  [self.clipListView reloadData];
  
}


#pragma mark - 事件源
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return self.clipList.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
  
  ClipDataModel *model = self.clipList[row];
  if( [tableColumn.identifier isEqualToString:@"clipContent"] )
  {
    CustomImgContentCellView *cell = (CustomImgContentCellView *)cellView;
    
    if (model.type == ContentTypeString) {
      cell.contentText.stringValue = model.content?model.content:@"N/A";
      cell.contentImg.hidden = YES;
      cell.contentText.hidden = NO;
      [cellView setToolTip:model.content?model.content:@"N/A"];
      
    }
    else {
      
//      NSString *yourImageName = @"111.png"; // Replace with actual image name
//      NSString *docDirPath    = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) lastObject];
//      NSString *pathForImage  = [@"/User" stringByAppendingPathComponent:yourImageName];
//      NSData *data = [NSData dataWithContentsOfFile:model.content];
      
      NSLog(@"+++++%@+++++%@", [NSString stringWithFormat:@"%@", model.content], [[NSImage alloc] initWithContentsOfFile:model.content]);
      NSImage *img = [[NSImage alloc] initWithContentsOfFile:model.content];
      [img setName:nil];
//      NSData *d = [im TIFFRepresentation];
//      NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:d];
//      [imageRep setSize:im.size];
//      
//      NSData *imgData = [imageRep representationUsingType:NSPNGFileType properties:nil];
//      NSImage *img = [[NSImage alloc] initWithData:imgData];
      img.cacheMode = NSImageCacheNever;
      [img recache];
      cell.contentImg.image = img;
      cell.contentText.hidden = YES;
      cell.contentImg.hidden = NO;
      [cellView setToolTip:model.content?model.content:@"N/A"];
    }
    return cell;
  }
  else if( [tableColumn.identifier isEqualToString:@"operation"] ){
    cellView.textField.stringValue = model.date?model.date:@"N/A";
    return cellView;
  }
  else {
    CustomCellView *cell = (CustomCellView *)cellView;
    cell.deleteButton.tag = row;
    [cell.deleteButton setTarget:self];
    [cell.deleteButton setAction:@selector(deleteButtonClicked:)];
    return cell;
  }
}

// 点击获取更新剪切板内容
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
  
  [self.clipListView reloadData];
  
  // 获取数据
  ClipDataModel *model = self.clipList[row];
  
  // 获取剪切板
  NSPasteboard *board = [NSPasteboard generalPasteboard];
  
  // 更新剪切板
  [board clearContents];
  [board setString:model.content forType:NSPasteboardTypeString];
  
  // 取消旧的选中row
  if (self.clipListView.selectedRow >= 0) {
    CustomCellView *oldRowCell = (CustomCellView *)[self.clipListView viewAtColumn:2 row:self.clipListView.selectedRow makeIfNecessary:YES];
    oldRowCell.deleteButton.hidden = YES;
  }
  else {
    CustomCellView *oldRowCell = (CustomCellView *)[self.clipListView viewAtColumn:2 row:self.clipListView.selectedRow+1 makeIfNecessary:YES];
    oldRowCell.deleteButton.hidden = YES;
  }
  
  // 显示选中row的操作栏
  CustomCellView *newRowCell = (CustomCellView *)[self.clipListView viewAtColumn:2 row:row makeIfNecessary:YES];
  newRowCell.deleteButton.hidden = NO;
  
  return YES;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
  return 35;
}
#pragma mark - 事件
// 删除一条信息
- (void)deleteButtonClicked:(NSButton *)sender {
  NSLog(@"删除第%ld行", sender.tag);
  
  // 清空剪切板
  NSPasteboard *board = [NSPasteboard generalPasteboard];
  [board clearContents];
  
  CustomCellView *oldRowCell = (CustomCellView *)[self.clipListView viewAtColumn:2 row:sender.tag makeIfNecessary:YES];
  oldRowCell.deleteButton.hidden = YES;
  
  ClipDataModel *model = self.clipList[sender.tag];
  [_context deleteObject:model];
  
  NSError *error = nil;
  [_context save:&error];
  if (error) {
    [NSException raise:@"删除数据出错" format:@"%@", [error localizedDescription]];
  }
  
  [self.clipList removeObjectAtIndex:sender.tag];
  [self.clipListView reloadData];
  
  if (self.clipList.count > 0) {
    // 获取数据
    ClipDataModel *model0 = self.clipList[0];
    
    // 获取剪切板
    NSPasteboard *board = [NSPasteboard generalPasteboard];
    
    // 更新剪切板
    [board clearContents];
    [board setString:model0.content forType:NSPasteboardTypeString];
    
    /*
     * 下面是剪切板删除数据，显示到列表的处理逻辑
     */
    // 有数据删除，默认选中第一行
    NSTableRowView *ro = [self.clipListView rowViewAtRow:0 makeIfNecessary:YES];
    ro.selected = YES;
    
    // 显示选中row的操作栏
    CustomCellView *newRowCell = (CustomCellView *)[self.clipListView viewAtColumn:2 row:0 makeIfNecessary:YES];
    newRowCell.deleteButton.hidden = NO;
    
    // 取消旧的选中row
    for (int i = 1 ; i < self.clipList.count; i++) {
      CustomCellView *newRowCell = (CustomCellView *)[self.clipListView viewAtColumn:2 row:i makeIfNecessary:YES];
      newRowCell.deleteButton.hidden = YES;
    }
  }
}

// 收到通知，清空数据
- (void)updateData {
  // 注意：清空玩clipModel.Data文件之后，要将context也重建，才会立即清空；否则，原来数据不会立即清空，而是重启APP后才生效
  CoreDataContext *cd = [CoreDataContext DefaultContext];
  [cd reloadContext];
  _context = [CoreDataContext DefaultContext].context;
  
  _clipList = [NSMutableArray array];
  [self reloadData];
}

- (NSImage *)getImage:(NSString *)path {
  NSArray *imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:path];
  NSInteger width = 0;
  NSInteger height = 0;
  for (NSImageRep * imageRep in imageReps) {
    if ([imageRep pixelsWide] > width) width = [imageRep pixelsWide];
    if ([imageRep pixelsHigh] > height) height = [imageRep pixelsHigh];
  }
  NSImage *imageNSImage = [[NSImage alloc] initWithSize:NSMakeSize((CGFloat)width, (CGFloat)height)];
  [imageNSImage addRepresentations:imageReps];
  return imageNSImage;
}

@end
