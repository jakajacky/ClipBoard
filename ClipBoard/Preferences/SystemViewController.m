//
//  SystemViewController.m
//  ClipBoard
//
//  Created by xqzh on 17/2/13.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "SystemViewController.h"
#import "DRStartAtLogin.h"
@interface SystemViewController ()

@property (weak) IBOutlet NSButton *checkBtn;

@end

@implementation SystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // 从配置表中读取APP设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL startWhenLogin = [defaults boolForKey:@"startWhenLogin"];
  
    [self.checkBtn setState:startWhenLogin];
}

- (IBAction)openStartWithLogin:(id)sender {
  NSButton *check = sender;
  if (check.state == 0) {
    [DRStartAtLogin setStartAtLogin:NO];
    // 向配置表中设置APP启动项开关
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"startWhenLogin"];
    [defaults synchronize];
  }
  else {
    [DRStartAtLogin setStartAtLogin:YES];
    // 向配置表中设置APP启动项开关
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"startWhenLogin"];
    [defaults synchronize];
  }
  
}


@end
