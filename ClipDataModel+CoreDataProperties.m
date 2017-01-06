//
//  ClipDataModel+CoreDataProperties.m
//  ClipBoard
//
//  Created by xqzh on 17/1/6.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "ClipDataModel+CoreDataProperties.h"

@implementation ClipDataModel (CoreDataProperties)

+ (NSFetchRequest<ClipDataModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ClipDataModel"];
}

@dynamic content;
@dynamic date;

@end
