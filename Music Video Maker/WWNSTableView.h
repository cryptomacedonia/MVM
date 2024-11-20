//
//  WWNSTableView.h
//  playTableView
//
//  Created by Igor Jovcevski on 12/23/15.
//  Copyright © 2015 WoowaveTemplate. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol ExtendedTableViewDelegate <NSObject>

- (void)tableView:(NSTableView *)tableView didClickedRow:(NSInteger)row;

@end
@interface WWNSTableView : NSTableView
@property WWNSTableView * pairedTableView;
@property (nonatomic, weak) id<ExtendedTableViewDelegate> extendedDelegate;
@end
