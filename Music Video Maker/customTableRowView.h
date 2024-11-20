//
//  customTableRowView.h
//  playTableView
//
//  Created by Igor Jovcevski on 12/30/15.
//  Copyright © 2015 WoowaveTemplate. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface customTableRowView : NSTableRowView
@property NSImageView * backgroundImage;
@property NSColor * highlightedFillColor;
@property NSColor * highlightedStrokeColor;
@property BOOL odd;
@end
