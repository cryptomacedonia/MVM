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

@implementation playController
@synthesize encoder;
-(void)viewDidLoad
{
    [super viewDidLoad];
    _multiCamPreview = YES;
    self.lastSelectedTimerange = kCMTimeRangeZero;
    self.selections=[NSMutableArray new];
    self.usedFont=[NSFont fontWithName:@"Lucida Grande" size:16.0];;
    self.regionsForTracks=[NSMutableArray new];
    self.allTrackingAreas =[NSMutableArray new];
    NSString * jsn = [NSString stringWithFormat:@"%@data.json",NSTemporaryDirectory()];
    NSArray * comps =   [doo getCompositionsFromFile:jsn proxyIfAvailable:NO];
    NSArray * compsPreviewProxy =   [doo getCompositionsFromFile:jsn proxyIfAvailable:YES];
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
    AVMutableVideoComposition * videoComp = [doo createVideoCompWithMainComp2:compsPreviewProxy[0] withTracks:_enabledTracks sourceController:self];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:[compsPreviewProxy[0] mutableCopy] ];
    //  item.videoComposition = videoComp;
    
    if (!videoComp.animationTool) {
        item.videoComposition = [videoComp mutableCopy] ;
    }
     self.playerView.player = [AVPlayer playerWithPlayerItem:item];
    _masterVideoComposition = videoComp;
    _masterComposition = comps[0];
    
  //  [self renderComp2:[comps[0] mutableCopy]   videoComp:[videoComp mutableCopy]];
    
    self.previousCentre = CGPointMake(NSMidX(self.playerView.frame), NSMidY(self.playerView.frame));
    self.previousPlayerSize = self.playerView.frame.size;
   
      AVPlayerItem * item2 = [[AVPlayerItem alloc] initWithAsset:_masterComposition ];
   
     _editedComposition = comps[0];
   
     self.previewPlayView.player = [AVPlayer playerWithPlayerItem:item2];
    NSLog(@"render size:%f %f  ", item.videoComposition.renderSize.width, item.videoComposition.renderSize.height);
    AVComposition * comp = comps[0];
   
    NSLog(@"duration:%lld ", comp.duration.value/comp.duration.timescale);

    self.playerView.videoGravity = AVLayerVideoGravityResizeAspect;
    self.previewPlayView.videoGravity = AVLayerVideoGravityResizeAspect;
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
    self.selectedRegionView.layer.zPosition=1;
    self.selectedRegionView.remainingTime=@"test";
   
    
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
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     _timeObserver =    [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
                                                             queue:dispatch_get_main_queue()
                                                        usingBlock:^(CMTime time)
         {
          
//             [self.previewPlayView.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
             
          if (_shouldIUpdateSelectionsRealTime)
          {  customTrackingArea * t = [self getSelectedAreaForTime:time]; }
         }];
        

    });
       // [self  windowDidResize:nil];
  
    
}



-(void)viewDidAppear
{
    [self.previewPlayView.player pause];
    [self.playerView.player pause];
    [self.previewPlayView setHidden:YES];
    _stopOnNextCut = NO;
    
    NSSize size = self.playerView.frame.size;
    [self.selectedRegionView setFrame:NSMakeRect(0, 0, size.width/4, size.height/4) ];
      self.selectedRegionView.layer.zPosition=1;
  //  [self renderComp2:[_masterComposition mutableCopy]   videoComp:_masterVideoComposition];
    self.mainWindow = self.view.window;
      self.mainWindow.delegate=self;
    [self forceWindowResizeWithBLock];
}

