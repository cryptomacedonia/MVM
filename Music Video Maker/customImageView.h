//
//  customImageView.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 4/21/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "WOO_AVURLAsset.h"
@class WOO_AVURLAsset;
@interface customImageView : NSImageView
@property NSString * remainingTime;
@property NSTextField *textField;
@property NSButton * linkButton;
@property BOOL linked;
@property NSTrackingArea * trackingArea;
-(void)disableTraCkingArea;
-(void)enableTrackingArea;
-(void) buttonAction;
@property WOO_AVURLAsset* assetUsedForAngle;
@property NSView * scrubber;
@property float assetDuration;
@property AVPlayerLayer * playerLayer;
@property AVPlayer * player;
@property CMTime  inPoint;
@property CMTime  outPoint;
@property CMTime  time1;
@property CMTime  time2;
@property BOOL drawInOut;
float scale( float valueIn,  float baseMin,  float baseMax,  float limitMin,  float limitMax);
-(void) setInPoint;
-(void) setOutPoint;
-(void) buttonAction;
@end
