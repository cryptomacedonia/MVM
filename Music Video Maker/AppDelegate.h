//
//  AppDelegate.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 4/17/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "filesWindowController.h"
#import "WindowController.h"
#import "splashWindowController.h"
#import "TDAuthWindowController.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"
#import "EditingControls.h"
//#import <StripeOSX/Stripe.h>
#import "RMStore.h"
#import "subscriptionList.h"
#import "exportSubscriptionAd.h"

@class  TDAuthWindowController,subscriptionList,exportSubscriptionAd;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property filesWindowController * filesWindowController;
@property (strong, nonatomic)subscriptionList * subscriptionWindowController;
@property (strong, nonatomic) exportSubscriptionAd * exportSubscriptionController;
@property (strong, nonatomic) WindowController * playWindowController;
@property (strong, nonatomic) splashWindowController * splashController;
@property (strong, nonatomic) EditingControls * editingControlsController;
@property (strong, nonatomic) TDAuthWindowController *authWindowController;
- (void)authSuccess;
-(void) subscribeNow;
-(void) hideSubscription;
-(void) showExportSubscription;
-(void) hideExportSubscription;
@end

