//
//  Clip.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/18/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "Clip.h"
#import "WOO_AVURLAsset.h"
#import "functions.h"
#include "json/json.h"
#import <SystemConfiguration/SystemConfiguration.h>
@implementation Clip
{
    vector<par> maxesAsVector;
    par * maxesAsParArray;
}
@synthesize encoder;
-(instancetype) initWithFileUrl:(NSString*)fileUrl  {
    if (self = [super init]) {
        self.filePath = fileUrl;
;
        self.proxyFilePath = [[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@PROXY.MP4",NSTemporaryDirectory(),[self generateMD5:self.filePath ]]] path];
        WOO_AVURLAsset*asset = [WOO_AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.filePath]];
        
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count])
            self.FPS = [[[asset tracksWithMediaType:AVMediaTypeVideo] firstObject] nominalFrameRate];
        else
            self.FPS = [[[asset tracksWithMediaType:AVMediaTypeAudio] firstObject] nominalFrameRate];
        
        CMTime duration = asset.duration;
        AVMetadataItem * metaCreation = asset.creationDate;
        
        NSDate * creationDateValue = [metaCreation dateValue];
        self.timeStamp = [creationDateValue timeIntervalSince1970]*1000;
        
        
        self.duration = duration;

       self.UUID =  [self generateMD5:self.filePath];
        _matchedClips = [NSMutableArray new];
        char  metadata[1000];
        NSString * maxesFile = [NSString stringWithFormat:@"%@%@.WWDATA",NSTemporaryDirectory(),[self generateMD5:self.filePath]];
       bool b=[[NSFileManager defaultManager] fileExistsAtPath:maxesFile];
        if (b)
        {
            WOO_AVURLAsset*asset = [WOO_AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.filePath]];
            
            if ([[asset tracksWithMediaType:AVMediaTypeVideo] count])
                self.FPS = [[[asset tracksWithMediaType:AVMediaTypeVideo] firstObject] nominalFrameRate];
            else
                self.FPS = [[[asset tracksWithMediaType:AVMediaTypeAudio] firstObject] nominalFrameRate];
            
            CMTime duration = asset.duration;
            AVMetadataItem * metaCreation = asset.creationDate;
            
            NSDate * creationDateValue = [metaCreation dateValue];
            self.timeStamp = [creationDateValue timeIntervalSince1970]*1000;
            
        
            self.duration = duration;
           const char * maxesFileChar = [maxesFile UTF8String];
            unsigned long long sampleCount;
       maxesAsVector = readMatrixWithMetadata((char*)maxesFileChar, metadata,&sampleCount);
        maxesAsParArray = &maxesAsVector[0];
        self.numberOfMaxes = maxesAsVector.size();
            self.durationInFrames = sampleCount/192;
        maxesAsArray = (parC*)maxesAsParArray;
            par * casted = (par*)maxesAsArray;
            int r= sizeof(&casted)/sizeof(par);
          //  vector<par> test(casted,casted+sizeof(casted)/sizeof(par));
//            for (int i=0;i<maxesAsVector.size();i++)
//                cout<<casted[i].frejm<<"->"<<casted[i].hashot<<endl;
            self.alreadyAnalyzed = YES;
            self.clipstatus = YES;
        }
        /* do most of initialization */
      
    }
    return(self);
}

