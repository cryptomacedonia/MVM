//
//  WindowController.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 4/18/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WindowController : NSWindowController<NSWindowDelegate,NSPopoverDelegate>
@property (strong) IBOutlet NSWindow *window;

@end
