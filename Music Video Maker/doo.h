//
//  createComposition.h
//  json2avcomposition
//
//  Created by Igor Jovcevski on 5/25/15.
//  Copyright (c) 2015 Igor Jovcevski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "playController.h"
#import "NSImage+CGImage.h"
#import <SystemConfiguration/SCNetwork.h>
#import "WOO_AVURLAsset.h"
#import "globalData.h"
typedef void(^BlockHandler_Dict)(NSMutableDictionary *retDict);
typedef void(^BlockHandler_Bool)(bool retBool);
typedef void(^BlockHandler_Array)(NSMutableArray * retArray);
typedef void(^BlockHandler_String)(NSString * retString);
typedef void(^BlockHandler_NSImage)(NSImage * retImage);
@interface doo : NSObject
#define DEVICE_SIZE [[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size
//+(NSArray*) getCompositionsFromFile:(NSString *) passedPath sourceController:(id) sourceController;
+(AVMutableComposition*) createAVCompositionFromTrack:(NSDictionary*) trackData useProxyIfAvailable:(BOOL) useProxy;
+(NSArray*) getCompositionsFromFile:(NSString *) jsonFile proxyIfAvailable:(BOOL) useProxy;
+(AVMutableVideoComposition*) createVideoCompWithMainComp:(AVMutableComposition*) masterComp withTracks:(NSArray*) shownTracks  sourceController:(id) sourceController;
+(AVMutableAudioMix*) createAudioMixWithMainComp:(AVMutableComposition*) masterComp withTracks:(NSArray*) shownTracks  sourceController:(id) sourceController;
+(AVMutableVideoComposition*) createVideoCompWithMainComp2:(AVMutableComposition*) masterComp withTracks:(NSArray*) shownTracks  sourceController:(id) sourceController;
+(AVMutableComposition*) exportMusicVideoMontageSequence:(NSMutableArray*) edits forMainComp:(AVMutableComposition*) mainComp;
+(void) addtitle:(NSString*) artistname songName:(NSString*)songname releaseDate:(NSString*) releasedate albumName:(NSString*) albumName forVideoComposition:(AVMutableVideoComposition*) videoComp fromMainComposition:(AVMutableComposition*) mainComp;
+(void) showToasMsg:(NSString*)msg inView:(NSView*) view forDuration:(float) duration;
+(void) moveMouseToLocationX:(float) x Y:(float)y andClickIt:(BOOL) toclick;
+(BOOL) subscriptionOKLocal;
+(void) verifyFULLFEATUREDSubscriptionWithServer:(BlockHandler_Bool)block;
+(void) showProgressWithMsg:(NSString*) msg;
+(AVMutableVideoComposition*) addImageOverLayToMainCompwithVideoComp:(AVMutableVideoComposition*) videoComp image:(NSImage*) image;
+(void) addWatermarkToVideoFile:(NSString*) filePath image:(NSImage*) watermarkImage delegate:(NSWindowController*) delegate;
+(void) uploadSerials;
+ (BOOL) validateEmail: (NSString *) candidate;
+(BOOL)connected2internet;
+(NSArray *) detectFacesInImage:(CIImage*)myImage;
+(AVAssetTrack*) findAssetWIthTrackId:(CMPersistentTrackID)trackId;
+(AVMutableCompositionTrack*) isthereanemptyTracktoPasteHere:(AVMutableComposition*)masterComp atTime:(CMTime) currentTime forRange:(CMTimeRange) timeRange;
+ (NSString *)generateMD5Hash:(NSString *)string;
@end
