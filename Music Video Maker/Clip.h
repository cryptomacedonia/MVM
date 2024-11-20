//
//  Clip.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/18/16.
//  Copyright © 2016 Woowave. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#import "SDAVAssetExportSession.h"
#import "WOO_AVURLAsset.h"

typedef struct
{
    unsigned long long frejm;
    unsigned long long hashot;
}parC;
@interface Clip : NSObject <SDAVAssetExportSessionDelegate>
{
parC * maxesAsArray;
}
@property NSString * UUID;
@property NSString * filePath;
@property NSString * proxyFilePath;
@property CMTime  duration;
@property long timeStamp;
@property BOOL clipstatus;
@property NSImage * thumbImage;
@property int numberOfMaxes;
@property size_t sizeOfFile;
@property size_t durationInFrames;
@property BOOL alreadyAnalyzed;
@property int numberOfVideoTracks;
@property int numberOfAudioTracks;
@property float FPS;
// for updating table view
@property NSTableView * showingTableView;
@property int  row;
@property NSMutableArray * matchedClips;
@property NSInteger columnIndex;
@property SDAVAssetExportSession *  encoder;
-(void) processThumbs;
-(NSString*) getFormattedTimeStamp;
-(void) extractAudiofromMediaFile:(NSString*)filePath withBlock:(BlockHandler_Bool)block;
-(void) getAudioFingerPrints:(float) strength;
//
-(void) makeProxywithWidth:(int)width andHeigh:(int)height  withBlock:(BlockHandler_Bool)block;
-(void) compareToClip:(Clip*) otherClip;
-(NSString *) makeJson:(NSMutableArray*) tracks;
- (NSString *)generateMD5:(NSString *)string;
-(instancetype) initWithFileUrl:(NSString*)fileUrl NS_DESIGNATED_INITIALIZER;
- (void)beginUploadwithBlock:(BlockHandler_Bool)block;
@end
