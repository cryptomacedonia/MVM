//
//  filesWindowController.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/14/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "filesWindowController.h"

@interface filesWindowController ()

@end

@implementation filesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
      [self.window setBackgroundColor: [NSColor blackColor]];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (void)windowWillClose:(NSNotification *)notification {
    // whichever operations are needed when the
    // window is about to be closed
}
@end
