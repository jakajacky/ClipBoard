//
//  AppDelegate.m
//  ClipBoard
//
//  Created by xqzh on 16/12/30.
//  Copyright © 2016年 xqzh. All rights reserved.
//

#import "AppDelegate.h"
#import "PreViewViewController.h"
@interface AppDelegate ()
@property (strong,nonatomic) NSStatusItem *item;
@property (strong) NSPopover *popover;
@property(nonatomic)BOOL  isShow;
@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // 获取系统单利NSStatusBar对象
  NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
  // 创建固定宽度的NSStatusItem
  NSStatusItem *item = [statusBar statusItemWithLength:NSSquareStatusItemLength];
  [item.button setTarget:self];
  [item.button setAction:@selector(itemAction:)];
  item.button.image = [NSImage imageNamed:@"Icon"];
  
  self.item = item;
  
  [self setUpPopover];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
  [statusBar removeStatusItem:self.item];
}

// 关闭窗口后，点击dock中图标，重新打开窗口实现方式：
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
  if (!flag) {
    // 主窗口显示
    [NSApp activateIgnoringOtherApps:NO];
    for (NSWindow *window in [[NSApplication sharedApplication] windows]) {
      [window makeKeyAndOrderFront:self];
    }
    
  }
  return YES;
}

- (IBAction)itemAction:(id)sender {
  // 主窗口显示
  [NSApp activateIgnoringOtherApps:NO];
  for (NSWindow *window in [[NSApplication sharedApplication] windows]) {
    [window makeKeyAndOrderFront:self];
  }
  //激活应用到前台(如果应用窗口处于非活动状态)
  [[NSRunningApplication currentApplication] activateWithOptions:(NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps)];

//  if (!self.isShow) {
//    [self.popover showRelativeToRect:NSZeroRect ofView:[self item].button preferredEdge:NSRectEdgeMinY];
//  } else {
//    [self.popover close];
//  }
//  self.isShow = !self.isShow;
  
}

-(void) setUpPopover {
  self.popover = [[NSPopover alloc] init];
  
  PreViewViewController *v = [[PreViewViewController alloc] initWithNibName:@"PreViewViewController" bundle:[NSBundle mainBundle]];
  
  self.popover.contentViewController = v;
  self.popover.behavior = NSPopoverBehaviorApplicationDefined;
}

@end
