//
//  playController.m
//  tewowdemo
//
//  Created by Igor Jovcevski on 4/4/16.
//  Copyright © 2016 Entangle. All rights reserved.
//

#import "playController.h"
#import "doo.h"
#import "AppDelegate.h"
#import "NSImage+ContentMode.h"
#import "customTrackingArea.h"
#import <CoreImage/CoreImage.h>

@implementation playController
@synthesize encoder,defaultfilterSettings,comps,compsPreviewProxy;

-(void) add
{
    
    
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //    _currentCopiedAsset = [NSMutableDictionary new];
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"exportwatermark.png"];
    _watermarkImage = [[NSImage alloc] initWithContentsOfFile:filePath];
    filePath = [documentDir stringByAppendingPathComponent:@"export-subscribe@2x.png"];
    _exportSubscribeAdImage = [[NSImage alloc] initWithContentsOfFile:filePath];
    [doo showToasMsg:@"preparing the multicam view... please wait for few  seconds. " inView:self.view forDuration:5];
    [super viewDidLoad];
    _multiCamPreview = YES;
    self.lastSelectedTimerange = kCMTimeRangeZero;
    self.selections=[NSMutableArray new];
    self.usedFont=[NSFont fontWithName:@"Lucida Grande" size:16.0];;
    self.regionsForTracks=[NSMutableArray new];
    self.allTrackingAreas =[NSMutableArray new];
    NSString * jsn = [NSString stringWithFormat:@"%@data.json",NSTemporaryDirectory()];
    
    comps =   [doo getCompositionsFromFile:jsn proxyIfAvailable:NO];
    compsPreviewProxy =   [doo getCompositionsFromFile:jsn proxyIfAvailable:YES];
    //max tracks limited to 9
    //  self.mainWindow = [[[NSApplication sharedApplication] windows] objectAtIndex:2];
    self.mainWindow = self.view.window;
    //  self.mainWindow = self.playerView.window;
    
    _shouldIUpdateSelectionsRealTime = YES;
    // _enabledTracks = @[@0,@1,@2,@3,@4,@5,@6,@7,@8];
    _enabledTracks = @[];
    if (!_enabledTracks.count)
    {
        NSMutableArray *alltracksareshown=[NSMutableArray new];
        int numberoftotaltracks = [[comps[0] tracksWithMediaType:AVMediaTypeVideo] count];
        for (int i=0;i<MIN(16,numberoftotaltracks);i++)
            [alltracksareshown addObject:@(i)];
        _enabledTracks = alltracksareshown;
    }
    
    _currentVideoTracks = [self getTracksForIds:_enabledTracks fromComp:comps[0]];
    _currentProxyVideoTracks = [self getTracksForIds:_enabledTracks fromComp:compsPreviewProxy[0]];
    AVMutableVideoComposition * videoComp = [doo createVideoCompWithMainComp2:compsPreviewProxy[0] withTracks:_enabledTracks sourceController:self];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:[compsPreviewProxy[0] mutableCopy] ];
    //  item.videoComposition = videoComp;
    
    if (!videoComp.animationTool) {
        item.videoComposition = [videoComp mutableCopy] ;
    }
    _masterVideoComposition = videoComp;
    _masterComposition = comps[0];
    
    //  [self renderComp2:[comps[0] mutableCopy]   videoComp:[videoComp mutableCopy]];
    
    self.previousCentre = CGPointMake(NSMidX(self.playerView.frame), NSMidY(self.playerView.frame));
    self.previousPlayerSize = self.playerView.frame.size;
    self.playerView.player = [AVPlayer playerWithPlayerItem:item];
    //    self.playerView.acceptsTouchEvents = true;
    // self.playerView.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    NSLog(@"render size:%f %f  ", item.videoComposition.renderSize.width, item.videoComposition.renderSize.height);
    AVComposition * comp = comps[0];
    
    NSLog(@"duration:%lld ", comp.duration.value/comp.duration.timescale);
    
    self.playerView.videoGravity = AVLayerVideoGravityResizeAspect;
    [self maketrackingareas];
    self.currentArea = [self.allTrackingAreas firstObject];
    self.selectedArea = [self.allTrackingAreas firstObject];
    
    //    CALayer *viewLayer = [CALayer layer];
    //    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(1, 10, 1, 0.3)]; //RGB plus Alpha Channel
    //    [self.selectedRegionView setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    //    viewLayer.zPosition = 1;
    //    [self.selectedRegionView setLayer:viewLayer];
    //
    //    NSImage * sel = self.selectedRegionView.image;
    
    self.currentArea = [self.allTrackingAreas firstObject];
    self.selectedArea = [self.allTrackingAreas firstObject];
    
    [self setupLink];
    NSImage * img = [NSImage imageNamed:@"rect.png"];
    
    [self.selectedRegionView setImage:img];
    self.selectedRegionView.layer.zPosition=1000;
    self.selectedRegionView.remainingTime=@"-";
    
    
    self.selectedRegionView.textField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, self.selectedRegionView.frame.size.width/1.2, 27)];
    
    [self.selectedRegionView.textField setStringValue:self.selectedRegionView.remainingTime];
    
    [self.selectedRegionView.textField setBezeled:NO];
    [self.selectedRegionView.textField setDrawsBackground:NO];
    [self.selectedRegionView.textField setEditable:NO];
    [self.selectedRegionView.textField setSelectable:NO];
    [self.selectedRegionView.textField setFont:self.usedFont];
    //[textField setTag:1000];
    [self.selectedRegionView addSubview:self.selectedRegionView.textField];
    
    
    
    
    
    
    // [self.playerView.player addObserver:self forKeyPath:@"rate" options:0 context:nil];
    _mode = 0;
    
    _currentPlayerSize = self.view.frame.size;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(copyFilterSettings:)
                                                 name:@"copyFilterSettings"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFilters)
                                                 name:@"showFilters"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(export)
                                                 name:@"export"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pasteFilterSettings:)
                                                 name:@"pasteFilterSettings"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyThisFilterToAllClips:)
                                                 name:@"applyThisFilterToAllClips"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetFilterSettings:)
                                                 name:@"resetFilterSettings"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(previewMode:)
                                                 name:@"previewMode"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(render:)
                                                 name:@"render"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(next:)
                                                 name:@"next"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(previous:)
                                                 name:@"previous"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(play)
                                                 name:@"play"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stop)
                                                 name:@"stop"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(start)
                                                 name:@"start"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(end)
                                                 name:@"end"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"setInPoint" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [_selectedRegionView setInPoint];
        _currentCopiedAsset[@"in"] = [NSValue valueWithCMTime:_selectedRegionView.inPoint];
        
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"setOutPoint" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [_selectedRegionView setOutPoint];
        _currentCopiedAsset[@"out"] = [NSValue valueWithCMTime:_selectedRegionView.outPoint];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"cutClip" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSLog(@"current asset:%@",_currentAssetSourceUrl.path);
        _cutClip = [NSMutableDictionary new];
        
        _cutClip[@"url"] = _currentAssetSourceUrl;
        _currentTime = self.playerView.player.currentTime;
        for (int i=self.selections.count-1;i>=0;i--)
        {
            NSDictionary * selection  = self.selections[i];
            NSLog(@"trackId = %d _currentTrackId = %d",[selection[@"trackId"] intValue],_currentAssetTrackId);
            if (CMTimeRangeContainsTime(_currentAssetTimeRangeInMasterComposition,[selection[@"time"] CMTimeValue])&&[selection[@"trackId"] intValue] ==_currentAssetTrackId)
                [self.selections removeObjectAtIndex:i];
            [self getSelectedAreaForTime:_currentTime];
            
        }
        
        [_currentTrack removeTimeRange:_currentAssetTimeRangeInMasterComposition];
        [_currentTrack insertEmptyTimeRange:_currentAssetTimeRangeInMasterComposition];
        
        [_currentProxyTrack removeTimeRange:_currentAssetTimeRangeInMasterComposition];
        [_currentProxyTrack insertEmptyTimeRange:_currentAssetTimeRangeInMasterComposition];
        AVMutableVideoComposition * videoComp = [doo createVideoCompWithMainComp2:compsPreviewProxy[0] withTracks:_enabledTracks sourceController:self];
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:[compsPreviewProxy[0] mutableCopy] ];
        //  item.videoComposition = videoComp;
        
        if (!videoComp.animationTool) {
            item.videoComposition = [videoComp mutableCopy] ;
        }
        _masterVideoComposition = videoComp;
        _masterComposition = comps[0];
        
        [self.playerView.player replaceCurrentItemWithPlayerItem:item];
        [self.playerView.player seekToTime:_currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
        
        
    }];
    
    
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _timeObserver =    [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
                                                                                queue:dispatch_get_main_queue()
                                                                           usingBlock:^(CMTime time)
                            {
            _currentTime = time;
            if (_shouldIUpdateSelectionsRealTime)
            {  customTrackingArea * t = [self getSelectedAreaForTime:time];
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"timeChanged" object:nil];
            //             if (_editedComposition)
            //                 [self  applyFilterHereForSelection];
            //             [self applyFilterHereForSelection:[self getSelectionForTime:time]];
        }];
        
        
    });
    // [self  windowDidResize:nil];
    
}

-(void) showFilters
{
    
    if (!_multiCamPreview)
        [self performSegueWithIdentifier: @"filterOptions" sender: self];
    else
        [doo showToasMsg:@"You can only view filter options in full screen mode (eye button first left)!" inView:self.view forDuration:3];
    
    
}

