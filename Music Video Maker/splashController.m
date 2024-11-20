//
//  splashController.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/23/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "splashController.h"
#import "splashWindowController.h"
#import "JNWAnimatableWindow.h"
#import "AppDelegate.h"
@interface splashController ()

@end

@implementation splashController

- (void)viewDidLoad {
     [super viewDidLoad];
    CALayer *viewLayer = self.view.layer;
    NSString *str=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"loop.mp4"];
   
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:str]];
    _playerView.player  =   self.playerView.player = [AVPlayer playerWithPlayerItem:item];
               self.playerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    ;
    [viewLayer setBackgroundColor:(__bridge CGColorRef _Nullable)([NSColor colorWithPatternImage:[NSImage imageNamed:@"NSTexturedFullScreenBackgroundColor"]])]; //RGB plus Alpha Channel
//    [self.view setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
//    [self.view setLayer:viewLayer];
    //[[self view] setBackgroundColor: [NSColor colorWithPatternImage:[NSImage imageNamed:@""]]];
  //  NSString * userSerial = [PFUser currentUser][@"serial"];
    
//    if (!userSerial)
//        userSerial=@"";
//    [_textField setStringValue:userSerial];
   
     NSWindow * window =_imageView.window;
    [window setMovable:NO];
   
    [_imageView setAcceptsTouchEvents:YES];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     //   if ([PFUser currentUser])
        {
//            [doo verifyFULLFEATUREDSubscriptionWithServer:^(bool retBool) {
//                if (!retBool)
//                {
////                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                        [DJProgressHUD dismiss];
//                        //[[(AppDelegate *)[NSApp delegate] authWindowController] window];
//                        //  [PFUser logOut];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                      //   [NSApp runModalForWindow:[[(AppDelegate *)[NSApp delegate] authWindowController] window]];
//                        [[(AppDelegate *)[NSApp delegate] authWindowController] showWindow:self];
//                        
//                    });
//                    
//               //     });
//                  
//                    
//                    
//                }
//                
//                
//                
//            }];
            // [self.mainWindowController showWindow:self];
        }
      // else
       {
            
           //  [NSApp runModalForWindow:[[(AppDelegate *)[NSApp delegate] authWindowController] window]];
           // [[(AppDelegate *)[NSApp delegate] authWindowController] showWindow:self];
           //  [self.authWindowController showWindow:self];
        }
        
    });
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerItemDidReachEnd)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: nil];
    // Do view setup here.
}
-(void) playerItemDidReachEnd
{
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [self.playerView.player play];
    }];
    
}
- (IBAction)hide:(id)sender {
    
 //   PFUser * user = [PFUser currentUser];
     NSButton * butt = sender;
  //  if ([user[@"emailVerified"] boolValue])
    {
        
        
        
        
        
       
        NSWindow * window =_imageView.window;
        NSRect frejm = window.frame;
        frejm.origin.y = 450;
        NSLog(@"WINDOW POSITION:%f %f ",frejm.origin.x,frejm.origin.y);
        NSWindow * childWindow = [window.childWindows firstObject];
        NSRect frejm2 = childWindow.frame;
        frejm2.origin.y = 100;
        frejm2.size.height = 500;
        NSLog(@"WINDOWchild POSITION:%f %f ",frejm2.origin.x,frejm2.origin.y);
        // [window setFrame:frejm withDuration:50.0 timing:nil];
        // [window makeKeyAndOrderFront:self];
        
        [NSAnimationContext beginGrouping];
        [[childWindow animator] setFrame:frejm2 display:YES];
        [[window animator] setFrame:frejm display:YES];
        
        [NSAnimationContext endGrouping];
   // if (butt)
//    { [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"demo"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [butt setEnabled:NO];
//    NSString * serialEntered = _textField.stringValue;
//    PFQuery *q = [PFQuery queryWithClassName:@"serials"];
//    [q whereKey:@"serial" containedIn:@[serialEntered]];
//    [doo showProgressWithMsg:@"checking serial number..."];
//     [q findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//          PFUser * user = [PFUser currentUser];
//          [butt setEnabled:YES];
//           PFObject * oneRow = [objects firstObject];
//         if (objects.count&&([oneRow[@"userID"] isEqualToString:user.objectId]||!oneRow[@"userID"]))
//         {
//             [DJProgressHUD dismiss];
//             
//             [doo showProgressWithMsg:@"Serial number OK!"];
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                 [DJProgressHUD dismiss];
//             });
//            
//             
//            if (!user[@"serial"])
//            {
//             user[@"IMPORT"] = oneRow [@"IMPORT"];
//             user[@"HD"] = oneRow [@"HD"];
//             user[@"EXPORT"] = oneRow [@"EXPORT"];
//             user[@"WATERMARK"] = oneRow [@"WATERMARK"];
//             user[@"serial"] = oneRow [@"serial"];
//             oneRow[@"userID"] = user.objectId;
//             oneRow[@"username"] =   user[@"username"];
//             oneRow[@"email"] =   user[@"email"];
//            }
//             else
//             {
//             oneRow[@"userID"] = user.objectId;
//             oneRow[@"username"] =   user[@"username"];
//             oneRow[@"email"] =   user[@"email"];
//             oneRow[@"IMPORT"] =   user[@"IMPORT"];
//             oneRow[@"EXPORT"] =   user[@"EXPORT"];
//             oneRow[@"WATERMARK"] =   user[@"WATERMARK"];
//             oneRow[@"HD"] =   user[@"HD"];
//             user[@"serial"] = oneRow [@"serial"];
//             }
//             
//             [oneRow save];
//             [user save];
//             NSWindow * window =_imageView.window;
//             NSRect frejm = window.frame;
//             frejm.origin.y = 450;
//             NSLog(@"WINDOW POSITION:%f %f ",frejm.origin.x,frejm.origin.y);
//             NSWindow * childWindow = [window.childWindows firstObject];
//             NSRect frejm2 = childWindow.frame;
//             frejm2.origin.y = 100;
//             frejm2.size.height = 500;
//             NSLog(@"WINDOWchild POSITION:%f %f ",frejm2.origin.x,frejm2.origin.y);
//             // [window setFrame:frejm withDuration:50.0 timing:nil];
//             // [window makeKeyAndOrderFront:self];
//             
//             [NSAnimationContext beginGrouping];
//             [[childWindow animator] setFrame:frejm2 display:YES];
//             [[window animator] setFrame:frejm display:YES];
//             
//             [NSAnimationContext endGrouping];
//         } else
//         {
//              [DJProgressHUD dismiss];
//            if (oneRow[@"userID"])
//             [doo showProgressWithMsg:@"serial number already registered!"];
//             else
//                [doo showProgressWithMsg:@"serial number not valid!"];
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                  [DJProgressHUD dismiss];
//             });
//         }
//         
//        
//    }];
//    
//  
////    NSError * error;
////    NSString * availableSerials = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://s3-eu-west-1.amazonaws.com/teewowireland/data.dat"] encoding:NSUTF8StringEncoding error:&error];
////    
////    NSArray * strings = [availableSerials componentsSeparatedByString:@","];
////    
////   NSString * textfieldvalue = _textField.stringValue;
////
////    if (![availableSerials containsString:textfieldvalue]&&textfieldvalue.length>5)
////    {
////        
////        [PFUser currentUser][@"IMPORT"]=@"0";
////        [PFUser currentUser][@"EXPORT"]=@"0";
////        [PFUser currentUser][@"HD"]=    @"0";
////        
////     //   exit(0);
////        
////        
////        
////    }
////    else
////    {   [[NSUserDefaults standardUserDefaults] setObject:textfieldvalue forKey:@"serialMVM"];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////        [PFUser currentUser][@"EXPORT"]=@"1";
////         [PFUser currentUser][@"HD"]=@"1";
////         [PFUser currentUser][@"IMPORT"]=@"1";
////   
//// }
////    
////    NSButton * butt = sender;
////    [butt setHidden:YES];
// 
//  //  [window orderOut:nil];
//        
//        
//        
//        
//        } else
        {
            //demo
            
            NSWindow * window =_imageView.window;
            NSRect frejm = window.frame;
            frejm.origin.y = 450;
            NSLog(@"WINDOW POSITION:%f %f ",frejm.origin.x,frejm.origin.y);
            NSWindow * childWindow = [window.childWindows firstObject];
            NSRect frejm2 = childWindow.frame;
            frejm2.origin.y = 100;
            frejm2.size.height = 500;
            NSLog(@"WINDOWchild POSITION:%f %f ",frejm2.origin.x,frejm2.origin.y);
            // [window setFrame:frejm withDuration:50.0 timing:nil];
            // [window makeKeyAndOrderFront:self];
            
            [NSAnimationContext beginGrouping];
            [[childWindow animator] setFrame:frejm2 display:YES];
            [[window animator] setFrame:frejm display:YES];
            
            [NSAnimationContext endGrouping];

            
            
            
            
            
            
            
        }
        
    }
//    else
//    {
//        [user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//           if ([user[@"emailVerified"] boolValue])
//               [self hide:butt];
//           else{
//            NSAlert *alert = [NSAlert alertWithMessageText:@"Email"
//                                             defaultButton:@"OK"
//                                           alternateButton:nil
//                                               otherButton:nil
//                                 informativeTextWithFormat:@"Please verify your account by clicking the email link we sent to your email inbox earlier! "];
//            [alert runModal];
//           }
// 
//        }];
//        
//        
//    }
    
}
- (IBAction)woowavelinkopen:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPlayWindow" object:nil];
    
    
}
- (IBAction)demoAction:(id)sender {
    [doo showToasMsg:@"Please wait while we add demo clips, it may take a while depending on your system specs.." inView:self.view forDuration:4];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"demo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self hide:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"samplefootage"] ;
        NSURL *demo = [NSURL fileURLWithPath:path isDirectory:YES];
        
        NSDirectoryEnumerator *URLEnum = [[NSFileManager defaultManager] enumeratorAtURL: demo includingPropertiesForKeys: nil options: 0 errorHandler: nil];
        
        NSURL *filename;
        NSMutableArray * files = [NSMutableArray new];
        while ((filename = [URLEnum nextObject])) {
            NSLog(@"file:%@",filename);
          
            [files addObject:filename];
           
            
        }
          NSDictionary * userInfo = @{@"fileUrls":files};
 [[NSNotificationCenter defaultCenter] postNotificationName:@"addUrl" object:nil userInfo:userInfo];
    });
    
    
}
@end
