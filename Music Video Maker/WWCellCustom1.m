//
//  WWCellCustom1.m
//  playTableView
//
//  Created by Igor Jovcevski on 12/23/15.
//  Copyright © 2015 WoowaveTemplate. All rights reserved.
//

#import "WWCellCustom1.h"
#import "customTableRowView.h"
@implementation WWCellCustom1 {
@private
    NSColor *lineColor;
    NSInteger clickCount;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void) setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
    customTableRowView *row = (customTableRowView*)self.superview;
    if (row.isSelected) {
        self.mainTextField.textColor = [NSColor whiteColor];
        self.mainTextField.alphaValue=1.0;
        self.detailTextField.textColor = [NSColor whiteColor ];
    } else {
        self.mainTextField.textColor = [NSColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.0];
        self.detailTextField.textColor = [NSColor whiteColor];
        
    }
    
}


    @end