-(id) init {
    return [self initWithFileUrl:@""];
}
-(void) processThumbs
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        [self makeThumb:^(NSImage *retImage) {
            self.thumbImage = retImage;
          dispatch_sync(dispatch_get_main_queue(), ^(void) {

                [self.showingTableView reloadData];
              NSInteger numberOfRows = [self.showingTableView numberOfRows];
              
              if (numberOfRows > 0)
                  [self.showingTableView scrollRowToVisible:numberOfRows - 1];
              
           });
            NSString * path =self.filePath;
            NSString * hash  = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[path generateMD5:path]];
            bool exists=[[NSFileManager defaultManager] fileExistsAtPath:hash];
            
            if (!exists)
            {
                [retImage lockFocus] ;
                NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0, 0.0, retImage.size.width, retImage.size.height)] ;
                [retImage unlockFocus] ;
                
                NSData *data = [newRep representationUsingType:NSPNGFileType properties:nil];
                [data writeToFile:hash atomically:YES];
            }
            
        }];});
}
- (void)makeThumb:(BlockHandler_NSImage)block
{
    
    NSURL * fileUrl = [NSURL fileURLWithPath:self.filePath];
    NSString * hash  = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),[self.filePath generateMD5:self.filePath]];
    bool exists=[[NSFileManager defaultManager] fileExistsAtPath:hash];
    float ratio = 0.2f;
    if (!exists)
    {
        
        WOO_AVURLAsset*asset = [WOO_AVURLAsset assetWithURL:fileUrl];
   //    NSArray * imagefeatures = [self generateImagesForAsset:asset];
       // NSArray * features = [doo detectFacesInImage:images[0]];
       
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime duration = asset.duration;
        AVMetadataItem * metaCreation = asset.creationDate;
       
        NSDate * creationDateValue = [metaCreation dateValue];
       self.timeStamp = [creationDateValue timeIntervalSince1970]*1000;
     
        CGFloat durationInSeconds = duration.value / duration.timescale;
        CMTime time = CMTimeMakeWithSeconds(durationInSeconds * ratio, (int)duration.value);
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        NSImage *thumbnail = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(190, 100)];
        CGImageRelease(imageRef);
        
        block(thumbnail);
    }
    else
        
    {
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:hash];
        NSImage * image = [[NSImage alloc] initWithData:imageData];
        block(image);
        
        
        
    }
}

-(NSString*) getFormattedTimeStamp
{
    
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:((double)self.timeStamp / 1000.0)];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    
    return dateString;
}
-(void) getAudioFingerPrints:(float) strength
{
   
    
    NSString * path=[NSTemporaryDirectory() stringByAppendingPathComponent:[[self generateMD5:self.filePath] stringByAppendingPathExtension:@"WAV"]];
    const char *filePath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    int durationinframes=0;
   // cout<<"processing file:"<<self.filePath.UTF8String<<"wavfile:"<<filePath<<endl;
    NSData * data1 = [NSData dataWithContentsOfFile:path];
    if (data1.length<45)
        return;
    data1 = [data1 subdataWithRange:NSMakeRange(44, data1.length-44)];
    short * arr = (short*)[data1 bytes];
    unsigned long long samples = (data1.length-44)/2;
    size_t returnSize=0;
    
    assert(arr);
//    std::vector<double> v;
//    double* a = &v[0];
    maxesAsVector = proccessWavDataPAR(arr, samples, 0.994 - strength/1000, 80000, &returnSize,31,63);
    //*_numberOfProcessedFiles = *_numberOfProcessedFiles+1;
    maxesAsParArray = &maxesAsVector[0];
    maxesAsArray = (parC*)maxesAsParArray;
    self.durationInFrames=samples/192;
    self.numberOfMaxes = returnSize;
    
    
    maxesAsParArray = &maxesAsVector[0];
    self.numberOfMaxes = maxesAsVector.size();
    self.durationInFrames = samples/192;
    maxesAsArray = (parC*)maxesAsParArray;
   
 
    //  vector<par> test(casted,casted+sizeof(casted)/sizeof(par));
    //            for (int i=0;i<maxesAsVector.size();i++)
    //                cout<<casted[i].frejm<<"->"<<casted[i].hashot<<endl;
    self.alreadyAnalyzed = YES;
    self.clipstatus = YES;

    
    
  
    uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:nil] fileSize];
    self.sizeOfFile=fileSize;
    NSString * sajz=[NSString stringWithFormat:@"-%llu",fileSize];
    sajz=[sajz stringByAppendingString:@".WWDATA"];
 //   NSString * filePathMarkers=[NSTemporaryDirectory() stringByAppendingPathComponent:[[[self.filePath lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:sajz]];
    //writeMatrix(filePathMarkers, _maxes);
    NSString * filePathMarkers=[NSString stringWithFormat:@"%@%@.WWDATA",NSTemporaryDirectory(),[self generateMD5:self.filePath]];
    char * metadata = "testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest";
    writeMatrixWithMetadata((char*)[filePathMarkers UTF8String],maxesAsVector,metadata,400,samples);
  //  writeMatrixPAR((char*)[filePathMarkers UTF8String],maxesAsVector,metadata);
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathMarkers];
    if (fileExists)
    {
//                const char * maxesFileChar = [filePathMarkers UTF8String];
//        unsigned long long sampleCount;
//        char * metadata;
//        maxesAsVector = readMatrixWithMetadata((char*)maxesFileChar, metadata,&sampleCount);
//        maxesAsParArray = &maxesAsVector[0];
//        self.numberOfMaxes = maxesAsVector.size();
//        self.durationInFrames = sampleCount/192;
//        _maxesAsArray = (parC*)maxesAsParArray;
       // par * casted = (par*)_maxesAsArray;
     //   int r= sizeof(&casted)/sizeof(par);
        //  vector<par> test(casted,casted+sizeof(casted)/sizeof(par));
        //            for (int i=0;i<maxesAsVector.size();i++)
        //                cout<<casted[i].frejm<<"->"<<casted[i].hashot<<endl;
        self.alreadyAnalyzed = YES;
        self.clipstatus = YES;

       
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.showingTableView reloadData];
            NSInteger numberOfRows = [self.showingTableView numberOfRows];
            
            if (numberOfRows > 0)
                [self.showingTableView scrollRowToVisible:numberOfRows - 1];
            
        });
       
        
    }
    
    
    
    
}