-(void) export
{
    //    BOOL demo = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo"];
    //    if (demo)
    //    {
    //        [doo showToasMsg:@"You need to be a subscribed user to use our export functionality!" inView:self.view forDuration:2];
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [(AppDelegate *)[NSApp delegate] subscribeNow];
    //
    //        });
    //
    //
    //    }
    //    else
    //    {
    
    // PFUser* user  = [PFUser currentUser];
    //    [user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
    if ([_selections count])
    {    _editedComposition = [doo exportMusicVideoMontageSequence:_selections forMainComp:_masterComposition];
        // [self applyFilterHereForSelection];
        
    }
    
    //        if ([user[@"WATERMARK"] boolValue])
    //              [(AppDelegate *)[NSApp delegate] showExportSubscription];
    if ([[[_editedComposition tracksWithMediaType:AVMediaTypeVideo] firstObject] segments])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"render" object:nil];
    else
        [doo showToasMsg:@"Export not available! Please prepare edited sequence first by selecting angles." inView:self.view forDuration:5];
    
    //    }];
    
    //  }
    
    
    
    
    
}


-(void) start
{
    [self.playerView.player seekToTime:kCMTimeZero];
    
    
}
-(void) end

{
    
    [self.playerView.player seekToTime:self.playerView.player.currentItem.duration];
    
    
    
    
}
-(void) play
{
    
    [self.playerView.player play];
    
    
}
-(void) stop
{
    [self.playerView.player pause];
     
    
}
-(void)viewDidAppear
{
    [super viewDidAppear];
    [self.view.window makeFirstResponder:self.view];
    _stopOnNextCut = NO;
    
    NSSize size = self.playerView.frame.size;
    [self.selectedRegionView setFrame:NSMakeRect(0, 0, size.width/4, size.height/4) ];
    self.selectedRegionView.layer.zPosition=1;
    //  [self renderComp2:[_masterComposition mutableCopy]   videoComp:_masterVideoComposition];
    self.mainWindow = self.view.window;
    self.mainWindow.delegate=self;
    [self forceWindowResizeWithBLock];
    [self.playerView.player pause];
    
    [self.playerView.player seekToTime:CMTimeMake(self.playerView.player.currentItem.duration.value/10, self.playerView.player.currentItem.duration.timescale)];
    [self.playerView.player play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playerView.player seekToTime:CMTimeMake(self.playerView.player.currentItem.duration.value/10*2, self.playerView.player.currentItem.duration.timescale)];
        [self.playerView.player play];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playerView.player seekToTime:CMTimeMake(self.playerView.player.currentItem.duration.value/10*3, self.playerView.player.currentItem.duration.timescale)];
        [self.playerView.player play];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playerView.player seekToTime:CMTimeMake(self.playerView.player.currentItem.duration.value/10*4, self.playerView.player.currentItem.duration.timescale)];
        [self.playerView.player play];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playerView.player seekToTime:CMTimeMake(self.playerView.player.currentItem.duration.value/10*5, self.playerView.player.currentItem.duration.timescale)];
        [self.playerView.player play];
    });
    // PFUser * user = [PFUser currentUser];
//    BOOL demo1 = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo1"];
//    // if (demo)
//    {
//        if (!demo1)
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.playerView.player seekToTime:kCMTimeZero];
//                [self.playerView.player play];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [doo showToasMsg:@"you can start clicking on angles(playing clips) and that will result in edited sequence!" inView:self.view forDuration:3];
//                    //  user[@"demo1"] = @"1";
//                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"demo1"];
//                    //  [user save];
//                    
//                });
//                BOOL demo2 = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo2"];
//                if (!demo2)
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [doo showToasMsg:@"Clicking ESCPAPE(or the Eye Icon on the left)  will toggle between multicam and Edit Preview! Make sure you go back in time to see your edited sequence!" inView:self.view forDuration:12];
//                        
//                        // user[@"demo2"] = @"1";
//                        //  [user save];
//                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"demo2"];
//                    });
//                BOOL demo3 = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo3"];
//                if (!demo3)
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [doo showToasMsg:@"Did you know that you can go to an edit (COMMAND-LEFT or RIGHT array) and replace a shot by clicking on different angle! (If you're in FULL Screen Edit Preview, you can toggle back to Multicam Mode by pressing the ESCAPE Key!" inView:self.view forDuration:16];
//                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"demo3"];
//                        //             user[@"demo3"] = @"1";
//                        //             [user save];
//                    });
//                
//                
//            });
//    }
    
}

- (void)render:(NSNotification *)notification
{
    
    
    
    NSSavePanel *spanel = [NSSavePanel savePanel];
    NSString *path = @"/Documents";
    [spanel setDirectory:[path stringByExpandingTildeInPath]];
    [spanel setPrompt:NSLocalizedString(@"Render Movie",nil)];
    [spanel setRequiredFileType:@"MOV"];
    [spanel beginSheetForDirectory:NSHomeDirectory()
                              file:@"render_out.mov"
                    modalForWindow:self.playerView.window
                     modalDelegate:self
     
                    didEndSelector:@selector(didEndSaveSheet:returnCode:conextInfo:)
                       contextInfo:NULL];
    
    
    
    
    
    
    
    
    
}
-(void)didEndSaveSheet:(NSSavePanel *)savePanel
            returnCode:(int)returnCode conextInfo:(void *)contextInfo
{
    if (returnCode == NSOKButton){
        NSLog([savePanel filename]);
        [self renderComp2:_editedComposition videoComp:_currentEditedVideoComposition whereToSave:[savePanel filename]];
    }else{
        NSLog(@"Cansel");
    }
}
- (void)previewMode:(NSNotification *)notification
{
    CMTime currentTime = self.playerView.player.currentTime;
    
    
    
    if (_multiCamPreview)
    {
        
        _multiCamPreview = NO;
        _selectedRegionView.hidden=YES;
        _editedComposition = [doo exportMusicVideoMontageSequence:_selections forMainComp:compsPreviewProxy[0]];
        [self.playerView.player removeTimeObserver:self.timeObserver];
        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_editedComposition];
        [self.playerView.player replaceCurrentItemWithPlayerItem:item];
        
        if (_editedComposition)
        {  [self applyFilterHereForSelection];
        }
        //        }
        //        AVVideoComposition * videoComp = [AVVideoComposition videoCompositionWithAsset:_editedComposition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        //            float seconds = CMTimeGetSeconds(request.compositionTime);
        //            CIImage * filtered =[self getMeFiltersforComposition:_editedComposition atTime:request.compositionTime request:request];
        //
        //            [request finishWithImage:filtered context:nil];
        //        }];
        //  item.videoComposition = videoComp;
        
        [self.playerView.player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        NSMutableDictionary * selection  = [self.selections lastObject];
        if (selection)
        {
            if (CMTimeCompare(currentTime, [selection[@"time"] CMTimeValue])==1)
                [ self.playerView.player seekToTime:[selection[@"time"] CMTimeValue]];
            
        }
        
    }
    else{
        
        _multiCamPreview=YES;
        
        
        //   [self.playerView.player removeTimeObserver:self.timeObserver];
        _selectedRegionView.hidden=NO;
        //
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:[compsPreviewProxy[0] mutableCopy] ];
        item.videoComposition = _masterVideoComposition;
        
        
        
        
        _currentTime = self.playerView.player.currentTime;
        [self.playerView.player replaceCurrentItemWithPlayerItem:item];
        
        //
        //        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_masterComposition];
        //        item.videoComposition=_masterVideoComposition;
        [self.playerView.player replaceCurrentItemWithPlayerItem:item];
        
        [self.playerView.player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        customTrackingArea * t = [self getSelectedAreaForTime:currentTime];
        _timeObserver =    [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
                                                                                queue:dispatch_get_main_queue()
                                                                           usingBlock:^(CMTime time)
                            {
            
            customTrackingArea * t = [self getSelectedAreaForTime:time];
            
            
        }];
        
        
        
        
        
    }
    
    
    
    
}
-(CIImage*) getMeFiltersforComposition:(AVMutableComposition*) composition atTime:(CMTime) currentTime request:(AVAsynchronousCIImageFilteringRequest*) request
{
    
    
    CIImage * filtered = [request.sourceImage imageByApplyingFilter:@"CISepiaTone" withInputParameters:@{kCIInputIntensityKey:@0.8}];
    
    return filtered;
    
}

- (void)modeChanged:(NSNotification *)notification
{
    //
    //
    //
    //
    //    CMTime currentTime;
    //    if ([[notification name] isEqualToString:@"modeChanged"]) {
    //        NSDictionary *myDictionary = (NSDictionary *)notification.object;
    //        _mode = [myDictionary[@"mode"] intValue];
    //        NSLog(@"mode changed to %d:",_mode);
    //     currentTime = [self.playerView.player currentTime];
    //
    //    }
    //    if (_mode)
    //    {
    //        _selectedRegionView.hidden=YES;
    //        _editedComposition = [doo exportMusicVideoMontageSequence:_selections forMainComp:_masterComposition];
    //        [self.playerView.player removeTimeObserver:self.timeObserver];
    //        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_editedComposition];
    //        self.playerView.player = [AVPlayer playerWithPlayerItem:item];
    //        [self.playerView.player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    //    }
    //    else
    //    {
    //      //   [self.playerView.player removeTimeObserver:self.timeObserver];
    //        _selectedRegionView.hidden=NO;
    //        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_masterComposition];
    //        item.videoComposition=_masterVideoComposition;
    //        self.playerView.player = [AVPlayer playerWithPlayerItem:item];
    //
    //        [self.playerView.player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    //          customTrackingArea * t = [self getSelectedAreaForTime:currentTime];
    //        _timeObserver =    [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
    //                                                                                queue:dispatch_get_main_queue()
    //                                                                           usingBlock:^(CMTime time)
    //                            {
    //
    //                                customTrackingArea * t = [self getSelectedAreaForTime:time];
    //
    //
    //                            }];
    //
    //
    //
    //
    //    }
    
}


