//
//  mainController.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/11/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "mainController.h"

@interface mainController ()

@end

@implementation mainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(void)viewDidAppear
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _splashImage.alphaValue=0;
    });
    
    
    
}

- (IBAction)switchMode:(id)sender {
    
    NSDictionary * sendData = @{@"mode":@(_switchModeButton.selectedSegment)};
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"modeChanged" object:sendData];
    
}

- (IBAction)renderAction:(id)sender {
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"render" object:nil];
    
    
}



@end
