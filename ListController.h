//
//  ListController.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/16/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ListController : NSViewController <NSTabViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTextField *dragDropLabel;
@property (weak) IBOutlet NSButton *bottomButton;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSTableView *tableView;
@property BOOL isMusicAdded;
@property NSMutableArray * tracks;
@property BOOL readyForSync;
@property int numberOfProcessedFiles;
@property int numberoftotalfiles;
@end
