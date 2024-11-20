//
//  createComposition.m
//  json2avcomposition
//
//  Created by Igor Jovcevski on 5/25/15.
//  Copyright (c) 2015 Igor Jovcevski. All rights reserved.
//

#import "doo.h"
#import "playController.h"
#import <CoreImage/CoreImage.h>
@implementation doo

    AVAssetExportSession * assetExport;

//audio mix example
//// Set the parameters of the mix being applied
//AVMutableAudioMixInputParameters *mixParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
//[mixParameters setVolume:volume atTime:kCMTimeZero];
//[mixParameters setTrackID:[track trackID]];
//
//// Add the parameters to the audio mix
//AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
//[audioMix setInputParameters:@[mixParameters];
// 
// // Apply the new audio mix to the player's current item
// [[player currentItem] setAudioMix:audioMix];


+(void) insertClipInJson:(NSDictionary*)clip inJson:(NSString*)jsonFile atTime:(CMTime)insertTime
{
    NSString         *content = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *  json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray * sequences=[json valueForKey:@"sequences"];
    for (NSArray * one in sequences)
    {
        for (int i=0;i<one.count;i++)
            //  for (NSDictionary * track in one)
        {
            NSDictionary * trackData = one[i];
            for (NSDictionary * oneClip in [trackData valueForKey:@"track"])
            {
                
             
                
            }
            
        }
        
    }
    
    
    
    
}


+(NSArray*) getCompositionsFromFile:(NSString *) jsonFile proxyIfAvailable:(BOOL) useProxy
{
  //  NSString * jsonUrl = @"data.json";
//   NSString * passedPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:jsonUrl];
// NSString * passedPath2=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:jsonFile];
    
    NSMutableArray * compositions=[NSMutableArray new];
    NSString         *content = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *  json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray * sequences=[json valueForKey:@"sequences"];
    for (NSArray * one in sequences)
    {
       AVMutableComposition * masterComp = [AVMutableComposition composition];
        for (int i=0;i<one.count;i++)
      //  for (NSDictionary * track in one)
        {
            NSDictionary * track = one[i];
           
            
            AVMutableComposition * comp=[self createAVCompositionFromTrack:track useProxyIfAvailable:useProxy];
       NSLog(@"------------------------------\n%@\n\n\n\n",comp);
           
           if ( [[comp tracksWithMediaType:AVMediaTypeVideo] count])
           {
               if (i<16)
               {
               [self insertVideoTracksinMainComposition:[comp mutableCopy] intoMasterComposition:masterComp];
               NSLog(@"video segments in this track:%lu   audio segments:%lu ",[[[[comp tracksWithMediaType:AVMediaTypeVideo] firstObject] segments] count],[[[[comp tracksWithMediaType:AVMediaTypeAudio] firstObject] segments] count]);
                              } else
               {
                   if ([[[[comp tracksWithMediaType:AVMediaTypeVideo] firstObject] segments] count] < [[[[comp tracksWithMediaType:AVMediaTypeAudio] firstObject] segments] count])
                       [self insertAudioTracksinMainComposition:[comp mutableCopy] intoMasterComposition:masterComp];

                   
                   
               }
           }
            else if ([[comp tracksWithMediaType:AVMediaTypeAudio] count])
            [self insertAudioTracksinMainComposition:[comp mutableCopy] intoMasterComposition:masterComp];
        }
        
        [compositions addObject:masterComp];
        
    }
    
     for (AVComposition * comp in compositions)
     {
        int  brojac=0;
         NSLog(@"let's check the master comps...\n");
         for (AVCompositionTrack * compTrack in comp.tracks)
         {
             brojac++;
             NSLog(@"track num %d\n-----------------------\n",brojac);
             int brojacSegment=0;
             for (AVCompositionTrackSegment * segment in compTrack.segments)
             {
                 brojacSegment++;
                 NSLog(@" empty :%d segment num:%d startTime:%lld endTime:%lld",segment.isEmpty,brojacSegment,segment.timeMapping.target.start.value/segment.timeMapping.target.start.timescale,(segment.timeMapping.target.duration.value/segment.timeMapping.target.duration.timescale)+(segment.timeMapping.target.start.value/segment.timeMapping.target.start.timescale));
                 
                 
                 
             }
             
             
             
         }
         
         
         
     }
    
    
    return compositions;
    
}