- (void)next:(NSNotification *)notification
{
    [self.playerView.player pause];
    [self.playerView.player seekToTime:[self getNextCutTime] toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    
    
}
- (void)previous:(NSNotification *)notification
{
    [self.playerView.player pause];
    [self.playerView.player seekToTime:[self getPreviousCutTime] toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    
    
}


//- (void)mouseDown:(NSEvent *)event {
//    if ([event type] == NSEventTypeLeftMouseDown) {
//        // Handle right-click event
//        if (_multiCamPreview)
//        {
//
//
//
//        _shouldIUpdateSelectionsRealTime = NO;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            _shouldIUpdateSelectionsRealTime=YES;
//        });
//      //
//
//            if (self.selectedRegionView.trackingArea!=_disabledTrackingArea||!self.selectedRegionView.trackingArea)
//            {
//
//        NSLog(@"clicked");
//        if (self.currentArea.userInfo[@"id"])
//        if (![self isitEmptyTrack:[self.currentArea.userInfo[@"id"] intValue]])
//        {
//        self.selectedArea = (customTrackingArea*)self.currentArea;
//       // [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//         //   context.duration = 0.1;
//           // _selectedRegionView.alphaValue = 1;
//            NSLog(@"mousedown current area id : %@",self.selectedArea.userInfo[@"id"]);
//           self.selectedRegionView.frame =  self.selectedArea.rect;
//            CMTime currentTime = (self.playerView.player.currentTime);
//            NSValue *currentTimeValue = [NSValue valueWithCMTime:currentTime];
//
//            if ([self checkIfBetweenEdits:currentTime ])
//            {
//                _stopOnNextCut = YES;
//
//            }
//
//            [self.selections addObject:[@{@"time":currentTimeValue,@"trackId":self.selectedArea.userInfo[@"id"],@"region":self.selectedArea} mutableCopy] ];
//
//            NSComparator compr = ^NSComparisonResult(NSValue *value1, NSValue *value2) {
//                CMTime cmValue1 = [value1 CMTimeValue];
//                CMTime cmValue2 = [value2 CMTimeValue];
//                NSComparisonResult result = NSOrderedSame;
//                if (CMTimeCompare(cmValue1, cmValue2)==-1) {
//                    result = NSOrderedAscending;
//                } else if (CMTimeCompare(cmValue1, cmValue2)==1) {
//                    result = NSOrderedDescending;
//                }
//                return result;
//            };
//
//            NSSortDescriptor * sortDesc1 = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES comparator:compr];
//            [self.selections sortUsingDescriptors:[NSArray arrayWithObjects:sortDesc1, nil]];
//
//           // [self.selectedRegionView disableTraCkingArea];
//
//            [self.selectedRegionView setLinked:YES];
//            [self.selectedRegionView buttonAction];
//            WOO_AVURLAsset* assetUsed = [WOO_AVURLAsset assetWithURL:self.currentAssetSourceUrl];
//            [self.selectedRegionView setAssetUsedForAngle:assetUsed];
//            NSRect fr = self.selectedArea.rect;
//             self.selectedRegionView.layer.position = CGPointMake(fr.origin.x, fr.origin.y);
//           //  self.selectedRegionView.frame =  self.selectedArea.rect;
//
//           // [self.selectedRegionView disableTraCkingArea];
//
//        }
//    //                        completionHandler:^{
//    //
//    //                           // _selectedRegionView.alphaValue = 1;
//    //
//    //                     //   }];
//    //
//    //
//    //
//    //    }
//        }
//            else  // CLICKED ON DISABLED / AVTIVE ONE
//            {
//                if (self.currentArea.userInfo[@"id"])
//                    if (![self isitEmptyTrack:[self.currentArea.userInfo[@"id"] intValue]])
//                    {
//
//
//
//                    }
//
//
//
//                 _disabledTrackingArea = self.selectedRegionView.trackingArea;
//
//
//
//
//
//            }
//        }
//    }
//}

//- (void) mouseDown: (NSEvent*) theEvent
//{
//
//    [self performSegueWithIdentifier: @"filterOptions" sender: self];
//
//
//
//
//
//
//
//}


- (void)rightMouseDown:(NSEvent *)event {
    if (!_multiCamPreview) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showFilters" object:nil];
    }
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"filterOptions"])
    {
        
        imageCalibrationPopoverController * vc =(imageCalibrationPopoverController *) segue.destinationController;
        
        vc.parentPlayController = self;
        
        
    }
    
    
}

- (NSView *)hitTest:(NSPoint)point {
    return self;
}

- (NSMenu *)menuForEvent:(NSEvent *)event {
    return nil;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}
- (void)mouseDown:(NSEvent *)event {
    
    if (_multiCamPreview)
    {
        
        
        
    _shouldIUpdateSelectionsRealTime = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _shouldIUpdateSelectionsRealTime=YES;
    });
  //
       
        if (self.selectedRegionView.trackingArea!=_disabledTrackingArea||!self.selectedRegionView.trackingArea)
        {
        
    NSLog(@"clicked");
    if (self.currentArea.userInfo[@"id"])
    if (![self isitEmptyTrack:[self.currentArea.userInfo[@"id"] intValue]])
    {
    self.selectedArea = (customTrackingArea*)self.currentArea;
   // [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
     //   context.duration = 0.1;
       // _selectedRegionView.alphaValue = 1;
        NSLog(@"mousedown current area id : %@",self.selectedArea.userInfo[@"id"]);
       self.selectedRegionView.frame =  self.selectedArea.rect;
        CMTime currentTime = (self.playerView.player.currentTime);
        NSValue *currentTimeValue = [NSValue valueWithCMTime:currentTime];
        
        if ([self checkIfBetweenEdits:currentTime ])
        {
            _stopOnNextCut = YES;
   
        }
        
        [self.selections addObject:[@{@"time":currentTimeValue,@"trackId":self.selectedArea.userInfo[@"id"],@"region":self.selectedArea} mutableCopy] ];
        
        NSComparator compr = ^NSComparisonResult(NSValue *value1, NSValue *value2) {
            CMTime cmValue1 = [value1 CMTimeValue];
            CMTime cmValue2 = [value2 CMTimeValue];
            NSComparisonResult result = NSOrderedSame;
            if (CMTimeCompare(cmValue1, cmValue2)==-1) {
                result = NSOrderedAscending;
            } else if (CMTimeCompare(cmValue1, cmValue2)==1) {
                result = NSOrderedDescending;
            }
            return result;
        };
        
        NSSortDescriptor * sortDesc1 = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES comparator:compr];
        [self.selections sortUsingDescriptors:[NSArray arrayWithObjects:sortDesc1, nil]];
        
       // [self.selectedRegionView disableTraCkingArea];
        
        [self.selectedRegionView setLinked:YES];
        [self.selectedRegionView buttonAction];
        WOO_AVURLAsset* assetUsed = [WOO_AVURLAsset assetWithURL:self.currentAssetSourceUrl];
        [self.selectedRegionView setAssetUsedForAngle:assetUsed];
        NSRect fr = self.selectedArea.rect;
         self.selectedRegionView.layer.position = CGPointMake(fr.origin.x, fr.origin.y);
       //  self.selectedRegionView.frame =  self.selectedArea.rect;
       
       // [self.selectedRegionView disableTraCkingArea];

    }
//                        completionHandler:^{
//
//                           // _selectedRegionView.alphaValue = 1;
//
//                     //   }];
//
//
//
//    }
    }
        else  // CLICKED ON DISABLED / AVTIVE ONE
        {
            if (self.currentArea.userInfo[@"id"])
                if (![self isitEmptyTrack:[self.currentArea.userInfo[@"id"] intValue]])
                {
                    
                    
                    
                }
            
            
            
             _disabledTrackingArea = self.selectedRegionView.trackingArea;
            
            
            
            
            
        }
    }
   
}

- (void) mouseEntered:(NSEvent*)theEvent {
  if ([theEvent.trackingArea isKindOfClass:[customTrackingArea class]])
    self.currentArea = (customTrackingArea*)theEvent.trackingArea;
   
 
    
    
}

- (void) mouseExited:(NSEvent*)theEvent {
   
}


-(void)windowDidResize:(NSNotification *)notification

