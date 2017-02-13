//
//  DRStartAtLogin.m
//  ClipBoard
//
//  Created by xqzh on 17/2/13.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "DRStartAtLogin.h"
#import "StartAtLoginController.h"

@implementation DRStartAtLogin


+ (BOOL) isStartAtLogin
{
  StartAtLoginController* loginController = [[StartAtLoginController alloc] initWithIdentifier:@"com.zxq.Helper"];
  BOOL startedAtLogin = [loginController startAtLogin];
  
  return startedAtLogin;
}

+ (BOOL) setStartAtLogin:(BOOL)isStartLogin
{
  StartAtLoginController* loginController = [[StartAtLoginController alloc] initWithIdentifier:@"com.zxq.Helper"];
  loginController.startAtLogin = isStartLogin;
  BOOL result = loginController.enabled;
  
  return result;
}

@end
