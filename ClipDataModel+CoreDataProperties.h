//
//  ClipDataModel+CoreDataProperties.h
//  ClipBoard
//
//  Created by xqzh on 17/1/6.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "ClipDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClipDataModel (CoreDataProperties)

+ (NSFetchRequest<ClipDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *date;

@end

NS_ASSUME_NONNULL_END