{
    
    NSSize size = self.playerView.frame.size;
    
    NSMutableArray * sections = [NSMutableArray new];
    
    
    NSRect one =   NSMakeRect(0, 0, size.width/4, size.height/4);
    NSRect two =   NSMakeRect(size.width/4,0, size.width/4, size.height/4);
    NSRect three = NSMakeRect((size.width/4)*2,0 , size.width/4, size.height/4);
    NSRect four =  NSMakeRect((size.width/4)*3,0 , size.width/4, size.height/4);
    
    
    
    NSRect five =    NSMakeRect(0, size.height/4, size.width/4, size.height/4);
    NSRect six =     NSMakeRect(size.width/4,size.height/4, size.width/4, size.height/4);
    NSRect seven =   NSMakeRect((size.width/4)*2,size.height/4 , size.width/4, size.height/4);
    NSRect eight =   NSMakeRect((size.width/4)*3,size.height/4 , size.width/4, size.height/4);
    
    
    NSRect nine = NSMakeRect(0, (size.height/4)*2, size.width/4, size.height/4);
    NSRect ten = NSMakeRect(size.width/4,(size.height/4)*2, size.width/4, size.height/4);
    NSRect eleven =  NSMakeRect((size.width/4)*2,(size.height/4)*2 , size.width/4, size.height/4);
    NSRect twelve =  NSMakeRect((size.width/4)*3,(size.height/4)*2 , size.width/4, size.height/4);
    
    
    NSRect thirteen = NSMakeRect(0, (size.height/4)*3, size.width/4, size.height/4);
    NSRect fourteen = NSMakeRect(size.width/4,(size.height/4)*3, size.width/4, size.height/4);
    NSRect fifteen =  NSMakeRect((size.width/4)*2,(size.height/4)*3 , size.width/4, size.height/4);
    NSRect sixteen =  NSMakeRect((size.width/4)*3,(size.height/4)*3 , size.width/4, size.height/4);
    
    [sections addObject:[NSValue valueWithRect:one]];
    [sections addObject:[NSValue valueWithRect:two]];
    [sections addObject:[NSValue valueWithRect:three]];
    [sections addObject:[NSValue valueWithRect:four]];
    [sections addObject:[NSValue valueWithRect:five]];
    [sections addObject:[NSValue valueWithRect:six]];
    [sections addObject:[NSValue valueWithRect:seven]];
    [sections addObject:[NSValue valueWithRect:eight]];
    [sections addObject:[NSValue valueWithRect:nine]];
    [sections addObject:[NSValue valueWithRect:ten]];
    [sections addObject:[NSValue valueWithRect:eleven]];
    [sections addObject:[NSValue valueWithRect:twelve]];
    [sections addObject:[NSValue valueWithRect:thirteen]];
    [sections addObject:[NSValue valueWithRect:fourteen]];
    [sections addObject:[NSValue valueWithRect:fifteen]];
    [sections addObject:[NSValue valueWithRect:sixteen]];

    
    int selectedareaId=0;
    

    selectedareaId = [self.selectedArea.userInfo[@"id"] intValue];
    NSLog(@"sel area:%@",self.selectedArea.userInfo[@"id"]);
    
    
    
    
    for (int i=0;i<self.allTrackingAreas.count;i++)
    {
       
        customTrackingArea * trackingArea = [self.allTrackingAreas objectAtIndex:i];
        
       
        customTrackingArea *    trackingArea2 = [[customTrackingArea alloc] initWithRect:[sections[i] rectValue] options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways  ) owner:self userInfo:@{@"id":@(i)}];
      //  trackingArea2.relatedTrackId=i;
        if (i==selectedareaId)
            self.selectedArea = trackingArea2;
        [self.playerView addTrackingArea:trackingArea2];
        [self.allTrackingAreas replaceObjectAtIndex:i withObject:trackingArea2];
         [self.playerView removeTrackingArea:trackingArea];
     
        
    }
    
    NSImage *newImg = [self resizeImage:self.selectedRegionView.image size:self.selectedArea.rect.size];
    NSLog(@"resize to:%f %f",self.selectedArea.rect.size.width,self.selectedArea.rect.size.height);
    [self.selectedRegionView setImage:newImg];
    [self.selectedRegionView setNeedsDisplay:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.1;
        // _selectedRegionView.alphaValue = 1;
        
        self.selectedRegionView.frame =  self.selectedArea.rect;
        
    }
                        completionHandler:^{
                            
                            // _selectedRegionView.alphaValue = 1;
                            
                        }];
    

 //   NSLog(@"window width = %f, window height = %f", size.width,
         // size.height);
    
}

-(void) forceWindowResizeWithBLock
{
    NSSize size = self.playerView.frame.size;
    
    NSMutableArray * sections = [NSMutableArray new];
    
    
    NSRect one =   NSMakeRect(0, 0, size.width/4, size.height/4);
    NSRect two =   NSMakeRect(size.width/4,0, size.width/4, size.height/4);
    NSRect three = NSMakeRect((size.width/4)*2,0 , size.width/4, size.height/4);
    NSRect four =  NSMakeRect((size.width/4)*3,0 , size.width/4, size.height/4);
    
    
    
    NSRect five =    NSMakeRect(0, size.height/4, size.width/4, size.height/4);
    NSRect six =     NSMakeRect(size.width/4,size.height/4, size.width/4, size.height/4);
    NSRect seven =   NSMakeRect((size.width/4)*2,size.height/4 , size.width/4, size.height/4);
    NSRect eight =   NSMakeRect((size.width/4)*3,size.height/4 , size.width/4, size.height/4);
    
    
    NSRect nine = NSMakeRect(0, (size.height/4)*2, size.width/4, size.height/4);
    NSRect ten = NSMakeRect(size.width/4,(size.height/4)*2, size.width/4, size.height/4);
    NSRect eleven =  NSMakeRect((size.width/4)*2,(size.height/4)*2 , size.width/4, size.height/4);
    NSRect twelve =  NSMakeRect((size.width/4)*3,(size.height/4)*2 , size.width/4, size.height/4);
    
    
    NSRect thirteen = NSMakeRect(0, (size.height/4)*3, size.width/4, size.height/4);
    NSRect fourteen = NSMakeRect(size.width/4,(size.height/4)*3, size.width/4, size.height/4);
    NSRect fifteen =  NSMakeRect((size.width/4)*2,(size.height/4)*3 , size.width/4, size.height/4);
    NSRect sixteen =  NSMakeRect((size.width/4)*3,(size.height/4)*3 , size.width/4, size.height/4);
    
    [sections addObject:[NSValue valueWithRect:one]];
    [sections addObject:[NSValue valueWithRect:two]];
    [sections addObject:[NSValue valueWithRect:three]];
    [sections addObject:[NSValue valueWithRect:four]];
    [sections addObject:[NSValue valueWithRect:five]];
    [sections addObject:[NSValue valueWithRect:six]];
    [sections addObject:[NSValue valueWithRect:seven]];
    [sections addObject:[NSValue valueWithRect:eight]];
    [sections addObject:[NSValue valueWithRect:nine]];
    [sections addObject:[NSValue valueWithRect:ten]];
    [sections addObject:[NSValue valueWithRect:eleven]];
    [sections addObject:[NSValue valueWithRect:twelve]];
    [sections addObject:[NSValue valueWithRect:thirteen]];
    [sections addObject:[NSValue valueWithRect:fourteen]];
    [sections addObject:[NSValue valueWithRect:fifteen]];
    [sections addObject:[NSValue valueWithRect:sixteen]];


    int selectedareaId=0;
    
    
    selectedareaId = [self.selectedArea.userInfo[@"id"] intValue];
    NSLog(@"sel area:%@",self.selectedArea.userInfo[@"id"]);
    
    
    
    
    for (int i=0;i<self.allTrackingAreas.count;i++)
    {
        
        customTrackingArea * trackingArea = [self.allTrackingAreas objectAtIndex:i];
        
        
        customTrackingArea *    trackingArea2 = [[customTrackingArea alloc] initWithRect:[sections[i] rectValue] options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways  ) owner:self userInfo:@{@"id":@(i)}];
        //  trackingArea2.relatedTrackId=i;
        if (i==selectedareaId)
            self.selectedArea = trackingArea2;
        [self.playerView addTrackingArea:trackingArea2];
        [self.allTrackingAreas replaceObjectAtIndex:i withObject:trackingArea2];
        [self.playerView removeTrackingArea:trackingArea];
        
        
    }
    
    NSImage *newImg = [self resizeImage:self.selectedRegionView.image size:self.selectedArea.rect.size];
    NSLog(@"resize to:%f %f",self.selectedArea.rect.size.width,self.selectedArea.rect.size.height);
    [self.selectedRegionView setImage:newImg];
    [self.selectedRegionView setNeedsDisplay:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.1;
        // _selectedRegionView.alphaValue = 1;
        
        self.selectedRegionView.frame =  self.selectedArea.rect;
        
    }
                        completionHandler:^{
                            
                            // _selectedRegionView.alphaValue = 1;
                            
                        }];
    

}


- (NSImage*) resizeImage:(NSImage*)sourceImage size:(NSSize)size{
    
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImage*  targetImage = [[NSImage alloc] initWithSize:size];
    
    NSSize sourceSize = [sourceImage size];
    
    float ratioH = size.height/ sourceSize.height;
    float ratioW = size.width / sourceSize.width;
    
    NSRect cropRect = NSZeroRect;
    if (ratioH >= ratioW) {
        cropRect.size.width = floor (size.width / ratioH);
        cropRect.size.height = sourceSize.height;
    } else {
        cropRect.size.width = sourceSize.width;
        cropRect.size.height = floor(size.height / ratioW);
    }
    
    cropRect.origin.x = floor( (sourceSize.width - cropRect.size.width)/2 );
    cropRect.origin.y = floor( (sourceSize.height - cropRect.size.height)/2 );
    
    
    
    [targetImage lockFocus];
    
    [sourceImage drawInRect:targetFrame
                   fromRect:cropRect       //portion of source image to draw
                  operation:NSCompositeCopy  //compositing operation
                   fraction:1.0              //alpha (transparency) value
             respectFlipped:YES              //coordinate system
                      hints:@{NSImageHintInterpolation:
                                  [NSNumber numberWithInt:NSImageInterpolationLow]}];
    
    [targetImage unlockFocus];
    
    return targetImage;}


