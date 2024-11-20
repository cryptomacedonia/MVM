//
//  EditingControls.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 6/9/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EditingControls : NSWindowController
@property (weak) IBOutlet NSButton *previewButton;
@property (weak) IBOutlet NSButton *previousEdit;
@property (weak) IBOutlet NSButton *gotoStart;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSButton *gotoendbutton;
@property (weak) IBOutlet NSButton *nexteditbutton;
@property (weak) IBOutlet NSButton *exportButton;
@property (weak) IBOutlet NSButton *filtersButton;

@end