+(AVMutableComposition*) createAVCompositionFromTrack:(NSDictionary*) trackData useProxyIfAvailable:(BOOL) useProxy
{
    
    
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    // Create the video composition track.
    AVMutableCompositionTrack *mutableCompositionVideoTrack;
    // Create the audio composition track.
    AVMutableCompositionTrack *mutableCompositionAudioTrack;
     CMTime currentCMTime = kCMTimeZero;
    for (NSDictionary * oneClip in [trackData valueForKey:@"track"])
    {
      //  AVAsset *videoAsset =
        
        WOO_AVURLAsset * asset = [WOO_AVURLAsset assetWithURL:[NSURL fileURLWithPath:[oneClip valueForKey:@"filePath"]]];
        asset.UIID = [oneClip valueForKey:@"uniqueId"];
        NSString * filePathString;
        if (!useProxy||![[asset tracksWithMediaType:AVMediaTypeVideo] count] )
           filePathString = [oneClip valueForKey:@"filePath"];
        else
        {
           BOOL proxyExists =  [[NSFileManager defaultManager]fileExistsAtPath:[NSString stringWithFormat:@"%@%@PROXY.MP4",NSTemporaryDirectory(),[self generateMD5Hash:[oneClip valueForKey:@"filePath"]]]];
            if (proxyExists)
            filePathString =  [NSString stringWithFormat:@"%@%@PROXY.MP4",NSTemporaryDirectory(),[self generateMD5Hash:[oneClip valueForKey:@"filePath"]]];
            else
                 filePathString = [oneClip valueForKey:@"filePath"];
                
            
            
        }
        
        
    //    filePathString=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filePathString.lastPathComponent];
       // filePathString=[@"https://s3.eu-central-1.amazonaws.com/teewow2016/footage/" stringByAppendingPathComponent:filePathString.lastPathComponent];
        // filePathString=[@"/Users/Igor/Documents/band/" stringByAppendingPathComponent:filePathString.lastPathComponent];
        float offset=[[oneClip valueForKey:@"groupOffset"] floatValue];
        BOOL negativeOffset = NO;
        if (offset<0)
        {
            negativeOffset = YES;
         currentCMTime=CMTimeMakeWithSeconds(offset*-1,1000);
        
        }
        else
        currentCMTime=CMTimeMakeWithSeconds(offset,1000);
        
        NSURL * fileUrl=[NSURL fileURLWithPath:filePathString];
      //  NSURL * fileUrl=[NSURL URLWithString:filePathString];
      //  NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
      //  AVURLAsset * asset =[AVURLAsset assetWithURL:fileUrl];
         asset=[WOO_AVURLAsset URLAssetWithURL:fileUrl options:nil];
         asset.UIID = [oneClip valueForKey:@"uniqueId"];
        
    //  asset =   [AVURLAsset assetWithURL:fileUrl];
        assert(asset);
        AVAssetTrack *videoAssetTrack;
        AVAssetTrack *audioAssetTrack;
        
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0)
        {
          NSError * error;
            if (!mutableCompositionVideoTrack)
            mutableCompositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//            if (mutableCompositionVideoTrack.timeRange.duration.value)
//            { float test2 = (mutableCompositionVideoTrack.timeRange.duration.value/mutableCompositionVideoTrack.timeRange.duration.timescale);
//            float test3 = (currentCMTime.value/currentCMTime.timescale);
//            }
            if (mutableCompositionVideoTrack.timeRange.duration.value)
           if (ABS(ABS(currentCMTime.value/currentCMTime.timescale)-ABS(mutableCompositionVideoTrack.timeRange.duration.value/mutableCompositionVideoTrack.timeRange.duration.timescale))<0.1&&!negativeOffset)
               currentCMTime = mutableCompositionVideoTrack.timeRange.duration;
          globalData * data = [globalData sharedManager];
        videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            
            [data.assetTracks addObject:videoAssetTrack];
           [ [NSUserDefaults standardUserDefaults] setObject:[oneClip valueForKey:@"uniqueId"] forKey:[@(videoAssetTrack.trackID) stringValue]];
            [ [NSUserDefaults standardUserDefaults] synchronize];
             CMTimeRange test = CMTimeRangeMake(kCMTimeZero,videoAssetTrack.timeRange.duration);
            CMTimeRange sourceRange = videoAssetTrack.timeRange;
            if (negativeOffset)
            sourceRange = CMTimeRangeMake(currentCMTime, CMTimeSubtract(videoAssetTrack.timeRange.duration, currentCMTime));
            CMTime insertTime = currentCMTime;
            if (negativeOffset)
                insertTime = kCMTimeZero;
            [mutableCompositionVideoTrack insertTimeRange:sourceRange ofTrack:videoAssetTrack atTime:insertTime error:&error];
            NSLog(@"inserting VIDEOclip:%@ in track at position:%lld",filePathString.lastPathComponent,currentCMTime.value/currentCMTime.timescale);
            assert(!error);
        }
        
         if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0)
         {
             NSError * error;
             if (!mutableCompositionAudioTrack)
           mutableCompositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
              globalData * data = [globalData sharedManager];
                audioAssetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
              [data.assetTracks addObject:audioAssetTrack];
             CMTimeRange sourceRange = audioAssetTrack.timeRange;
             if (negativeOffset)
                sourceRange = CMTimeRangeMake(currentCMTime, CMTimeSubtract(audioAssetTrack.timeRange.duration, currentCMTime));
             CMTime insertTime = currentCMTime;
             if (negativeOffset)
                 insertTime = kCMTimeZero;

             
             
         
             [mutableCompositionAudioTrack insertTimeRange:sourceRange ofTrack:audioAssetTrack atTime:insertTime error:&error];
                NSLog(@"inserting AUDIOclip:%@ in track at position:%lld",filePathString.lastPathComponent,currentCMTime.value/currentCMTime.timescale);
         }
        
      
        
        
        
      
    }
 

    
    
    
    
    
    return [mutableComposition mutableCopy] ;
    
}
+(void) insertAudioTracksinMainComposition:(AVComposition*) sourceComposition intoMasterComposition:(AVMutableComposition*) destinationComposition
{
    NSArray * videoTracks = [sourceComposition tracksWithMediaType:AVMediaTypeVideo];
    NSArray * audioTracks = [sourceComposition tracksWithMediaType:AVMediaTypeAudio];
    
    NSMutableArray * newlyCReatedTracks = [NSMutableArray new];
    
    
    
    
    for (int i=0;i<audioTracks.count;i++)
    {
        AVMutableCompositionTrack *mutableCompositionAudioTrack = [destinationComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        NSError * error;
        AVMutableCompositionTrack * sourceTrack = audioTracks[i] ;
        //  int sourceDur =  sourceTrack.timeRange.duration.value/sourceTrack.timeRange.duration.timescale;
        [mutableCompositionAudioTrack insertTimeRange:[sourceTrack timeRange] ofTrack:sourceTrack atTime:kCMTimeZero  error:&error];
        
        //      int destDur =  mutableCompositionVideoTrack.timeRange.duration.value/mutableCompositionVideoTrack.timeRange.duration.timescale;
        
        
        int masterDur = destinationComposition.duration.value/destinationComposition.duration.timescale;
        int masterCompTrackCOunt = destinationComposition.tracks.count;
        [newlyCReatedTracks addObject:mutableCompositionAudioTrack];

        
        
    }
    
    
    
}

+(void) insertVideoTracksinMainComposition:(AVComposition*) sourceComposition intoMasterComposition:(AVMutableComposition*) destinationComposition

{
    
     NSArray * videoTracks = [sourceComposition tracksWithMediaType:AVMediaTypeVideo];
     NSArray * audioTracks = [sourceComposition tracksWithMediaType:AVMediaTypeAudio];
    
    NSMutableArray * newlyCReatedTracks = [NSMutableArray new];
    
    
    
    
    for (int i=0;i<videoTracks.count;i++)
    {
        AVMutableCompositionTrack *mutableCompositionVideoTrack = [destinationComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        NSError * error;
        AVMutableCompositionTrack * sourceTrack = videoTracks[i] ;
      //  int sourceDur =  sourceTrack.timeRange.duration.value/sourceTrack.timeRange.duration.timescale;
        [mutableCompositionVideoTrack insertTimeRange:[sourceTrack timeRange] ofTrack:sourceTrack atTime:kCMTimeZero  error:&error];
        
   //      int destDur =  mutableCompositionVideoTrack.timeRange.duration.value/mutableCompositionVideoTrack.timeRange.duration.timescale;
        
      
        int masterDur = destinationComposition.duration.value/destinationComposition.duration.timescale;
        int masterCompTrackCOunt = destinationComposition.tracks.count;
        [newlyCReatedTracks addObject:mutableCompositionVideoTrack];
        
    
    }
    
    
    
    
    
    
    
    
}

+(void) positionTracksOnScreenFromMainComposition:(AVMutableComposition*) mainComposition
{
    
    

    
    
    
    
    
    
    
}
+(AVMutableAudioMix*) createAudioMixWithMainComp:(AVMutableComposition*) masterComp withTracks:(NSArray*) shownTracks  sourceController:(id) sourceController
{
    
//    AVAssetTrack *audioTrack = [[self.player.currentItem.asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
//    AVMutableAudioMixInputParameters *params = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
//    [params setVolumeRampFromStartVolume:1.0 toEndVolume:0.5 timeRange:CMTimeRangeMake(CMTimeMake(5,1), CMTimeMake(2,1))];
//    
//    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
//    audioMix.inputParameters = [NSArray arrayWithObject:params];
    
    NSArray * audioTracks = [masterComp tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray * parametars = [NSMutableArray new];
    
    for (int i=0;i<shownTracks.count;i++)
    {
        
        AVMutableCompositionTrack * oneTrack = [audioTracks  objectAtIndex:[shownTracks[i] intValue]];
        AVMutableAudioMixInputParameters *oneParam = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:oneTrack];
        [oneParam setVolume:0.0 atTime:kCMTimeZero];
        [parametars addObject:oneParam];
        
       
    }
     AVMutableAudioMix* audioMix=[AVMutableAudioMix audioMix];
    
    audioMix.inputParameters = parametars;
  
    
    return audioMix;
}
+(AVMutableVideoComposition*) createVideoCompWithMainComp2:(AVMutableComposition*) masterComp withTracks:(NSArray*) shownTracks  sourceController:(id) sourceController
{
    NSViewController * vc  = (NSViewController*) sourceController;
    NSSize device_Size = vc.view.frame.size;
    
    if (!shownTracks.count)
    {
        NSMutableArray *alltracksareshown=[NSMutableArray new];
        int numberoftotaltracks = [[masterComp tracksWithMediaType:AVMediaTypeVideo] count];
        for (int i=0;i<numberoftotaltracks;i++)
            [alltracksareshown addObject:@(i)];
        shownTracks = alltracksareshown;
    }
    
    //  parentFrameSize = device_Size;
    AVMutableVideoComposition * videoComposition = [AVMutableVideoComposition videoComposition];
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    NSMutableArray * layerInstructionsArray=[NSMutableArray new];
    CGSize parentFrameSize = [sourceController view].frame.size;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    float extrasize = (float)(shownTracks.count%9)*(float)(0.5);
    CGSize compSize=CGSizeMake(device_Size.width, device_Size.height);
    videoComposition.renderSize = compSize;
    playController * castedPlayController =(playController *)sourceController;
    NSView *v = [castedPlayController.parentViewController.view viewWithTag:1000];
    // v.frame = CGRectMake(0, 0, videoComposition.renderSize.width,videoComposition.renderSize.height);
    
    
    
    CMTime longestTrack = kCMTimeZero;
    
  //  if (shownTracks.count<=9)
    {
        
        NSArray * positionsX = @[@0,
                                 
                                 @(device_Size.width/4),
                                 @((device_Size.width/4)*2),
                                 @((device_Size.width/4)*3),
                                 
                                 @0,
                                 
                                 @(device_Size.width/4),
                                 @((device_Size.width/4)*2),
                                 @((device_Size.width/4)*3),
                                 
                                 
                                 @0,
                                 
                                 @(device_Size.width/4),
                                 @((device_Size.width/4)*2),
                                 @((device_Size.width/4)*3),
                                 
                                 @0,
                                 
                                 @(device_Size.width/4),
                                 @((device_Size.width/4)*2),
                                 @((device_Size.width/4)*3)
                                 
                                 
                                 ];
        
        NSArray * positionsY = @[
                                  @((device_Size.height/4*3)),
                                 @((device_Size.height/4*3)),
                                 @((device_Size.height/4*3)),
                                 @((device_Size.height/4*3)),

                                 @((device_Size.height/4*2)),
                                 @((device_Size.height/4*2)),
                                 @((device_Size.height/4*2)),
                                 @((device_Size.height/4*2)),
                                 
                                  @(device_Size.height/4),
                                 @(device_Size.height/4),
                                 @(device_Size.height/4),
                                 @(device_Size.height/4),
                                 
                                 @0,
                                 @0,
                                 @0,
                                 @0,
                                 ];
        
        
        //        NSArray * positionsX = @[@0,@(device_Size.width/3),@0,@(device_Size.width/3),@0,@(device_Size.width/3),@((device_Size.width/3)*2),@((device_Size.width/3)*2),@((device_Size.width/3)*2)];
        //        NSArray * positionsY = @[@0,@0,@(device_Size.height/3),@(device_Size.height/3),@((device_Size.height/3*2)),@((device_Size.height/3*2)),@((device_Size.height/3*2))];
        CGRect touchregion;
        NSArray * videoTracks = [masterComp tracksWithMediaType:AVMediaTypeVideo];
        NSArray * audioTracks = [masterComp tracksWithMediaType:AVMediaTypeAudio];
        for (int i=0;i<audioTracks.count;i++)
        {
              AVMutableCompositionTrack * oneTrack = [audioTracks  objectAtIndex:i];
            if (CMTimeCompare(oneTrack.timeRange.duration,longestTrack)==1)
            {
                longestTrack = oneTrack.timeRange.duration;
            }

        }
        
        
        
        for (int i=0;i<shownTracks.count;i++)
        {
            
            AVMutableCompositionTrack * oneTrack = [videoTracks  objectAtIndex:[shownTracks[i] intValue]];
            //            -1 is returned if time1 is less than time2.
            //
            //                1 is returned if time1 is greater than time2.
            //
            //                    0 is returned if time1 and time2 are equal.
            
            //    NSLog(@"track duration:%lld",oneTrack.timeRange.duration.value/oneTrack.timeRange.duration.timescale);
            
            if (CMTimeCompare(oneTrack.timeRange.duration,longestTrack)==1)
            {
                longestTrack = oneTrack.timeRange.duration;
            }
            
            
            for (AVCompositionTrackSegment * oneSegment in oneTrack.segments)
            {
                NSLog(@"next segment..");
                if (!oneSegment.isEmpty)
                {
                    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:oneTrack];
                    // [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstruction];
                    
                    //  NSLog(@"segment size:%f %f",oneTrack.naturalSize.width,oneTrack.naturalSize.height);
                    // NSLog(@"makeScale( %f  +%f , %f ,%f ,%f",device_Size.width/2,(device_Size.width/2)/oneTrack.naturalSize.width,(device_Size.height/2)/oneTrack.naturalSize.height);
                    CGAffineTransform Scale = CGAffineTransformMakeScale((device_Size.width/4)/oneTrack.naturalSize.width,(device_Size.height/4)/oneTrack.naturalSize.height);
                    // CGAffineTransform Scale = CGAffineTransformMakeScale(0.5, 0.5);
                    CGAffineTransform Move = CGAffineTransformMakeTranslation([positionsX[i] floatValue],[positionsY[i] floatValue]);
                    touchregion = CGRectMake([positionsX[i] floatValue],[positionsY[i] floatValue], parentFrameSize.width/4, parentFrameSize.height/4);
                    [layerInstruction setOpacity:1 atTime:kCMTimeZero];
                    
                    [layerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
                    [layerInstructionsArray addObject:layerInstruction];
                }
                
            }
            playController * castedPlayController =(playController *)sourceController;
            [[castedPlayController regionsForTracks] addObject:[NSValue valueWithRect:touchregion]];
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    MainInstruction.layerInstructions=layerInstructionsArray;
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,longestTrack) ;
    //  NSLog(@"comp duration:%lld",longestTrack.value/longestTrack.timescale);
    videoComposition.instructions = [NSArray arrayWithObject:MainInstruction];
    
    
    
    return videoComposition;
}
+(AVMutableVideoComposition*) createVideoCompWithMainComp:(AVMutableComposition*) masterComp withTracks:(NSArray*) shownTracks  sourceController:(id) sourceController
{
    NSViewController * vc  = (NSViewController*) sourceController;
    NSSize device_Size = vc.view.frame.size;
    
    if (!shownTracks.count)
    {
        NSMutableArray *alltracksareshown=[NSMutableArray new];
        int numberoftotaltracks = [[masterComp tracksWithMediaType:AVMediaTypeVideo] count];
        for (int i=0;i<numberoftotaltracks;i++)
             [alltracksareshown addObject:@(i)];
        shownTracks = alltracksareshown;
    }
  
  //  parentFrameSize = device_Size;
    AVMutableVideoComposition * videoComposition = [AVMutableVideoComposition videoComposition];
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    NSMutableArray * layerInstructionsArray=[NSMutableArray new];
    CGSize parentFrameSize = [sourceController view].frame.size;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    float extrasize = (float)(shownTracks.count%9)*(float)(0.5);
    CGSize compSize=CGSizeMake(device_Size.width, device_Size.height);
    videoComposition.renderSize = compSize;
    playController * castedPlayController =(playController *)sourceController;
    NSView *v = [castedPlayController.parentViewController.view viewWithTag:1000];
   // v.frame = CGRectMake(0, 0, videoComposition.renderSize.width,videoComposition.renderSize.height);
   

  
     CMTime longestTrack = kCMTimeZero;
    
 //   if (shownTracks.count<=9)
    {
      
        NSArray * positionsX = @[@0,
                                 
                                 @(device_Size.width/4),
                                 @((device_Size.width/4)*2),
                                 @((device_Size.width/4)*3),
                                 
                                 @0,
                                 
                                 @(device_Size.width/4),
                                 @((device_Size.width/4)*2),
                                 @((device_Size.width/4)*3),
                                 
                                 
                                 @0,
                                 
                                 @(device_Size.width/4),
                                 @((device_Size.width/4)*2),
                                 @((device_Size.width/4)*3),
                                 
                                 @0,
                                 
                                 @(device_Size.width/4),
                                 @((device_Size.width/4)*2),
                                 @((device_Size.width/4)*3)
                                 
                                 
                                 ];
        
        NSArray * positionsY = @[
                                 @((device_Size.height/4*3)),
                                 @((device_Size.height/4*3)),
                                 @((device_Size.height/4*3)),
                                 @((device_Size.height/4*3)),
                                 
                                 @((device_Size.height/4*2)),
                                 @((device_Size.height/4*2)),
                                 @((device_Size.height/4*2)),
                                 @((device_Size.height/4*2)),
                                 
                                 @(device_Size.height/4),
                                 @(device_Size.height/4),
                                 @(device_Size.height/4),
                                 @(device_Size.height/4),
                                 
                                 @0,
                                 @0,
                                 @0,
                                 @0,
                                 ];
        
                                 //        NSArray * positionsX = @[@0,@(device_Size.width/3),@0,@(device_Size.width/3),@0,@(device_Size.width/3),@((device_Size.width/3)*2),@((device_Size.width/3)*2),@((device_Size.width/3)*2)];
//        NSArray * positionsY = @[@0,@0,@(device_Size.height/3),@(device_Size.height/3),@((device_Size.height/3*2)),@((device_Size.height/3*2)),@((device_Size.height/3*2))];
        CGRect touchregion;
         NSArray * videoTracks = [masterComp tracksWithMediaType:AVMediaTypeVideo];
         NSArray * audioTracks = [masterComp tracksWithMediaType:AVMediaTypeAudio];
        for (int i=0;i<shownTracks.count;i++)
        {
           
            AVMutableCompositionTrack * oneTrack = [videoTracks  objectAtIndex:[shownTracks[i] intValue]];
//            -1 is returned if time1 is less than time2.
//                
//                1 is returned if time1 is greater than time2.
//                    
//                    0 is returned if time1 and time2 are equal.
            
         //    NSLog(@"track duration:%lld",oneTrack.timeRange.duration.value/oneTrack.timeRange.duration.timescale);
            
            if (CMTimeCompare(oneTrack.timeRange.duration,longestTrack)==1)
            {
                longestTrack = oneTrack.timeRange.duration;
            }
           
          
            for (AVCompositionTrackSegment * oneSegment in oneTrack.segments)
            {
                NSLog(@"next segment..");
                if (!oneSegment.isEmpty)
                {
                 AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:oneTrack];
                   // [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstruction];
                
              //  NSLog(@"segment size:%f %f",oneTrack.naturalSize.width,oneTrack.naturalSize.height);
               // NSLog(@"makeScale( %f  +%f , %f ,%f ,%f",device_Size.width/2,(device_Size.width/2)/oneTrack.naturalSize.width,(device_Size.height/2)/oneTrack.naturalSize.height);
             CGAffineTransform Scale = CGAffineTransformMakeScale((device_Size.width/4)/oneTrack.naturalSize.width,(device_Size.height/4)/oneTrack.naturalSize.height);
               // CGAffineTransform Scale = CGAffineTransformMakeScale(0.5, 0.5);
            CGAffineTransform Move = CGAffineTransformMakeTranslation([positionsX[i] floatValue],[positionsY[i] floatValue]);
                    touchregion = CGRectMake([positionsX[i] floatValue],[positionsY[i] floatValue], parentFrameSize.width/4, parentFrameSize.height/4);
                    [layerInstruction setOpacity:1 atTime:kCMTimeZero];
                
            [layerInstruction setTransform:CGAffineTransformConcat(Scale,Move) atTime:kCMTimeZero];
           [layerInstructionsArray addObject:layerInstruction];
                }
                
            }
            playController * castedPlayController =(playController *)sourceController;
            [[castedPlayController regionsForTracks] addObject:[NSValue valueWithRect:touchregion]];
        
            
        }
        
        
        
        
        
    }
    
   
    
    
     MainInstruction.layerInstructions=layerInstructionsArray;
     MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,longestTrack) ;
  //  NSLog(@"comp duration:%lld",longestTrack.value/longestTrack.timescale);
     videoComposition.instructions = [NSArray arrayWithObject:MainInstruction];
    
    
    
    return videoComposition;
}

+(AVMutableComposition*) exportMusicVideoMontageSequence:(NSMutableArray*) edits forMainComp:(AVMutableComposition*) mainComp
{
    AVMutableComposition * editedCOMP = [AVMutableComposition composition];
   
   //  AVMutableCompositionTrack *mutableCompositionVideoTrackTITLE = [editedCOMP addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
     AVMutableCompositionTrack *mutableCompositionVideoTrack = [editedCOMP addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
       AVMutableCompositionTrack *mutableCompositionAudioTrack = [editedCOMP addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack * audioTrack = [[mainComp tracksWithMediaType:AVMediaTypeAudio] firstObject];
    for (int i=0;i<edits.count-1;i++)
    {
          NSDictionary * startDict = edits[i];
          NSDictionary *  endDict = edits[i+1];
        
        AVCompositionTrack * sourceTrack = [[mainComp tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:[startDict[@"trackId"] intValue] ];
        CMTime startTime = [startDict[@"time"] CMTimeValue];
          CMTime endTime = [endDict[@"time"] CMTimeValue];
      CMTimeRange sourceRange =  CMTimeRangeFromTimeToTime(startTime, endTime);
        
        NSError * error;
        [mutableCompositionVideoTrack insertTimeRange:sourceRange ofTrack:sourceTrack atTime:startTime  error:&error];
         NSLog(@"take from sourcefrom:%@ end:%@ and insert in destination track at time:%f, with duration:%f new destinationtrackduration:%f",startDict[@"time"],endDict[@"time"],CMTimeGetSeconds(startTime),CMTimeGetSeconds(sourceRange.duration), CMTimeGetSeconds( mutableCompositionVideoTrack.timeRange.duration));
        
    }
     CMTimeRange y = mutableCompositionVideoTrack.timeRange;
    if (audioTrack)
    {    NSError * error;
        CMTimeRange y = audioTrack.timeRange;
     //   NSLog(@"%@",y.duration);
    [mutableCompositionAudioTrack insertTimeRange:audioTrack.timeRange  ofTrack:audioTrack atTime:audioTrack.timeRange.start  error:&error];
        NSLog(@"done.");
    }
    CMTimeRange ya = mutableCompositionAudioTrack.timeRange;
    
    CMTime er = editedCOMP.duration;
//    NSString *strtitle=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"alpha.mov"];
//    AVAsset * titleAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:strtitle]];
//    NSError * errortitle;
//    AVAssetTrack * videoTrackTITLE = [[titleAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//    [mutableCompositionVideoTrackTITLE insertTimeRange:videoTrackTITLE.timeRange   ofTrack:videoTrackTITLE  atTime:kCMTimeZero  error:&errortitle];
    
    
    
    return editedCOMP;
  

    
}

+ (NSString *)generateMD5Hash:(NSString *)string{
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

+(void) addtitle:(NSString*) artistname songName:(NSString*)songname releaseDate:(NSString*) releasedate albumName:(NSString*) albumName forVideoComposition:(AVMutableVideoComposition*) videoComp fromMainComposition:(AVMutableComposition*) mainComp
{
    if (!videoComp)
    {
    videoComp = [AVMutableVideoComposition videoComposition];
        videoComp.renderSize = mainComp.naturalSize;
        videoComp.frameDuration = [[mainComp tracksWithMediaType:AVMediaTypeVideo] firstObject].minFrameDuration;
    }
   
    NSSize size = videoComp.renderSize;
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:100];
    [subtitle1Text setFrame:CGRectMake(0, 0, size.width, 200)];
    [subtitle1Text setString:songname];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[NSColor whiteColor] CGColor]];
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
   
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];

    
  
}
+(AVMutableVideoComposition*) addImageOverLayToMainCompwithVideoComp:(AVMutableVideoComposition*) videoComp image:(NSImage*) image
{
       // create the image somehow, load from file, draw into it...
    CGImageSourceRef source;
    
    source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CALayer *overlayLayer = [CALayer layer];
    NSImage *overlayImage = image;
    NSSize size = videoComp.renderSize;
    
    [overlayLayer setContents:(__bridge id _Nullable)(maskRef)];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    // 2 - set up the parent layer
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
   // parentLayer.position =
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    // 3 - apply magic
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    return videoComp;
    
    
}
+(void) showToasMsg:(NSString*)msg inView:(NSView*) view forDuration:(float) duration
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [DJProgressHUD showStatus:msg FromView:view];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [DJProgressHUD dismiss];
//        });
//    });
   
    
    
    
}