- (void)render:(NSNotification *)notification
{
    
        NSSavePanel *spanel = [NSSavePanel savePanel];
        NSString *path = @"/Documents";
        [spanel setDirectory:[path stringByExpandingTildeInPath]];
        [spanel setPrompt:NSLocalizedString(@"Render Movie",nil)];
        [spanel setRequiredFileType:@"MOV"];
        [spanel beginSheetForDirectory:NSHomeDirectory()
                                  file:nil
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
        [self renderComp2:_editedComposition videoComp:nil whereToSave:[savePanel filename]];
    }else{
        NSLog(@"Cansel");
    }
}
- (void)previewMode:(NSNotification *)notification
{
    [self.playerView.player pause];
    [self.previewPlayView.player pause];
    
    CMTime currentTime ;
    if (_multiCamPreview)
    {
        if (_selections.count)
        {
         [self.playerView.player pause];
       currentTime = self.playerView.player.currentTime;
            
        _multiCamPreview = NO;
        _selectedRegionView.hidden=YES;
        _editedComposition = [doo exportMusicVideoMontageSequence:_selections forMainComp:_masterComposition];
      [self.playerView.player pause];
//        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_editedComposition];
//          [self.playerView.player replaceCurrentItemWithPlayerItem:item];
//        [self.playerView.player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
//        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_editedComposition];
//    
//        [self.previewPlayView.player replaceCurrentItemWithPlayerItem:item];
        [self.previewPlayView.player seekToTime:self.playerView.player.currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self.playerView unlockFocus];
        [self.playerView setHidden:YES];
             [self.previewPlayView setHidden:NO];
           
            [self.previewPlayView lockFocus];
        }
        
    }
    else{
        
           currentTime = self.previewPlayView.player.currentTime;
        _multiCamPreview=YES;
        [self.previewPlayView.player pause];
       
        [self.previewPlayView unlockFocus];
        [self.previewPlayView setHidden:YES];
         [self.playerView lockFocus];
        
         [self.playerView setHidden:NO];
     
        //   [self.playerView.player removeTimeObserver:self.timeObserver];
        _selectedRegionView.hidden=NO;
//        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_masterComposition];
//        item.videoComposition=_masterVideoComposition;
//        self.playerView.player = [AVPlayer playerWithPlayerItem:item];
        
        [self.playerView.player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        customTrackingArea * t = [self getSelectedAreaForTime:currentTime];
//        _timeObserver =    [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
//                                                                                queue:dispatch_get_main_queue()
//                                                                           usingBlock:^(CMTime time)
//                            {
//                                
//                                customTrackingArea * t = [self getSelectedAreaForTime:time];
//                                
//                                
//                            }];
        
        
        

        
    }
    
    
    
    
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

-(void)mouseDown:(NSEvent *)theEvent
{
    _shouldIUpdateSelectionsRealTime = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _shouldIUpdateSelectionsRealTime=YES;
    });
  //
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
        
        [self.selections addObject:@{@"time":currentTimeValue,@"trackId":self.selectedArea.userInfo[@"id"],@"region":self.selectedArea}];
        
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
        
        
        self.selectedRegionView.frame =  self.selectedArea.rect;
        _editedComposition = [doo exportMusicVideoMontageSequence:_selections forMainComp:_masterComposition];
        AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_editedComposition];
        [self.previewPlayView.player replaceCurrentItemWithPlayerItem:item];
        [self.previewPlayView.player seekToTime:self.playerView.player.currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
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
    AVCompositionTrack * track = _currentVideoTracks[tracknumber];
    
    for (AVCompositionTrackSegment * segment in track.segments)
    {
        
        if (CMTimeRangeContainsTime(segment.timeMapping.target,currentPlayerTime))
            {
                
                if (segment.isEmpty)
                    return YES;
                else
                {
                    self.segmentrange = segment.timeMapping.target;
                    
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"rate"]) {
        if ([self.playerView.player rate]) {
          //  [self changeToPause];  // This changes the button to Pause
            NSLog(@"rate change..");
            
//            NSLog(@"current area id : %@",self.selectedArea.userInfo[@"id"]);
//            self.selectedRegionView.frame =  self.selectedArea.rect;
//            customTrackingArea * selectedarea = [self getSelectedAreaForTime:self.playerView.player.currentTime];
        }
        else {
          //  [self changeToPlay];   // This changes the button to Play
        }
    }
    else if ([keyPath isEqualToString:@"rate"])
    {
        
        
        
        
        
    }
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
            AVURLAsset * asset = [AVURLAsset assetWithURL:encoder.outputURL];
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
    
  
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:comp presetName:AVAssetExportPresetMediumQuality];
      exporter.outputFileType = AVFileTypeMPEG4;
    if (videoComp)
    exporter.videoComposition = videoComp;
     exporter.shouldOptimizeForNetworkUse = NO;
    NSLog(@"estimated length:%lld",exporter.estimatedOutputFileLength);
    int randomNumber = arc4random_uniform(74);
  //  exporter.outputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@Temp%i.mp4",NSTemporaryDirectory(),randomNumber]];
    exporter.outputURL = [NSURL fileURLWithPath:savePath];
   // _outputUrl = [NSString stringWithFormat:@"%@Tempoo%i.mp4",NSTemporaryDirectory(),randomNumber];
    
     NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed: %@", [exporter error]);
                      break;
                      case AVAssetExportSessionStatusCancelled:
                      NSLog(@"@Export canceled");
                      break;
                      case AVAssetExportSessionStatusCompleted:
                     // NSLog(@"Export successfully");
                    [workspace openFile:_outputUrl ];
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
            _editedComposition = [doo exportMusicVideoMontageSequence:_selections forMainComp:_masterComposition];
         
            AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:_editedComposition];
            [self.playerView.player replaceCurrentItemWithPlayerItem:item];
            [self.playerView.player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
            AVPlayerItem * item2 = [AVPlayerItem playerItemWithAsset:_editedComposition];
            [self.previewPlayView.player replaceCurrentItemWithPlayerItem:item2];
            [self.previewPlayView.player seekToTime:self.playerView.player.currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

        }

    }
}

- (void)windowWillClose:(NSNotification *)notification {
    [self.playerView.player pause];
    self.playerView = nil;
}


@end
