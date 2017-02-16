//
//  ClipDataModel+CoreDataProperties.h
//  ClipBoard
//
//  Created by xqzh on 17/2/15.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "ClipDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClipDataModel (CoreDataProperties)

+ (NSFetchRequest<ClipDataModel *> *)fetchRequest;

@property (nullable, nonatomic, strong) NSString *content;
@property (nullable, nonatomic, strong) NSString *date;
@property (nonatomic) int16_t type;

@end

NS_ASSUME_NONNULL_END