+(void) moveMouseToLocationX:(float) x Y:(float)y andClickIt:(BOOL) toclick
{
    CGEventRef move1 = CGEventCreateMouseEvent(
                                               NULL, kCGEventMouseMoved,
                                               CGPointMake(x, y),
                                               kCGMouseButtonLeft // ignored
                                               );
    
    
    CGEventRef click1_down = CGEventCreateMouseEvent(
                                                     NULL, kCGEventLeftMouseDown,
                                                     CGPointMake(x, y),
                                                     kCGMouseButtonLeft
                                                     );
    
    
    CGEventRef click1_up = CGEventCreateMouseEvent(
                                                   NULL, kCGEventLeftMouseUp,
                                                   CGPointMake(x, y),
                                                   kCGMouseButtonLeft
                                                   );
    
   CGEventPost(kCGHIDEventTap, move1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGEventPost(kCGHIDEventTap, click1_down);
        CGEventPost(kCGHIDEventTap, click1_up);

    });
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         CFRelease(move1);
        CFRelease(click1_up);
        CFRelease(click1_down);
    });
   
    
}

+(void) verifyFULLFEATUREDSubscriptionWithServer:(BlockHandler_Bool)block
{
    
//    [doo showProgressWithMsg:@"Checking subscription..."];
//    PFUser * user = [PFUser currentUser];
//    [user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//        [DJProgressHUD dismiss];
//      
//        float currentTime = [NSDate timeIntervalSinceReferenceDate]*1000;
//        float startDate = [user[@"startDate"] floatValue];
//        float endDate = [user[@"endDate"] floatValue];
//        if (currentTime>=startDate&&currentTime<endDate)
//        {
//            
//            if (endDate-currentTime<(60000*60*24*7))
//            {
//                
//                [(AppDelegate *)[NSApp delegate] subscribeNow];
//
//                
//                
//            }
////
//            
//             
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"demo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"demoCheck" object:nil];
//            [doo showProgressWithMsg:@"Subscription verified."];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [DJProgressHUD dismiss];
//                
//                block(YES);
//            });
//        
//        }
//        else
//        {
//            [PFUser logOut];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"demo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"demoCheck" object:nil];
//            [doo showProgressWithMsg:@"Subscription can't be verified!"];
//           
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [DJProgressHUD dismiss];
//                
//                  block(NO);
//            });
//            
//        }
//        
//        
//    }];
//    
//    
//
    
    
}

