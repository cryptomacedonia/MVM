//
//  CustomAVPlayerView.m
//  Musician Video Maker Pro
//
//  Created by Igor Jovcevski on 20.11.24.
//  Copyright © 2024 Woowave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAVPlayerView.h"
@implementation CustomAVPlayerView

// Override hitTest method to ignore mouse events
- (NSView *)hitTest:(NSPoint)point {
    // Define the bottom area as a specific rectangle
    CGFloat controlHeight = 50; // Height of the player control area
    NSRect bottomArea = NSMakeRect(0, 0, self.bounds.size.width, controlHeight);

    // If the click is within the bottom area, pass it through to the view
    if (NSPointInRect(point, bottomArea)) {
        return [super hitTest:point]; // Allow the event to pass through to the controls
    }

    // Otherwise, return nil to ignore the mouse event
    return nil;
}

@end
