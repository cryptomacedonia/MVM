//
//  splashWindowController.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/23/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "splashWindowController.h"

@interface splashWindowController ()

@end

@implementation splashWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setDelegate:self];
    self.window.titlebarAppearsTransparent = true; // gives it "flat" look
    self.window.backgroundColor = [NSColor blackColor]; // set the background color
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowWillClose:(NSNotification *)notification {
    // whichever operations are needed when the
    // window is about to be closed
    [NSApp terminate:self];
}

@end