+(BOOL) subscriptionOKLocal
{
    return  ![[NSUserDefaults standardUserDefaults] boolForKey:@"demo"];
 
}

//+(void) showProgressWithMsg:(NSString*) msg
//{
//    NSApplication *myApp = [NSApplication sharedApplication];
//    
//    NSWindow *myWindow = [myApp keyWindow];
//    dispatch_async(dispatch_get_main_queue(), ^{
//       [DJProgressHUD showStatus:msg FromView:myWindow.contentView];
//    });
// 
//   
//    
//    
//}
+(void) addWatermarkToVideoFile:(NSString*) filePath image:(NSImage*) watermarkImage delegate:(playController*) delegate
{
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
     AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];

    //If you need audio as well add the Asset Track for audio here
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipVideoTrack atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
     [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
     CGSize videoSize = [videoAsset naturalSize];
    NSImage *myImage = watermarkImage;
    myImage = [self imageResize:myImage newSize:videoSize];
    CALayer *aLayer = [CALayer layer];
    CGRect imageRect = CGRectMake(0, 0, myImage.size.width, myImage.size.height);
    CGImageRef    cgImage = [myImage CGImage];
   // cgImage = [myImage CGImageForProposedRect:imageRect context:nil hints:nil];
    aLayer.contents = CFBridgingRelease(cgImage);
    
    CGSize size = [videoAsset naturalSize];
    aLayer.frame = CGRectMake(0, 0, size.width, size.height);
    //Needed for proper display. We are using the app icon (57x57). If you use 0,0 you will not see it
    aLayer.opacity = 0.65; //Feel free to alter the alpha here
   
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:aLayer];
    
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
    videoComp.frameDuration = CMTimeMake(1, 30);
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
    /// instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    
    
    videoComp.instructions = [NSArray arrayWithObject: instruction];
    
    
    assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    
    //AVAssetExportPresetPassthrough
    NSDictionary * userInfo = @{@"exportSession":assetExport};
    
    dispatch_async(dispatch_get_main_queue(), ^{
        delegate.progressStart = 0.50;
    delegate.exportProgressBarTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:delegate selector:@selector(updateExportDisplay:) userInfo:userInfo repeats:YES];
    });
    assetExport.videoComposition = videoComp;
    
    NSString* videoName = @"mynewwatermarkedvideo.mov";
    
    
    
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    
    NSURL *   exportUrl = [NSURL fileURLWithPath:exportPath];
    
    
    
    
    NSString  * outUrlString = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[[[[filePath lastPathComponent]  stringByDeletingPathExtension] stringByAppendingString:@"-WATERMARKED"] stringByAppendingString:@".MOV"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
 
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    assetExport.outputURL = [NSURL fileURLWithPath:outUrlString];
    
    assetExport.shouldOptimizeForNetworkUse = YES;
    
   // [strRecordedFilename setString: exportPath];
 //   [assetExport addObserver:delegate forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:NULL];
    [assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         NSError * error;
         [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//         if (error.code != NSFileNoSuchFileError) {
//             [doo showProgressWithMsg:@"ERROR. PLEASE RESTART THE APP!"];
//             NSLog(@"%@", error);
//         }
       //  else
         {
//             [DJProgressHUD dismiss];
             [doo showProgressWithMsg:@"Export finished! You file is saved!"];
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                 [DJProgressHUD dismiss];
//             });
             
             NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
             [workspace openFile:outUrlString];
         }
         
         //YOUR FINALIZATION CODE HERE
     }
     ];
}

