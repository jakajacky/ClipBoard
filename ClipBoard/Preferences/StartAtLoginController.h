//
//  SystemViewController.m
//  ClipBoard
//
//  Created by xqzh on 17/2/13.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartAtLoginController : NSObject {
    NSString *_identifier;
    NSURL    *_url;
    BOOL _enabled;
}

@property (assign, nonatomic, readwrite)   BOOL startAtLogin;
@property (assign, nonatomic, readwrite)   BOOL enabled;
@property (copy, nonatomic, readwrite)     NSString *identifier;

-(id)initWithIdentifier:(NSString*)identifier;

@end
