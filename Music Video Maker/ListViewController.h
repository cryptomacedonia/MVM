//
//  ViewController.h
//  playTableView
//
//  Created by Igor Jovcevski on 12/23/15.
//  Copyright © 2015 WoowaveTemplate. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WWNSTableView.h"
#import "customScrollView.h"
#import "MediaController.h"
#import "customHeaderCell.h"
#import "customPlayerWindowController.h"
#import "mediaFileObjC.h"
#import "MASTERDATA.h"
#import "APICalls.h"
#import "FBKVOController/NSObject+FBKVOController.h"
#define defaultRowViewFillColor [NSColor colorWithRed:0.3 green:0.7 blue:0.1 alpha:0.5]
#define defaultRowViewStrokeColor  [NSColor colorWithCalibratedWhite:.65 alpha:1.0]

@interface ListViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate,ExtendedTableViewDelegate>
@property NSMutableArray * dataArray;

@property (weak) IBOutlet WWNSTableView *leftTableView;
@property (weak) IBOutlet WWNSTableView *rightTableView;
@property (weak) IBOutlet NSTableHeaderView *tableViewHeader;

@property NSWindow * childPlayerWindow;
@property customPlayerWindowController * playerWindowController;
@property (weak) IBOutlet WWNSTableView *otherTable;
@property (weak) IBOutlet customScrollView *leftScrollView;
@property (weak) IBOutlet customScrollView *rightScrollView;
@property MediaController * parentController;
@property NSString * controllerID;
@property BOOL previewIsOn;
-(void) refreshData;
@property  FBKVOController *KVOController;
@end