-(void) maketrackingareas
{
    NSSize size = self.playerView.frame.size;
    
    NSMutableArray * sections = [NSMutableArray new];
    
    NSRect one =   NSMakeRect(0, 0, size.width/4, size.height/4);
    NSRect two =   NSMakeRect(size.width/4,0, size.width/4, size.height/4);
    NSRect three = NSMakeRect((size.width/4)*2,0 , size.width/4, size.height/4);
    NSRect four =  NSMakeRect((size.width/4)*3,0 , size.width/4, size.height/4);
    
    
    
    NSRect five =    NSMakeRect(0, size.height/4, size.width/4, size.height/4);
    NSRect six =     NSMakeRect(size.width/4,size.height/4, size.width/4, size.height/4);
    NSRect seven =   NSMakeRect((size.width/4)*2,size.height/4 , size.width/4, size.height/4);
    NSRect eight =   NSMakeRect((size.width/4)*3,size.height/4 , size.width/4, size.height/4);
    
    
    NSRect nine = NSMakeRect(0, (size.height/4)*2, size.width/4, size.height/4);
    NSRect ten = NSMakeRect(size.width/4,(size.height/4)*2, size.width/4, size.height/4);
    NSRect eleven =  NSMakeRect((size.width/4)*2,(size.height/4)*2 , size.width/4, size.height/4);
    NSRect twelve =  NSMakeRect((size.width/4)*3,(size.height/4)*2 , size.width/4, size.height/4);
    
    
    NSRect thirteen = NSMakeRect(0, (size.height/4)*3, size.width/4, size.height/4);
    NSRect fourteen = NSMakeRect(size.width/4,(size.height/4)*3, size.width/4, size.height/4);
    NSRect fifteen =  NSMakeRect((size.width/4)*2,(size.height/4)*3 , size.width/4, size.height/4);
    NSRect sixteen =  NSMakeRect((size.width/4)*3,(size.height/4)*3 , size.width/4, size.height/4);
    
    [sections addObject:[NSValue valueWithRect:one]];
    [sections addObject:[NSValue valueWithRect:two]];
    [sections addObject:[NSValue valueWithRect:three]];
    [sections addObject:[NSValue valueWithRect:four]];
    [sections addObject:[NSValue valueWithRect:five]];
    [sections addObject:[NSValue valueWithRect:six]];
    [sections addObject:[NSValue valueWithRect:seven]];
    [sections addObject:[NSValue valueWithRect:eight]];
    [sections addObject:[NSValue valueWithRect:nine]];
    [sections addObject:[NSValue valueWithRect:ten]];
    [sections addObject:[NSValue valueWithRect:eleven]];
    [sections addObject:[NSValue valueWithRect:twelve]];
    [sections addObject:[NSValue valueWithRect:thirteen]];
    [sections addObject:[NSValue valueWithRect:fourteen]];
    [sections addObject:[NSValue valueWithRect:fifteen]];
    [sections addObject:[NSValue valueWithRect:sixteen]];

  
    for (int i=0;i<sections.count;i++)
    {
        
      
        
        
        customTrackingArea *    trackingArea = [[customTrackingArea alloc] initWithRect:[sections[i] rectValue] options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways  ) owner:self userInfo:@{@"id":@(i)}];
    
       // trackingArea.relatedTrackId=i;
        [self.playerView addTrackingArea:trackingArea];
        [self.allTrackingAreas addObject:trackingArea];
    }
    
}

-(BOOL) isitEmptyTrack:(int) tracknumber
{
    BOOL result = YES;
    
    CMTime currentPlayerTime = self.playerView.player.currentTime;
    
    if (_enabledTracks.count>tracknumber)
    {
    AVMutableCompositionTrack * track = _currentVideoTracks[tracknumber];
    AVMutableCompositionTrack * proxyTrack = _currentProxyVideoTracks[tracknumber];
    
    for (AVCompositionTrackSegment * segment in track.segments)
    {
        
        if (CMTimeRangeContainsTime(segment.timeMapping.target,currentPlayerTime))
            {
                
                if (segment.isEmpty)
                    return YES;
                else
                {
                    self.segmentrange = segment.timeMapping.target;
                    _currentAssetSourceUrl =    segment.sourceURL;
                    _currentAssetTrackId = tracknumber;
                    _currentTrack = track;
                    _currentProxyTrack = proxyTrack;
                    _currentAssetTimeRangeInMasterComposition = segment.timeMapping.target;
                    _trackId = segment.sourceTrackID;
                    return NO; }
                
                
                
                
                
                
            }
        
        
        
        
        
    }
   
        
    }
    
    
    
    
    
    
    return result;
}






-(NSMutableArray *) getTracksForIds:(NSArray*) enabledTracks fromComp:(AVComposition*) comp
{
    
    
  
    NSMutableArray * rezArray = [NSMutableArray new];
    NSArray * videoTracks = [comp tracksWithMediaType:AVMediaTypeVideo];
    for (int i=0;i<videoTracks.count;i++)
    {
        
        if ([enabledTracks containsObject:@(i)]||!enabledTracks.count)
            [rezArray addObject:videoTracks[i]];
        
        
    }
    
    
    
    
   
    
    return rezArray;
    
}

-(void) setupLink{
    
    
    CMTime interval = CMTimeMakeWithSeconds(0.05, NSEC_PER_SEC); // 1 second
    self.playBackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:interval
                                              queue:NULL usingBlock:^(CMTime time) {
                                                  // update slider value here...
                                                  
                                                  //NSLog(@"time:%lld",time.value/time.timescale);
                                        
//                                                  self.selectedRegionView.remainingTime = [NSString stringWithFormat:@"time:%lld",time.value/time.timescale];
                                                  
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"timeChanged" object:nil];             
                                                CMTime remainingTime =  CMTimeSubtract(CMTimeRangeGetEnd(self.segmentrange),time);
                                                  
                                                  if (remainingTime.timescale)
                                                  {
                                                  if (remainingTime.value>0)
                                                  {
                                                  self.selectedRegionView.textField.stringValue= [NSString stringWithFormat:@"%@",[self formatTimeStamp:(float)remainingTime.value/(float)remainingTime.timescale]];
                                                  }
                                                  else
                                                  {
                                                      
                                                      self.playerView.player.pause;
                                                  }
                                                  if (remainingTime.value==0)
                                                  {
                                                      
                                                      if (_stopOnNextCut)
                                                      {
                                                          [self.playerView.player pause];
                                                          _stopOnNextCut = NO;
                                                      }
                                                  }
                                                      
                                                  }
                                                  
                                                  [self.selectedRegionView setNeedsDisplayInRect:self.selectedRegionView.frame];
                                                  
                                              }];
    

    
    
}


- (NSString *) formatTimeStamp:(float)seconds {
    int sec = floor(fmodf(seconds, 60.0f));
    NSString * frms = [NSString stringWithFormat:@"%d",(int)((seconds - sec) * 25)];
    if ([frms length]>1)
    frms= [frms substringFromIndex: [frms length] - 2] ;
    return [NSString stringWithFormat:@"%02d:%02d:%02d:%@",
            (int)floor(seconds/60/60),          // hours
            (int)floor(seconds/60),             // minutes
            (int)sec,                           // seconds
            frms  // milliseconds
            ];
}



-(BOOL) checkIfBetweenEdits:(CMTime) currentTime
{
    
    BOOL betweenEdits=NO;
    
    for ( int i=1;i<self.selections.count;i++)
    {
        NSMutableDictionary * selection = self.selections[i];
        NSMutableDictionary * previousSelection = self.selections[i-1];
        CMTime selectionTime = [selection[@"time"] CMTimeValue]; ;
        CMTime previousselectionTime = [previousSelection[@"time"] CMTimeValue]; ;
        // [self.selections addObject:@{@"time":currentTimeValue,@"trackId":self.selectedArea.userInfo[@"id"]}];
        
      //  NSLog(@"selectionTIme:%@ current TIme: %@  previousSelectionTime: %@ ",[self getSecondsFromCMTime:selectionTime],[self getSecondsFromCMTime:currentTime],[self getSecondsFromCMTime:previousselectionTime]);
        if (CMTimeCompare(selectionTime, currentTime)==1&&CMTimeCompare(previousselectionTime, currentTime)==-1)
        {
            
            
//            self.selectedArea = previousSelection[@"region"];
//            // _selectedRegionView.alphaValue = 1;
//            NSLog(@"current area id : %@",self.selectedArea.userInfo[@"id"]);
//            self.selectedRegionView.frame =  self.selectedArea.rect;
            
            betweenEdits = YES;
            
        }
        
    }
 
    return betweenEdits;
    
    
}

-(NSMutableDictionary*) getSelectionForTime:(CMTime) currentTime
{
    CMTime timeDifference = kCMTimeZero;
    NSMutableDictionary * selection = [self.selections firstObject];
    for ( int i=self.selections.count-1;i>=0;i--)
    {
     
         selection = self.selections[i];
        if (CMTimeCompare(currentTime, [selection[@"time"] CMTimeValue] )==1||CMTimeCompare(currentTime, [selection[@"time"] CMTimeValue])==0)
            {
                return selection;
                
                
            }
        
    }
    
    
    return selection;
    
}

