//
//  EditingControls.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 6/9/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "EditingControls.h"

@interface EditingControls ()

@end

@implementation EditingControls

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setMovable:YES];
    [self.window setMovableByWindowBackground:YES];
    [self.window setBackgroundColor: [NSColor blackColor]];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)switchpreview:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"previewMode" object:nil];
    
}
- (IBAction)previousEdit:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"previous" object:nil];
    
    
}
- (IBAction)gotostart:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"start" object:nil];
}
- (IBAction)play:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"play" object:nil];
}
- (IBAction)stop:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:nil];
}
- (IBAction)gotoend:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"end" object:nil];
}
- (IBAction)nectedit:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"next" object:nil];
}
- (IBAction)filters:(id)sender {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showFilters" object:nil];
        
        
        
    
}
- (IBAction)export:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"export" object:nil];
    
}

@end