-(void) extractAudiofromMediaFile:(NSString*)filePath withBlock:(BlockHandler_Bool)block
{
    WOO_AVURLAsset* asset = [WOO_AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    
    NSLog(@"isexportable=%d",asset.isExportable);
    
    NSString * fileNameHash = [self generateMD5:filePath];
    NSString * outUrl =  [NSString stringWithFormat:@"%@%@.WAV",NSTemporaryDirectory(),fileNameHash];
     bool b=[[NSFileManager defaultManager] fileExistsAtPath:outUrl];
    if (b)
        [[NSFileManager defaultManager] removeItemAtPath:outUrl error:nil];
    encoder = [[SDAVAssetExportSession alloc] initWithAsset:asset];
    encoder.audioOnly = YES;
    encoder.outputFileType = AVFileTypeWAVE;
    encoder.delegate=self;
    // encoder.videoComposition = videoComp;
    encoder.outputURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@.WAV",NSTemporaryDirectory(),fileNameHash]];
    
    encoder.audioSettings = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                  [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                                                  [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
                                                                  [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                                                  [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                                                  [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,  
                                                                  [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,  
                                                                  [NSNumber numberWithUnsignedInteger:1], AVNumberOfChannelsKey,  
                                                                  nil];
    [encoder exportAsynchronouslyWithCompletionHandler:^
     {
         if (encoder.status == AVAssetExportSessionStatusCompleted)
         {
            
             NSLog(@" export succeeded");
          
             block(YES);
         }
         else if (encoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Video export cancelled");
             block(NO);
         }
         else
         {
             NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, (long)encoder.error.code);
             block(NO);
         }
     }];
}
- (NSString *)generateMD5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString
            stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

-(void) compareToClip:(Clip*) otherClip
{
    par * leftArray = (par*) self->maxesAsArray;
    
    par * rightArray = (par*) otherClip->maxesAsArray;
    
    vector<par> left(leftArray,leftArray+self.numberOfMaxes);
    vector<par> right(rightArray,rightArray+otherClip.numberOfMaxes);
    
    float returnedOffset,returnedStrength,variance;;
    vector<rezultPair> rez = proveri_new(left, right, self.durationInFrames, otherClip.durationInFrames, &returnedOffset, &returnedStrength, &variance);
     NSLog(@"\n*****************************************************************************************\n");
    NSLog(@"comparing %@ with %@ -> offset:%f strength:%f variance:%f",self.filePath.lastPathComponent,otherClip.filePath.lastPathComponent,returnedOffset*192/8000,returnedStrength,variance);
    
    NSLog(@"\n*****************************************************************************************\n");
    
    if (returnedOffset&&returnedStrength)
    {
        [_matchedClips addObject:@{@"ClipObject":otherClip,@"offset":@(returnedOffset),@"strength":@(returnedStrength),@"varience":@(variance)}];
        
    }
    else
    {
         [_matchedClips addObject:@{@"ClipObject":otherClip,@"offset":@(0),@"strength":@(100),@"varience":@(100)}];
    }
    
}
-(NSString *) makeJson:(NSMutableArray*) tracks
{
//     "sequences" : [
    Json::Value trackArray;
    Json::Value sequences;
     Json::Value full;
    
    for (int i=0;i<tracks.count;i++)
    {
        
        Json::Value oneTrackJson = getJsonForTrackData(tracks[i],"vide");
        trackArray.append(oneTrackJson);
        
    }
   
    sequences.append(trackArray);
    full["sequences"] = sequences;
    NSString* result = [NSString stringWithUTF8String: full.toStyledString().c_str()];
    return result;
    
}
Json::Value getJsonForTrackData(NSMutableArray * trackClips,string trackType)
{
    
    Json::Value jsn;
    Json::Value array;
    
    for (int i=0;i<trackClips.count;i++)
    {
        
        NSDictionary * oneClip = trackClips[i];
        Json::Value ex=getJsonFromKlip(oneClip);
        array.append(ex);
        
    }
    Json::Value trackTypeValue = trackType;
    
    jsn["track"]=array;
    jsn["trackMediaType"] = trackTypeValue;
    std::cout<<"creating nested Json::Value Example pretty print: "<<endl<<jsn.toStyledString()<<endl;
    
    return jsn;
}
Json::Value getJsonFromKlip (NSDictionary * clip)
{
//    "groupOffset" : 4.896,
//    "durationInSeconds" : 88.56,
//    "FPS" : 25,
//    "fileSize" : 11563949,
//    "uniqueId" : "WWDS810C47",
//    "filePath" : "\/Users\/Igor\/Desktop\/musicVideo2\/prv del.m4v"
    Clip * oneClip = clip[@"ClipObject"];
    Json::Value klip;
    klip["groupOffset"] = ([clip[@"offset"] floatValue]*-1)*192.0f/8000.0f;
    klip["offsetInFrames"] = [clip[@"offset"] intValue]*-1;
    klip["durationInSeconds"] = CMTimeGetSeconds(oneClip.duration);
    klip["durationInFrames"] = (int)oneClip.durationInFrames;
    klip["FPS"] = oneClip.FPS;
    //klip["MXFSourceMobSlotId"] = to_string(clip.sourceReference.sourceSlotID-1);
    klip["fileSize"]=(int)oneClip.sizeOfFile;
    klip["uniqueId"]=oneClip.UUID.UTF8String;
    //klip["sourceMobId"]=buff2;
   // klip["MARK_IN"]=clip[@"MARK_IN"];
    klip["filePath"]= oneClip.filePath.UTF8String;;
    
  //  cout<<klip.toStyledString()<<endl;
    
    string returnedString =   klip.toStyledString();
    return klip;
}




-(void) makeProxywithWidth:(int)width andHeigh:(int)height  withBlock:(BlockHandler_Bool)block
{
    WOO_AVURLAsset* asset = [WOO_AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.filePath]];
    NSLog(@"isexportable=%d",asset.isExportable);
    
    
     AVAssetExportSession *exportSession = [[AVAssetExportSession       alloc]initWithAsset:asset presetName:AVAssetExportPreset640x480];
    
   
    //set the output file format if you want to make it in other file format (ex .3gp)
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
  
    
    
    // encoder.videoComposition = videoComp;
    exportSession.outputURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@PROXY.MP4",NSTemporaryDirectory(),[self generateMD5:self.filePath ]]];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status])
        {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export session failed");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                //Video conversion finished
                NSLog(@"Successful!");
//                [self S3UploadWithblock:^(bool retBool) {
//                    
//                }];
                
                NSString * uploadedFile = [[NSUserDefaults standardUserDefaults] objectForKey:[self generateMD5:self.filePath]];
                if (!uploadedFile)
                {
                    BOOL isthisDemo = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo"];
                    if (![self.filePath containsString:@"samplefootage"])
                    
                   

                [self beginUploadwithBlock:^(bool retBool) {
                    NSLog(@"Uploaded OK!");
                }];
                }
            }
                break;
            default:
                break;
        }
    }];
    
   
    
  }


/*
 Json::Value makeJsonForSequence(vector<vector<klip> > allTracks,vector<string> tracksType)
 {
 Json::Value trackArray;
 Json::Value seq;
 Json::Value seqS;
 for (int i=0;i<allTracks.size();i++)
 {
 
 Json::Value oneTrackJson = getJsonForTrackData(allTracks[i],tracksType[i]);
 trackArray.append(oneTrackJson);
 
 }
 seq.append(trackArray);
 seqS["sequences"]=seq;
 return seqS;
 
 
 }

 
 
 */




- (NSString*) getMACAddress: (BOOL)stripColons {
    NSMutableString         *macAddress         = nil;
    NSArray                 *allInterfaces      = (NSArray*)CFBridgingRelease(SCNetworkInterfaceCopyAll());
    NSEnumerator            *interfaceWalker    = [allInterfaces objectEnumerator];
    SCNetworkInterfaceRef   curInterface        = nil;
    
    while ( (curInterface = (SCNetworkInterfaceRef)CFBridgingRetain([interfaceWalker nextObject])) ) {
        if ( [(NSString*)SCNetworkInterfaceGetBSDName(curInterface) isEqualToString:@"en0"] ) {
            macAddress = [(NSString*)SCNetworkInterfaceGetHardwareAddressString(curInterface) mutableCopy];
            
            if ( stripColons == YES ) {
                [macAddress replaceOccurrencesOfString: @":" withString: @"" options: NSLiteralSearch range: NSMakeRange(0, [macAddress length])];
            }
            
            break;
        }
    }
    NSString * serial = [[NSUserDefaults standardUserDefaults] objectForKey:@"serialMVM"];
    return  [serial stringByAppendingString:[macAddress copy]];
}

- (void)beginUploadwithBlock:(BlockHandler_Bool)block
{
    
    
    NSString *uuid = [self getMACAddress:YES];
    NSString *bucket = @"teewowireland";
    NSString *key = @"AKIAJJL3XELLMYUXVHPA";
    
    
    //    NSString *bucket = @"/* Bucket Name */";
    //    NSString *key    =@" /* Key Name */";
  //  NSString *contentType = @"application/octet-stream";
     NSString *contentType = @"video/mp4";
    __weak typeof(self) weakSelf = self;
    NSString * fileName = [NSString stringWithFormat:@"%@WOO%@",uuid, [self generateMD5:self.filePath ]];
    
     NSLog(@"->filename:%@",fileName);
    
}

- (void)beginUploadingFilewithBlock:(BlockHandler_Bool)block
{
      NSString *uuid = [self getMACAddress:YES];
    
    NSString *bucket = @"teewowireland";
    NSString *key = @"AKIAJJL3XELLMYUXVHPA";
    
    
    //    NSString *bucket = @"/* Bucket Name */";
    //    NSString *key    =@" /* Key Name */";
  //  NSString *contentType = @"application/octet-stream";
    NSString *contentType = @"video/mp4";
    __weak typeof(self) weakSelf = self;
    NSString * fileName = [NSString stringWithFormat:@"%@WOO%@",uuid, [self generateMD5:self.filePath ]];
   
    
}

- (void)startDataTaskForMovieData:(NSData *)movieData withSignedURL:(NSURL *)signedURL fileName:(NSString*) fileName withBLock:(BlockHandler_Bool)block
{
    
}
-(NSArray*) generateImagesForAsset:(AVURLAsset*) asset
{
    NSMutableArray * times = [NSMutableArray new];
    for (int i = 0; i<(asset.duration.value/asset.duration.timescale);i++)
         {
             [times addObject:[NSValue valueWithCMTime:CMTimeMake(i*30, 30)]];
             
         }
AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
gen.appliesPreferredTrackTransform = YES;
CMTime time = CMTimeMakeWithSeconds(0.0, 600);
NSError *error = nil;
CMTime actualTime;
    NSMutableArray * images = [NSMutableArray new];
//CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    [gen generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
    CIImage * IMAGE = [CIImage imageWithCGImage:image];
        [images addObject:IMAGE];
        NSArray * features = [doo detectFacesInImage:IMAGE];
        
        CGImageRelease(image);
}];

    return images;
}
@end
