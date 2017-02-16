//
//  CustomImgContentCellView.h
//  ClipBoard
//
//  Created by xqzh on 17/2/15.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomImgContentCellView : NSTableCellView

@property (weak) IBOutlet NSImageView *contentImg;

@property (weak) IBOutlet NSTextField *contentText;

@end
