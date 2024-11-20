//
//  subscriptionList.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 6/8/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RMStore.h"
@interface subscriptionList : NSWindowController<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property NSArray * subscriptionsAvailable;
@property (weak) IBOutlet NSImageView *imageView;
@property NSImage * advert;
@end