-(customTrackingArea*) getSelectedAreaForTime:(CMTime) currentTime
{
    customTrackingArea * selectedarea;
    
    for ( int i=1;i<self.selections.count;i++)
    {
        NSMutableDictionary * selection = self.selections[i];
         NSMutableDictionary * previousSelection = self.selections[i-1];
        CMTime selectionTime = [selection[@"time"] CMTimeValue]; ;
         CMTime previousselectionTime = [previousSelection[@"time"] CMTimeValue]; ;
         // [self.selections addObject:@{@"time":currentTimeValue,@"trackId":self.selectedArea.userInfo[@"id"]}];
        
    //    NSLog(@"selectionTIme:%@ current TIme: %@  previousSelectionTime: %@ ",[self getSecondsFromCMTime:selectionTime],[self getSecondsFromCMTime:currentTime],[self getSecondsFromCMTime:previousselectionTime]);
        if (CMTimeCompare(selectionTime, currentTime)==1&&(CMTimeCompare(previousselectionTime, currentTime)==-1||CMTimeCompare(previousselectionTime, currentTime)==0))
        {
            customTrackingArea * sArea = previousSelection[@"region"];
          //  self.selectedArea = previousSelection[@"region"];
           // if (self.view.frame.size.width != _currentPlayerSize.height)
          //  { [ self forceWindowResizeWithBLock];
             self.selectedArea = self.allTrackingAreas[[sArea.userInfo[@"id"] intValue]];
          //  }
            
                     // _selectedRegionView.alphaValue = 1;
                NSLog(@"current area id : %@",self.selectedArea.userInfo[@"id"]);
           
                self.selectedRegionView.frame =  self.selectedArea.rect;
            
      
            
        }
        else if ((CMTimeCompare(selectionTime, currentTime)==-1&&i==self.selections.count-1))
        {
            customTrackingArea * sArea = selection[@"region"];
            //  self.selectedArea = previousSelection[@"region"];
            // if (self.view.frame.size.width != _currentPlayerSize.height)
            //  { [ self forceWindowResizeWithBLock];
            self.selectedArea = self.allTrackingAreas[[sArea.userInfo[@"id"] intValue]];
            //  }
            
            // _selectedRegionView.alphaValue = 1;
            NSLog(@"current area id : %@",self.selectedArea.userInfo[@"id"]);
            
            self.selectedRegionView.frame =  self.selectedArea.rect;
            
            
            
            
        }
        
    }
    
    
    
    
    
    return selectedarea;
}
-(CMTime) getNextCutTime
{
    CMTime currentTime = self.playerView.player.currentTime;
    
    CMTime closestTime;
    if (self.selections.count)
    {
        NSMutableDictionary * selection = [self.selections lastObject];
        if (CMTimeCompare(currentTime,[selection[@"time"] CMTimeValue] )==-1)
        { closestTime = [selection[@"time"] CMTimeValue]; ;
            
            NSLog(@"current time: %f sec.first closest :%f sec",CMTimeGetSeconds(currentTime),CMTimeGetSeconds(closestTime));
        }
        
      //  NSLog(@"iterating through all edits..");
        
        
        
        
        for ( int i=1;i<self.selections.count;i++)
        {
            
            NSMutableDictionary * selection = self.selections[i];
            
            CMTime selectionTime = [selection[@"time"] CMTimeValue]; ;
         //   NSLog(@"selection %d time:%f secs  ",i,CMTimeGetSeconds(selectionTime));
            
            if (CMTimeCompare(currentTime, selectionTime)==-1)
                
                if (CMTimeCompare(CMTimeSubtract(selectionTime,currentTime),CMTimeSubtract(closestTime,currentTime ))==-1)
                {    closestTime = selectionTime;
                    if (_shouldIUpdateSelectionsRealTime)
                    {  customTrackingArea * t = [self getSelectedAreaForTime:closestTime]; }
                 //   NSLog(@"changin closest to time:%f secs  ",CMTimeGetSeconds(closestTime));
                    
                }
            
            
        }
        
    }
    
    return closestTime;
    
    
}
-(CMTime) getPreviousCutTime
{
    CMTime currentTime = self.playerView.player.currentTime;
    
      CMTime closestTime;
      if (self.selections.count)
      {
            NSMutableDictionary * selection = self.selections[0];
          if (CMTimeCompare(currentTime,[selection[@"time"] CMTimeValue] )==1)
          { closestTime = [selection[@"time"] CMTimeValue]; ;
              
             // NSLog(@"current time: %f sec.first closest :%f sec",CMTimeGetSeconds(currentTime),CMTimeGetSeconds(closestTime));
          }
        
      //    NSLog(@"iterating through all edits..");
          
      
    
          
    for ( int i=1;i<self.selections.count;i++)
    {
        
        NSMutableDictionary * selection = self.selections[i];
        
        CMTime selectionTime = [selection[@"time"] CMTimeValue]; ;
     //   NSLog(@"selection %d time:%f secs  ",i,CMTimeGetSeconds(selectionTime));
        
        if (CMTimeCompare(currentTime, selectionTime)==1)
        
            if (CMTimeCompare(CMTimeSubtract(currentTime, selectionTime),CMTimeSubtract(currentTime, closestTime)))
            {    closestTime = selectionTime;
                if (_shouldIUpdateSelectionsRealTime)
                {  customTrackingArea * t = [self getSelectedAreaForTime:closestTime]; }
         //     NSLog(@"changin closest to time:%f secs  ",CMTimeGetSeconds(closestTime));
            
            }
        
        
    }
    
     }
    
    return closestTime;
    
    
}

-(CMTimeRange) getCurrentSectionRange
{
    CMTime currentTime = self.playerView.player.currentTime;
    CMTimeRange rez;
    for ( int i=1;i<self.selections.count;i++)
    {
        NSMutableDictionary * selection = self.selections[i];
        NSMutableDictionary * previousSelection = self.selections[i-1];
        
        CMTime selectionTime = [selection[@"time"] CMTimeValue]; ;
     
        CMTime previousselectionTime = [previousSelection[@"time"] CMTimeValue]; ;
        // [self.selections addObject:@{@"time":currentTimeValue,@"trackId":self.selectedArea.userInfo[@"id"]}];
        
      //  NSLog(@"selectionTIme:%@ current TIme: %@  previousSelectionTime: %@ ",[self getSecondsFromCMTime:selectionTime],[self getSecondsFromCMTime:currentTime],[self getSecondsFromCMTime:previousselectionTime]);
        if ((CMTimeCompare(selectionTime, currentTime)==1&&CMTimeCompare(previousselectionTime, currentTime)==-1))
        {
             rez = CMTimeRangeFromTimeToTime(previousselectionTime, selectionTime);
            return rez;
        }
        
        
        if ((CMTimeCompare(selectionTime, currentTime)==0&&CMTimeCompare(previousselectionTime, currentTime)==-1)&&i<self.selections.count-1)
        {
            NSMutableDictionary * nextSelection = self.selections[i+1];
                       CMTime nextSelectionTime = [nextSelection[@"time"] CMTimeValue]; ;
            rez = CMTimeRangeFromTimeToTime(previousselectionTime, nextSelectionTime);
            return rez;
        }

        
        
    }
    
    return rez;
    
}






-(NSString* ) getSecondsFromCMTime:(CMTime)time
{
    
    
    return [NSString stringWithFormat:@"%f sec.",(float)time.value/(float)time.timescale];
    
}

-(void) renderComp:(AVMutableComposition*) comp videoComp:(AVMutableVideoComposition*)videoComp
{
    
    NSLog(@"isexportable=%d",comp.isExportable);
   
    
    encoder = [SDAVAssetExportSession.alloc initWithAsset:comp];
    
    encoder.outputFileType = AVFileTypeQuickTimeMovie;
    encoder.delegate=self;
   // encoder.videoComposition = videoComp;
    encoder.outputURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@compTemp1010.mov/",NSTemporaryDirectory()]];
     encoder.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(62000, 1000));
    encoder.videoSettings = @
    {
    AVVideoCodecKey: AVVideoCodecAppleProRes422,
    AVVideoWidthKey: @(videoComp.renderSize.width),
    AVVideoHeightKey:@( videoComp.renderSize.height),
    AVVideoCompressionPropertiesKey: @
        {
       // AVVideoAverageBitRateKey: @6000000
    //  , AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    encoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @44100,
    AVEncoderBitRateKey: @128000,
    };
    
    [encoder exportAsynchronouslyWithCompletionHandler:^
    {
        if (encoder.status == AVAssetExportSessionStatusCompleted)
        {
            NSLog(@"Video export succeeded");
            WOO_AVURLAsset* asset = [WOO_AVURLAsset assetWithURL:encoder.outputURL];
            CMTime currentTime = self.playerView.player.currentTime;
            AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:asset];
            [self.playerView.player removeTimeObserver:self.timeObserver];
              self.playerView.player = [AVPlayer playerWithPlayerItem:item];
            [self.playerView.player seekToTime:currentTime];
        }
        else if (encoder.status == AVAssetExportSessionStatusCancelled)
        {
            NSLog(@"Video export cancelled");
        }
        else
        {
            NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, (long)encoder.error.code);
        }
    }];
}

