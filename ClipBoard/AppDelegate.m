//
//  AppDelegate.m
//  ClipBoard
//
//  Created by xqzh on 16/12/30.
//  Copyright © 2016年 xqzh. All rights reserved.
//

#import "AppDelegate.h"
#import "PreViewViewController.h"

@interface AppDelegate ()<NSAnimationDelegate>
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
//  if (!flag) {
    // 主窗口显示
    [NSApp activateIgnoringOtherApps:NO];
    
    for (NSWindow *window in [[NSApplication sharedApplication] windows]) {
      
      if ([NSStringFromClass([window class]) isEqualToString:@"NSWindow"]) {
        [window makeKeyAndOrderFront:self];
//        //获取当前窗口大小
//        NSRect firstFrame = [window frame];
//        //属性字典
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        //设置目标对象
//        [dict setObject:window forKey:NSViewAnimationTargetKey];
//        //设置起始大小
//        [dict setObject:[NSValue valueWithRect:CGRectMake(1065, 607, 0, 0)] forKey:NSViewAnimationStartFrameKey];
//        
//        //设置最终大小
//        [dict setObject:[NSValue valueWithRect:firstFrame] forKey:NSViewAnimationEndFrameKey];
//        //设置动画效果
//        [dict setObject:NSViewAnimationFadeInEffect forKey:NSViewAnimationEffectKey];
//        
//        //设置动画
//        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dict]];
//        [animation setDelegate:self];
//        //启动动画
//        [animation startAnimation];
//        
      }
    }
//  }
//  else {
//    for (NSWindow *window in [[NSApplication sharedApplication] windows]) {
//      if ([NSStringFromClass([window class]) isEqualToString:@"NSWindow"]) {
//        [window orderOut:self];
//      }
//    }
//  }
  return YES;
}

- (void)animationDidEnd:(NSAnimation *)animation {
  
}

// 通过状态栏icon实现显示窗口
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

// 清理缓存数据
- (IBAction)clearContentData:(id)sender {
  
  // 构建SQLite数据库文件的路径
  NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"clipData1.data"]];
  
  /*
   * 在未加清空本地缓存数据功能之前，暂时这样，为了不让测试数据过多
   */
  [[NSFileManager defaultManager] removeItemAtURL:url error:nil]; // 清空coredata数据库
  // 刷新内容
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center postNotificationName:UpdateNotification object:nil];
}

-(void) setUpPopover {
  self.popover = [[NSPopover alloc] init];
  
  PreViewViewController *v = [[PreViewViewController alloc] initWithNibName:@"PreViewViewController" bundle:[NSBundle mainBundle]];
  
  self.popover.contentViewController = v;
  self.popover.behavior = NSPopoverBehaviorApplicationDefined;
}

@end
