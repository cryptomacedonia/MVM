//
//  exportSubscriptionAd.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 6/17/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "exportSubscriptionAd.h"

@interface exportSubscriptionAd ()

@end

@implementation exportSubscriptionAd

- (void)windowDidLoad {
    [super windowDidLoad];
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"export-subscribe@2x.png"];
    _advert = [[NSImage alloc] initWithContentsOfFile:filePath];
    [_imageView setImage:_advert];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)exportWithWatermark:(id)sender {
   // [doo showProgressWithMsg:@"Exporting... Please Wait"];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"render" object:nil];
   // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [[NSApplication sharedApplication] stopModal];
 //   });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [DJProgressHUD dismiss];
//        
//    });
}
- (IBAction)subscribeAction:(id)sender {
   
   //  [doo showProgressWithMsg:@"Subscription process will continue in browser.."];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [DJProgressHUD dismiss];
    
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://musicianvideomaker.com/subscribe"]];
        [[NSApplication sharedApplication] stopModal];
        
   // });
    
    
}

@end