-(void) renderComp2:(AVMutableComposition*) comp videoComp:(AVMutableVideoComposition*)videoComp whereToSave:(NSString*) savePath
{
//    [DJProgressHUD dismiss];
   
    
    
    AVAssetExportSession *exporter;
  //  BOOL EXPORT = [[PFUser currentUser][@"EXPORT"] boolValue];
  //  BOOL HD = [[PFUser currentUser][@"HD"] boolValue];
  //  if (EXPORT)
    {
//         [DJProgressHUD showStatus:@"Exporting.. Please be patient!" FromView:self.view];
   // if (HD)
    {
  exporter  = [[AVAssetExportSession alloc] initWithAsset:comp presetName:AVAssetExportPresetHighestQuality];
        NSLog(@"AVAssetExportPresetHighestQuality");
    }
//   // else
//    {
//        exporter  = [[AVAssetExportSession alloc] initWithAsset:comp presetName:AVAssetExportPreset640x480];
//          NSLog(@"AVAssetExportPreset640x480");
//    }
    }
   // else
    {
//        [doo showToasMsg:@"You are not allowed to export without valid subscription or permission!" inView:self.view forDuration:3];
//         [(AppDelegate *)[NSApp delegate] subscribeNow];
//         NSLog(@"You are now allowed to export without valid subscription or permission!");
        
        
    }
    
  //  [doo addtitle:@"Title" songName:@"Song Name" releaseDate:@"21.5.2016" albumName:@"AlbumName" forVideoComposition:videoComp fromMainComposition:_editedComposition];
 // videoComp =  [doo addImageOverLayToMainCompwithVideoComp:videoComp image:[NSImage imageNamed:@"1024_1024.png"]];
    
   //
    
    
//    
//    NSImage * image = _watermarkImage;
//    
//    
//    CGImageSourceRef source;
//    
//    source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
//    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
//    CALayer *overlayLayer = [CALayer layer];
//    NSImage *overlayImage = image;
//    NSSize size = videoComp.renderSize;
//    
//    [overlayLayer setContents:(__bridge id _Nullable)(maskRef)];
//    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
//    [overlayLayer setMasksToBounds:YES];
//    
//    // 2 - set up the parent layer
//    CALayer *parentLayer = [CALayer layer];
//    CALayer *videoLayer = [CALayer layer];
//    // parentLayer.position =
//    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
//    videoLayer.frame = CGRectMake(50, 50,100,100);
//    [parentLayer addSublayer:videoLayer];
//    [parentLayer addSublayer:overlayLayer];
//    
//    // 3 - apply magic
//    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool
//                               videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
  //  videoComp.animationTool
    
    
    
    
    
    //
      exporter.outputFileType = AVFileTypeMPEG4;
    if (videoComp)
    exporter.videoComposition = videoComp;
    
     exporter.shouldOptimizeForNetworkUse = YES;
    
    NSLog(@"estimated length:%lld",exporter.estimatedOutputFileLength);
    int randomNumber = arc4random_uniform(74);
  //  exporter.outputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@Temp%i.mp4",NSTemporaryDirectory(),randomNumber]];
    exporter.outputURL = [NSURL fileURLWithPath:savePath];
   // _outputUrl = [NSString stringWithFormat:@"%@Tempoo%i.mp4",NSTemporaryDirectory(),randomNumber];
    NSDictionary * userInfo = @{@"exportSession":exporter};
    _progressStart = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.exportProgressBarTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateExportDisplay:) userInfo:userInfo repeats:YES];
    });
     NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
            {
//                [DJProgressHUD dismiss];
                [doo showToasMsg:@"Export Failed!" inView:self.view forDuration:5];
                NSLog(@"Export failed: %@", [exporter error]);
            }
                      break;
                      case AVAssetExportSessionStatusCancelled:
            {
//                [DJProgressHUD dismiss];
                [doo showToasMsg:@"Export Cancelled!" inView:self.view forDuration:5];
                      NSLog(@"@Export canceled");
            }
                      break;
                      case AVAssetExportSessionStatusCompleted:
              //  [doo addWatermarkToVideoFile:[exporter.outputURL path]];
            {
               // PFUser * user = [PFUser currentUser];
//                int b = [user[@"WATERMARK"] boolValue];
//                if (b)
//                [doo addWatermarkToVideoFile:[exporter.outputURL path] image:_watermarkImage delegate:self] ;
//                else
                {
//                    [DJProgressHUD dismiss];
//                    [doo showProgressWithMsg:@"Export finished! You file is saved!"];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [DJProgressHUD dismiss];
//                    });
                    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
                    [workspace openFile:[exporter.outputURL path]];
                    
                    
                }
//                     // NSLog(@"Export successfully");
//                    [workspace openFile:_outputUrl ];
            }
                      break;
                      default:
                      break;
                      }
                      if (exporter.status != AVAssetExportSessionStatusCompleted){
                          NSLog(@"Retry export");
                         // [self renderMovie];
                      }
                      }];
    
    
    
    
    
}
-(void)exportSession:(SDAVAssetExportSession *)exportSession renderFrame:(CVPixelBufferRef)pixelBuffer withPresentationTime:(CMTime)presentationTime toBuffer:(CVPixelBufferRef)renderBuffer
{
    
    NSLog(@"rendering time:%f",CMTimeGetSeconds(presentationTime));
    
    
    
}
#pragma mark    -   NSResponder
- (void)cancelOperation:(id)sender
{
    NSLog(@"escape clicked");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"previewMode" object:nil];
}

- (void)deleteBackward:(id)sender
{
    
    
    
}

-(void)keyDown:(NSEvent *)theEvent
{
     [super keyDown:theEvent];
    // handle delete
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if (key == NSDeleteCharacter ) {
        NSLog(@"delete edit clicked");
        CMTime currentTime = self.playerView.player.currentTime;
        for (int i=self.selections.count-1;i>=0;i--)
        {
            NSDictionary * selection  = self.selections[i];
            if (CMTimeCompare(currentTime, [selection[@"time"] CMTimeValue])==0)
                [self.selections removeObjectAtIndex:i];
            [self getSelectedAreaForTime:currentTime];
            if (!_multiCamPreview)
            {
            _editedComposition = [doo exportMusicVideoMontageSequence:_selections forMainComp:_masterComposition];
           
            AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_editedComposition];
            [self.playerView.player replaceCurrentItemWithPlayerItem:item];
            [self.playerView.player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
            }

        }

    }
}

- (void)windowWillClose:(NSNotification *)notification {
    [self.playerView.player pause];
    self.playerView = nil;
}

