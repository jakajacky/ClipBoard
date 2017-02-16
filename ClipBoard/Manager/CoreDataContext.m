//
//  CoreDataContext.m
//  ClipBoard
//
//  Created by xqzh on 17/2/8.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "CoreDataContext.h"

@implementation CoreDataContext

- (instancetype)init {
  self = [super init];
  if (self) {
    // coreData 搭建环境
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"clipData1.data"]];
    
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
  }
  return self;
}

- (void)reloadContext {
  // coreData 搭建环境
  // 从应用程序包中加载模型文件
  NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
  // 传入模型对象，初始化NSPersistentStoreCoordinator
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
  // 构建SQLite数据库文件的路径
  NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"clipData1.data"]];
  
  // 添加持久化存储库，这里使用SQLite作为存储库
  NSError *error = nil;
  NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
  if (store == nil) { // 直接抛异常
    [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
  }
  // 初始化上下文，设置persistentStoreCoordinator属性
  _context = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
  _context.persistentStoreCoordinator = psc;
}

static CoreDataContext * _instance = nil;

+ (instancetype)DefaultContext {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });
  return _instance;
}

@end