+ (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize {
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

//+(void) uploadSerials
//{
//    for (int i=0;i<29;i++)
//    {
//    PFObject *serials=[PFObject objectWithClassName:@"serials"];
//    serials[@"serial"] = [self randomStringWithLength:10];
//    [serials saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        
//    }];
//    }
//    
//}


//+(NSString *) randomStringWithLength: (int) len {
//    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//    
//    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
//    
//    for (int i=0; i<len; i++) {
//        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
//    }
//    
//    return randomString;
//}
+(BOOL)connected2internet
{
    BOOL bRet = FALSE;
    const char *hostName = [@"google.com" cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkConnectionFlags flags = 0;
    
    if (SCNetworkCheckReachabilityByName(hostName, &flags) && flags > 0)
    {
        if (flags == kSCNetworkFlagsReachable)
        {
            bRet = TRUE;
        }
        else
        {
        }
    }
    else
    {
    }
    return bRet;
}
+(NSArray *) detectFacesInImage:(CIImage*)myImage
{
  //  CIImage * myImage = [self ciImagefromNSImage:myNSImage];
    CIContext *context = [CIContext contextWithOptions:nil];                    // 1
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };      // 2
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:opts];                    // 3
    
  //  opts = @{ CIDetectorImageOrientation :
              //    [[myImage properties] valueForKey:kCGImagePropertyOrientation] }; // 4
    NSArray *features = [detector featuresInImage:myImage options:nil];
  if ([features count])
  {
      CGRect faceRect;
      
      for (CIFaceFeature *feature in features)
      {
          faceRect= [feature bounds];
          NSLog(@"ok");
      }
      
  }
    return features;
    // 5
}
+(CIImage*)ciImagefromNSImage:(NSImage*)image
{
    NSData  * tiffData = [image TIFFRepresentation];
    NSBitmapImageRep * bitmap;
    bitmap = [NSBitmapImageRep imageRepWithData:tiffData];
    CIImage * ciImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
    return ciImage;
}
+(AVAssetTrack*) findAssetWIthTrackId:(CMPersistentTrackID)trackId
{
    AVAssetTrack* res = nil;
    globalData * data = [globalData sharedManager];
    for (int i=0;i<data.assetTracks.count;i++)
    {
        AVAssetTrack * track = data.assetTracks[i];
        if (track.trackID==trackId)
            res = track;
        
        
        
    }
    return res;
    
}


+(AVMutableCompositionTrack*) isthereanemptyTracktoPasteHere:(AVMutableComposition*)masterComp atTime:(CMTime) currentTime forRange:(CMTimeRange) timeRange
{
    
    AVMutableCompositionTrack* res= nil;
    
    
    
 
    
    for (AVMutableCompositionTrack * track in [masterComp tracksWithMediaType:AVMediaTypeVideo])
        
    {
      //  if ([track.mediaType  isEqual: @"AVMediaTypeVideo"])
        {
            NSMutableArray * segments = [NSMutableArray new];
        for ( AVCompositionTrackSegment * segment in track.segments)
        {
            if (!segment.isEmpty)
               [ segments addObject:segment];
            
            
            
            
            
        }
            BOOL emptySpaceOk=YES;
            for (AVCompositionTrackSegment * segment in segments)
            {
                CMTimeRange rangeToPaste = CMTimeRangeMake(currentTime,timeRange.duration);
                CMTimeRange intersection =  CMTimeRangeGetIntersection(rangeToPaste, segment.timeMapping.target);
                CMTimeRangeShow(intersection);
             if (CMTimeCompare(intersection.duration, kCMTimeZero)!=0)
             {
                 emptySpaceOk = NO;
                 
             }
                
                NSLog(@"");
                
                
                
                
            }
            
            
            if (emptySpaceOk)
            {
                res  = track;
            }
            
            
        
//        AVCompositionTrackSegment * segment1 = [track segmentForTrackTime:currentTime];
//        AVCompositionTrackSegment * segment2 = [track segmentForTrackTime:CMTimeAdd(currentTime, timeRange.duration)];
//        if (!segment1.isEmpty)
//        {
//            
//            
//        }
//        else if (!segment2.isEmpty)
//        {
//            
//            
//            
//        }
        
   
    }
    
    }
    
    return res;
    
}

@end
