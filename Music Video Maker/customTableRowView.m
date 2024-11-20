//
//  customTableRowView.m
//  playTableView
//
//  Created by Igor Jovcevski on 12/30/15.
//  Copyright © 2015 WoowaveTemplate. All rights reserved.
//

#import "customTableRowView.h"
#import "WWNSTableView.h"

@implementation customTableRowView {
@private
    NSColor *lineColor;
    NSInteger clickCount;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *line = [NSBezierPath bezierPath];
   //  [self setLineColor:[NSColor blackColor]];
    [line moveToPoint:NSMakePoint(NSMinX([self bounds]), NSMinY([self bounds]))];
    [line lineToPoint:NSMakePoint(NSMaxX([self bounds]), NSMinY([self bounds]))];
    [line setLineWidth:0.5]; /// Make it easy to see
    /// Make future drawing the color of lineColor.
    [[NSColor lightGrayColor] setStroke];
    [line stroke];
    WWNSTableView * tableView=self.superview;
    int row = [tableView rowForView:self];
    // Drawing code here.
    
    if (row%2)
    {
//        NSRect selectionRect = NSInsetRect(self.bounds, 0, 0);
//    [[NSColor colorWithCalibratedWhite:.65 alpha:0.2] setStroke];
//    //        [[NSColor colorWithCalibratedWhite:.82 alpha:1.0] setFill];
//    [[NSColor colorWithRed:0.3 green:0.2 blue:0.1 alpha:0.1] setFill];
//    NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:0 yRadius:0];
//    
//   // [[NSColor lightGrayColor] setFill];
//  //  [[NSColor whiteColor] setStroke];
//    
//    [selectionPath fill];
//    [selectionPath stroke];
    }
    
}
- (void)setLineColor:(NSColor *)color {
    if (color != lineColor) {
        lineColor = [color copy];
        [self setNeedsDisplay:YES]; /// We changed what we'd draw, invalidate our drawing.
    }
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    
 
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSInsetRect(self.bounds, 0, 0);
        [[NSColor colorWithCalibratedWhite:.65 alpha:1.0] setStroke];
//        [[NSColor colorWithCalibratedWhite:.82 alpha:1.0] setFill];
        [[NSColor colorWithRed:0.3 green:0.7 blue:0.1 alpha:0.5] setFill];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:0 yRadius:0];
        
        [_highlightedFillColor setFill];
       // [_highlightedStrokeColor setStroke];
        
        [selectionPath fill];
        [selectionPath stroke];
    }
    
    
    
}

- (NSTableViewSelectionHighlightStyle)selectionHighlightStyle
{
    return NSTableViewSelectionHighlightStyleRegular;
}
@end
