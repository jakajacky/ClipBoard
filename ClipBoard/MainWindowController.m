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
  
  [DRStartAtLogin setStartAtLogin:YES];
  
}

@end
