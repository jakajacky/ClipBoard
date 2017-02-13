//
//  AppDelegate.m
//  Helper
//
//  Created by xqzh on 17/2/13.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  [self runMainApp:@"com.zxq.ClipBoard1" appName:@"ClipBoard"];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

/** 运行开机自启动的app
 
 @param identifier 主app的标识符
 @param appName 主app的名称（在MacOS文件夹下的名称）
 */
- (void) runMainApp:(NSString*)identifier appName:(NSString*)appName
{
  // Check if main app is already running; if yes, do nothing and terminate helper app
  BOOL alreadyRunning = NO;
  NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
  for (NSRunningApplication *app in running)
  {
    if ([[app bundleIdentifier] isEqualToString:identifier])
    {
      alreadyRunning = YES;
    }
  }
  if (!alreadyRunning)
  {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSArray *p = [path pathComponents];
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:p];
    [pathComponents removeLastObject];
    [pathComponents removeLastObject];
    [pathComponents removeLastObject];
    [pathComponents addObject:@"MacOS"];
    [pathComponents addObject:appName];
    NSString *newPath = [NSString pathWithComponents:pathComponents];
    [[NSWorkspace sharedWorkspace] launchApplication:newPath];
  }
  [NSApp terminate:nil];
}


@end