-(void) applyFilterHereForSelection
{
//    "_blueSlider" = 1;
//    "_brightnessSlider" = 0;
//    "_contrastSlider" = 1;
//    "_exposureSlider" = "0.5";
//    "_gammaSlider" = "0.75";
//    "_greenSlider" = 1;
//    "_hueSlider" = 0;
//    "_redSlider" = 1;
//    "_saturationSlider" = 1;
//    "_sepiaSlider" = 1;
   defaultfilterSettings =[ @{@"_redSlider":@(1.0),@"_greenSlider":@(1.0),@"_blueSlider":@(1.0),@"_brightnessSlider":@(0.0),@"_contrastSlider":@(1.0),@"_exposureSlider":@(0.50),@"_gammaSlider":@(0.75),@"_hueSlider":@(0.0),@"_sepiaSlider":@(1.0),@"_saturationSlider":@(1)} mutableCopy];
    
//    NSLog(@"%f,%f,%f",[selection[@"filterSettings"][@"_brightnessSlider"] floatValue],[selection[@"filterSettings"][@"_contrastSlider"] floatValue],[selection[@"filterSettings"][@"_saturationtSlider"] floatValue]);
    
//     if ([selection[@"filterSettings"][@"_brightnessSlider"] floatValue]>0.51||[selection[@"filterSettings"][@"_brightnessSlider"] floatValue]<0.49||[selection[@"filterSettings"][@"_contrastSlider"] floatValue]>0.51||[selection[@"filterSettings"][@"_contrastSlider"] floatValue]<0.49||[selection[@"filterSettings"][@"_saturationtSlider"] floatValue]>0.51||[selection[@"filterSettings"][@"_saturationtSlider"] floatValue]<0.49)
    
    
       AVVideoComposition * videoComp = [AVVideoComposition videoCompositionWithAsset:_editedComposition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
           
           
           
           
           
           NSMutableDictionary * selection = [self getSelectionForTime:request.compositionTime];
           if (!selection)
               selection = [_selections lastObject];
        //   NSLog(@"selection : %@",selection);
           if (!selection[@"filterSettings"])
           {
//               if (_currentFilterSettings)
//               selection[@"filterSettings"] = _currentFilterSettings;
//           else
               selection[@"filterSettings"] = defaultfilterSettings;
           }
           
           CGFloat rArray[] ={[ selection[@"filterSettings"][@"_redSlider"] floatValue]  ,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
           CGFloat gArray[] ={0.0,[ selection[@"filterSettings"][@"_greenSlider"] floatValue], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
           CGFloat bArray[] ={0.0, 0.0,[ selection[@"filterSettings"][@"_blueSlider"] floatValue], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
           CIVector *r = [CIVector vectorWithValues:rArray count:10];
           CIVector *g = [CIVector vectorWithValues:gArray count:10];
           CIVector *b = [CIVector vectorWithValues:bArray count:10];
           
           
           
           
           
           
           
           
           
           
           
        float seconds = CMTimeGetSeconds(request.compositionTime);
        //       CIImage * filtered =[_parentPlayController getMeFiltersforComposition:_parentPlayController.editedComposition atTime:request.compositionTime request:request];
        CIImage * filtered = request.sourceImage;
        
        
        
        
        
        if ([selection[@"filterSettings"][@"_exposureSlider"] floatValue]<.49||[selection[@"filterSettings"][@"_exposureSlider"] floatValue]>.51)
        {
            filtered = [filtered imageByApplyingFilter:@"CIExposureAdjust" withInputParameters:@{ @"inputEV":@([selection[@"filterSettings"][@"_exposureSlider"] floatValue])}];
            
            NSLog(@"exposure change to :%f",[selection[@"filterSettings"][@"_exposureSlider"] floatValue]);
            
            
            
        }
        
        if (1)
        {
            
            filtered = [filtered imageByApplyingFilter:@"CIColorCrossPolynomial" withInputParameters:@{@"inputRedCoefficients":r,@"inputGreenCoefficients":g,@"inputBlueCoefficients":b }];
            
            
            
            
            
        }
        
        
        
       // if ([selection[@"filterSettings"][@"_brightnessSlider"] floatValue]>0.51||[selection[@"filterSettings"][@"_brightnessSlider"] floatValue]<0.49||[selection[@"filterSettings"][@"_contrastSlider"] floatValue]>0.51||[selection[@"filterSettings"][@"_contrastSlider"] floatValue]<0.49||[selection[@"filterSettings"][@"_saturationtSlider"] floatValue]>0.51||[selection[@"filterSettings"][@"_saturationtSlider"] floatValue]<0.49)
           if(1)
        {
            
            float brightness = [selection[@"filterSettings"][@"_brightnessSlider"] floatValue];
            
            float saturation = [selection[@"filterSettings"][@"_saturationSlider"] floatValue];
            
            float constrast = [selection[@"filterSettings"][@"_contrastSlider"] floatValue];
            filtered = [filtered imageByApplyingFilter:@"CIColorControls" withInputParameters:@{kCIInputSaturationKey:@(saturation),kCIInputContrastKey:@(constrast),kCIInputBrightnessKey:@(brightness)}];
            
            
        }
   
        
        if ([selection[@"filterSettings"][@"_gammaSlider"] floatValue]>.76|[selection[@"filterSettings"][@"_gammaSlider"] floatValue]<0.74)
        {
            
            float gamma = [selection[@"filterSettings"][@"_gammaSlider"] floatValue];
            filtered = [filtered imageByApplyingFilter:@"CIGammaAdjust" withInputParameters:@{ @"inputPower":@(gamma)}];
            
            
            
            
            
        }
        if ([selection[@"filterSettings"][@"_sepiaSlider"] floatValue]>1.01)
        {
            filtered = [filtered imageByApplyingFilter:@"CISepiaTone" withInputParameters:@{kCIInputIntensityKey:selection[@"filterSettings"][@"_sepiaSlider"]}];
            
            
            
            
            
        }
        
        if ([selection[@"filterSettings"][@"_hueSlider"] floatValue]>0.01)
        {
            filtered = [filtered imageByApplyingFilter:@"CIHueAdjust" withInputParameters:@{@"inputAngle":selection[@"filterSettings"][@"_hueSlider"]}];
            
            
            
            
            
        }
        
        
        [request finishWithImage:filtered context:nil];
    }];
    
 
    _currentEditedVideoComposition = videoComp;
    _playerView.player.currentItem.videoComposition = videoComp;
    
    

    
    
}

/*
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(copyFilterSettings:)
 name:@"copyFilterSettings"
 object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(pasteFilterSettings:)
 name:@"pasteFilterSettings"
 object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(applyThisFilterToAllClips:)
 name:@"applyThisFilterToAllClips"
 object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(resetFilterSettings:)
 name:@"resetFilterSettings"
 object:nil];

 
 
 */

-(void) copyFilterSettings:(NSNotification*) notification
{
    if (!_multiCamPreview)
    {
    NSLog(@"copy filter");
    
      NSMutableDictionary * selection = [self getSelectionForTime:self.playerView.player.currentTime];
    if (selection)
        if (selection[@"filterSettings"])
            _currentCOPIEDFilterSettings = selection[@"filterSettings"];
        
    }
    else
    {
        // copy clip
        _currentCopiedAsset = [NSMutableDictionary new];
        NSLog(@"current asset:%@",_currentAssetSourceUrl.path);
        
        _currentCopiedAsset[@"url"] = _currentAssetSourceUrl;
        
        [_selectedRegionView disableTraCkingArea];
        
        
    }
    
    
    
    
    
}
-(void) pasteFilterSettings:(NSNotification*) notification
{
    if (!_multiCamPreview)
    {
     NSLog(@"paste filter");
      NSMutableDictionary * selection = [self getSelectionForTime:self.playerView.player.currentTime];
    if (_currentCOPIEDFilterSettings)
        selection[@"filterSettings"] = _currentCOPIEDFilterSettings;
    }
    else
    {
        if (_cutClip)
        {
            
            
            NSLog(@"pasting asset:%@",[_cutClip[@"url"] path]);
            AVURLAsset * asset = [AVURLAsset assetWithURL:_cutClip[@"url"]];
            AVAssetTrack * track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
            NSURL * proxyUrl =  [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@PROXY.MP4",NSTemporaryDirectory(),[doo generateMD5Hash:[[_cutClip valueForKey:@"url"] path]]]];
            AVURLAsset * assetproxy = [AVURLAsset assetWithURL:proxyUrl];
            AVAssetTrack * trackproxy = [[assetproxy tracksWithMediaType:AVMediaTypeVideo] firstObject];
            NSError * error;
            AVMutableComposition * fullComp =    comps[0];
            AVMutableComposition * proxyComp = compsPreviewProxy[0];
            CMTimeRange range = trackproxy.timeRange;
            
            
            AVMutableCompositionTrack * track2Insert = [doo isthereanemptyTracktoPasteHere:fullComp atTime:self.playerView.player.currentTime forRange:track.timeRange];
            AVMutableCompositionTrack * track2InsertProxy = [doo isthereanemptyTracktoPasteHere:proxyComp atTime:self.playerView.player.currentTime forRange:track.timeRange];
            
            if (track2Insert)
            {
                [track2Insert removeTimeRange:CMTimeRangeMake(self.playerView.player.currentTime, range.duration)];
                [track2Insert insertTimeRange:range ofTrack:track atTime:self.playerView.player.currentTime error:&error];
            }
            if (track2InsertProxy)
            {
                [track2InsertProxy removeTimeRange:CMTimeRangeMake(self.playerView.player.currentTime, range.duration)];
                [track2InsertProxy insertTimeRange:range ofTrack:trackproxy atTime:self.playerView.player.currentTime error:&error];
            }
            
            AVMutableVideoComposition * videoComp = [doo createVideoCompWithMainComp2:compsPreviewProxy[0] withTracks:_enabledTracks sourceController:self];
            AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:[compsPreviewProxy[0] mutableCopy] ];
            //  item.videoComposition = videoComp;
            
            if (!videoComp.animationTool) {
                item.videoComposition = [videoComp mutableCopy] ;
            }
            _masterVideoComposition = videoComp;
            _masterComposition = comps[0];
            _currentTime = self.playerView.player.currentTime;
            [self.playerView.player replaceCurrentItemWithPlayerItem:item];
            CMTime stophere = CMTimeSubtract(_currentTime, range.duration);
            [self.playerView.player seekToTime:_currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
            NSLog(@"%@",error.description);
            _currentCopiedAsset = nil;

            
            
            
            _cutClip = nil;
        }
        
        
        
      else   if (_currentCopiedAsset)
        {
        NSLog(@"pasting asset:%@",[_currentCopiedAsset[@"url"] path]);
        AVURLAsset * asset = [AVURLAsset assetWithURL:_currentCopiedAsset[@"url"]];
        AVAssetTrack * track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        NSURL * proxyUrl =  [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@PROXY.MP4",NSTemporaryDirectory(),[doo generateMD5Hash:[[_currentCopiedAsset valueForKey:@"url"] path]]]];
        AVURLAsset * assetproxy = [AVURLAsset assetWithURL:proxyUrl];
        AVAssetTrack * trackproxy = [[assetproxy tracksWithMediaType:AVMediaTypeVideo] firstObject];
        NSError * error;
        AVMutableComposition * fullComp =    comps[0];
          AVMutableComposition * proxyComp = compsPreviewProxy[0];
        CMTimeRange range = CMTimeRangeFromTimeToTime([_currentCopiedAsset[@"in"] CMTimeValue], [_currentCopiedAsset[@"out"] CMTimeValue]);
        
        
        AVMutableCompositionTrack * track2Insert = [doo isthereanemptyTracktoPasteHere:fullComp atTime:self.playerView.player.currentTime forRange:track.timeRange];
          AVMutableCompositionTrack * track2InsertProxy = [doo isthereanemptyTracktoPasteHere:proxyComp atTime:self.playerView.player.currentTime forRange:track.timeRange];
        
        if (track2Insert)
        {
            [track2Insert removeTimeRange:CMTimeRangeMake(self.playerView.player.currentTime, range.duration)];
        [track2Insert insertTimeRange:range ofTrack:track atTime:self.playerView.player.currentTime error:&error];
        }
        if (track2InsertProxy)
        {
              [track2InsertProxy removeTimeRange:CMTimeRangeMake(self.playerView.player.currentTime, range.duration)];
          [track2InsertProxy insertTimeRange:range ofTrack:trackproxy atTime:self.playerView.player.currentTime error:&error];
        }
        
        AVMutableVideoComposition * videoComp = [doo createVideoCompWithMainComp2:compsPreviewProxy[0] withTracks:_enabledTracks sourceController:self];
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:[compsPreviewProxy[0] mutableCopy] ];
        //  item.videoComposition = videoComp;
        
        if (!videoComp.animationTool) {
            item.videoComposition = [videoComp mutableCopy] ;
        }
        _masterVideoComposition = videoComp;
        _masterComposition = comps[0];
        _currentTime = self.playerView.player.currentTime;
        [self.playerView.player replaceCurrentItemWithPlayerItem:item];
        CMTime stophere = CMTimeSubtract(_currentTime, range.duration);
        [self.playerView.player seekToTime:_currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        NSLog(@"%@",error.description);
        _currentCopiedAsset = nil;
        }
        
    }
    
    
    
}


-(void) applyThisFilterToAllClips:(NSNotification*) notification
{
      NSLog(@"apply this filter to all clips ");
    for (NSMutableDictionary * selection in _selections)
        if (_currentCOPIEDFilterSettings)
            selection[@"filterSettings"] = _currentCOPIEDFilterSettings;;
    
    
    
    
}
-(void) resetFilterSettings:(NSNotification*) notification
{
    
      NSLog(@"reset filter settings");
     for (NSMutableDictionary * selection in _selections)
         selection[@"filterSettings"] = defaultfilterSettings;
    
    
}

- (void)updateExportDisplay:(NSTimer *)timer {
    AVAssetExportSession * session = [[timer userInfo] objectForKey:@"exportSession"];
   float  progress =  session.progress/2;
   // NSLog(@"progress:%f",progress);
//    [DJProgressHUD showProgress:_progressStart+progress withStatus:@"exporting..." FromView:self.view];
   
    if (_progressStart+ progress > +_progressStart+.49) {
//        [DJProgressHUD dismiss];
        [self.exportProgressBarTimer invalidate];
    }
}

@end
