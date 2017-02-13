//
//  PreferencesWindowController.m
//  ClipBoard
//
//  Created by xqzh on 17/2/13.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "SystemViewController.h"

@interface PreferencesWindowController ()<NSToolbarDelegate>

@property (weak) IBOutlet NSToolbar *toolBar;


@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
  [self.toolBar setSelectedItemIdentifier:@"system"]; // 默认处于选中状态
}

- (IBAction)systemToolbarItemClicked:(id)sender {
  NSToolbarItem *item =  sender;
  NSInteger tag = item.tag;
  //根据每个ToolbarItem的tag做流程处理
  NSStoryboard *story = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  SystemViewController *s = [story instantiateControllerWithIdentifier:@"system"];
  self.window.contentViewController = s;
}

- (IBAction)folderToolbarItemClicked:(id)sender {
  NSToolbarItem *item =  sender;
  NSInteger tag = item.tag;
  //根据每个ToolbarItem的tag做流程处理
  NSStoryboard *story = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  NSViewController *s = [story instantiateControllerWithIdentifier:@"folderr"];
  self.window.contentViewController = s;
}

@end
