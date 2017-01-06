//
//  ClipDataModel.m
//  ClipBoard
//
//  Created by xqzh on 17/1/5.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "ClipDataModel.h"

@implementation ClipDataModel

- (instancetype)initClipDataModelWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    _content = dictionary[@"content"];
    _date = dictionary[@"date"];
  }
  return self;
}

@end
