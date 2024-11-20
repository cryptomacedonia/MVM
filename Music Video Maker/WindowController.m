//
//  WindowController.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 4/18/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "WindowController.h"

@interface WindowController ()

@end

@implementation WindowController

- (void)windowDidLoad

{
    [super windowDidLoad];
    
    self.window.aspectRatio = CGSizeMake(1064, 601);
     self.window.contentAspectRatio = CGSizeMake(1064, 601);
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.window setBackgroundColor: [NSColor blackColor]];
}

- (BOOL)popoverShouldDetach:(NSPopover *)popover {
    return YES;
}

-(void)windowWillClose:(NSNotification *)notification
{
    
    
    
}

@end
