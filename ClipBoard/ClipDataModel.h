//
//  ClipDataModel.h
//  ClipBoard
//
//  Created by xqzh on 17/1/5.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClipDataModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *date;

- (instancetype)initClipDataModelWithDictionary:(NSDictionary *)dictionary;
@end
