//
//  AppDelegate.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 4/17/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "AppDelegate.h"

#import "doo.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
  
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // [Parse setApplicationId:@"Mgpn7czZQZ6Eax55QCuYWiiIadSHfX8elDY0BcNq" clientKey:@"8VUho8l0TEYDfszCuNZZqxbNC03oXPcKFj5hngJf"];
  //  [doo uploadSerials];
//    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *filePath = [documentDir stringByAppendingPathComponent:@"advert@2x.png"];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/advertsmvm/advert.png"]];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"Download Error:%@",error.description);
//        }
//        if (data) {
//            [data writeToFile:filePath atomically:YES];
//            NSLog(@"File is saved to %@",filePath);
//        }
//    }];
  
//    NSString *filePath2 = [documentDir stringByAppendingPathComponent:@"exportwatermark.png"];
//
//      NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/advertsmvm/exportwatermark.png"]];
//    
//    [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"Download Error:%@",error.description);
//        }
//        if (data) {
//            [data writeToFile:filePath2 atomically:YES];
//            NSLog(@"File is saved to %@",filePath2);
//        }
//    }];

//    NSString *filePath3 = [documentDir stringByAppendingPathComponent:@"export-subscribe@2x.png"];
//    
//    NSURLRequest *request3 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/advertsmvm/export-subscribe.png"]];
//    [NSURLConnection sendAsynchronousRequest:request3 queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"Download Error:%@",error.description);
//        }
//        if (data) {
//            [data writeToFile:filePath3 atomically:YES];
//            NSLog(@"File is saved to %@",filePath);
//        }
//    }];

    
  //Stripe.setDefaultPublishableKey("pk_test_5vzq4mWYIF01EzsHXcnfGDFA")
   // [Stripe setDefaultPublishableKey:@"pk_test_5vzq4mWYIF01EzsHXcnfGDFA"];
   // [self licensecheck];
//  
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(170 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self subscribeNow];
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(370 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self subscribeNow];
//    });
   
 
    
   // + (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account;
       [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPlayWindow)
                                                 name:@"showPlayWindow"
                                               object:nil];
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
    _filesWindowController = [storyBoard instantiateControllerWithIdentifier:@"filesWindow"]; // instantiate your window controller
    // _filesWindowController = [storyBoard instantiateControllerWithIdentifier:@"filesWindow"]; // instantiate
   
    _splashController = [storyBoard instantiateControllerWithIdentifier:@"splashWindow"];
  
     // [_filesWindowController showWindow:self];
   
         [_splashController showWindow:self];
    [_splashController.window addChildWindow:_filesWindowController.window ordered:NSWindowBelow];
// [_splashController.window setLevel:CGWindowLevelForKey(kCGMaximumWindowLevelKey)];
   
    // ****************************************************************************

    // Insert code here to initialize your application
}

-(BOOL) licenseOK
{
  
    BOOL licenseOK=YES;
   
  //  if (currentTime>savedTime&&currentTime-savedTime<(60000*60*24*7))
     //   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"trial"];
    
    return licenseOK;
    
}

-(void) showPlayWindow
{
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
  
    _playWindowController = [storyBoard instantiateControllerWithIdentifier:@"playWindow"];
    [_playWindowController showWindow:self];
   
     [self.editingControlsController showWindow:self];
   // [_playWindowController.window addChildWindow:_editingControlsController.window ordered:NSWindowAbove];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (IBAction)previousedit:(id)sender {
    NSLog(@"previous edit");
     [[NSNotificationCenter defaultCenter] postNotificationName:@"previous" object:nil];
}
- (IBAction)nextEdit:(id)sender {
    NSLog(@"next edit");
     [[NSNotificationCenter defaultCenter] postNotificationName:@"next" object:nil];
}
- (IBAction)switchPreviewMode:(id)sender {
    
  [[NSNotificationCenter defaultCenter] postNotificationName:@"previewMode" object:nil];
    
    
}
- (IBAction)switchPlayBackPausePlay:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playPause" object:nil];
    
    
    
}
-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (IBAction)copyFilterSettings:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"copyFilterSettings" object:nil];
    
}

- (IBAction)setInPoint:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setInPoint" object:nil];
    
}
- (IBAction)setOutPoint:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setOutPoint" object:nil];
    
}


- (IBAction)pasteFilterSettings:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pasteFilterSettings" object:nil];
    
}
- (IBAction)applyThisFilterToAllClips:(id)sender {
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"applyThisFilterToAllClips" object:nil];
}
- (IBAction)resetFilterSettings:(id)sender {
   [[NSNotificationCenter defaultCenter] postNotificationName:@"resetFilterSettings" object:nil];
    
    
}
- (EditingControls *)editingControlsController {
    if (_editingControlsController == nil) {
        _editingControlsController = [[EditingControls alloc] initWithWindowNibName:@"EditingControls"];
    }
    return _editingControlsController;
}
- (TDAuthWindowController *)authWindowController {
    if (_authWindowController == nil) {
        _authWindowController = [[TDAuthWindowController alloc] initWithWindowNibName:@"TDAuthWindowController"];
    }
    return _authWindowController;
}
- (subscriptionList *)subscriptionWindowController {
    if (_subscriptionWindowController == nil) {
        _subscriptionWindowController = [[subscriptionList alloc] initWithWindowNibName:@"subscriptionList"];
    }
    return _subscriptionWindowController;
}
- (exportSubscriptionAd *)exportSubscriptionController {
    if (_exportSubscriptionController == nil) {
        _exportSubscriptionController = [[exportSubscriptionAd alloc] initWithWindowNibName:@"exportSubscriptionAd"];
    }
    return _exportSubscriptionController;
}
-(void)authSuccess
{
    [NSApp stopModalWithCode:1];
  
    
   [self.authWindowController.window orderOut:self];
    
    
}
- (IBAction)logout:(id)sender {
 
    
    // Clean up state - close the main window and allow users to log in / sign up
    // as a different user.
  //  [[self.splashController window] close];
   // [NSApp runModalForWindow:self.authWindowController.window];
   // [self.authWindowController showWindow:self];
}
- (IBAction)manageSubscription:(id)sender {
    
//  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions"]];
}
-(void) hideSubscription
{
    dispatch_async(dispatch_get_main_queue(), ^{
          [self.subscriptionWindowController.window orderOut:self];
    });


    
    
}
-(void) hideExportSubscription
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.exportSubscriptionController.window orderOut:self];
    });
 
    
    
    
    
    
}
-(void) showExportSubscription
{
    
    [self.exportSubscriptionController showWindow:self];
    
  //   [NSApp runModalForWindow:self.exportSubscriptionController.window];
    
    
}

-(void) subscribeNow
{
//    BOOL demo = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo"];
//    if (demo)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self.subscriptionWindowController showWindow:self];
    });
    
      //  });

   
        
    //}
  //  [NSApp runModalForWindow:self.subscriptionWindowController.window];
    
    
    
}

//- (IBAction)verifySubscription:(id)sender {
//    [doo verifyFULLFEATUREDSubscriptionWithServer:^(bool retBool) {
//        if (!retBool)
//        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self subscribeNow];
//                    });
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(370 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self subscribeNow];
//                    });
//            
//  
//            
//            
//            
//        }
//        
//    }];
//    }
- (IBAction)showHelp:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.musicianvideomaker.com/help"]];
    
    
    
    
}

- (IBAction)cutClip:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"cutClip" object:nil];
}

@end
