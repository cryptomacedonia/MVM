//
//  WWCellCustom1.h
//  playTableView
//
//  Created by Igor Jovcevski on 12/23/15.
//  Copyright © 2015 WoowaveTemplate. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WWCellCustom1 : NSTableCellView
@property (weak) IBOutlet NSImageView *image;
@property (weak) IBOutlet NSTextField *mainTextField;
@property (weak) IBOutlet NSTextField *detailTextField;
@property BOOL isSelected;
@property  (weak) IBOutlet NSImageView * backGroundImage;


@end
