//
//  CoreDataContext.h
//  ClipBoard
//
//  Created by xqzh on 17/2/8.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataContext : NSObject
@property (nonatomic, strong) NSManagedObjectContext *context;
+ (instancetype)DefaultContext;
- (void)reloadContext;
@end
