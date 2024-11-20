//
//  splashController.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/23/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import AVFoundation;
@import AVKit;
@interface splashController : NSViewController
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet AVPlayerView *playerView;

@end
