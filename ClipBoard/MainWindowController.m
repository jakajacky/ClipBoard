//
//  MainWindow.m
//  ClipBoard
//
//  Created by xqzh on 17/1/3.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "MainWindowController.h"
#import "DRStartAtLogin.h"
@interface MainWindowController ()



@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setLevel:NSStatusWindowLevel];
  
    // 设置为开机启动项
    // 从配置表中读取APP设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL startWhenLogin = [defaults boolForKey:@"startWhenLogin"];
    [DRStartAtLogin setStartAtLogin:startWhenLogin];
  
}

@end
