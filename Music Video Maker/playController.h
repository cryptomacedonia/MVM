//
//  playController.h
//  tewowdemo
//
//  Created by Igor Jovcevski on 4/4/16.
//  Copyright © 2016 Entangle. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "customTrackingArea.h"
#import "customImageView.h"
//#import <UIKit/UIKit.h>
#import <AVKit/AVPlayerView.h>
#import "SDAVAssetExportSession.h"
#import "imageCalibrationPopoverController.h"
#import "WOO_AVURLAsset.h"
@interface playController : NSViewController<NSWindowDelegate,SDAVAssetExportSessionDelegate>
@property NSMutableArray * regionsForTracks;
@property (weak) IBOutlet customImageView *selectedRegionView;
@property (weak) IBOutlet AVPlayerView *previewPlayView;
@property CMTime currentTime;
@property NSMutableArray * editPoints;
@property customTrackingArea * currentArea;
@property customTrackingArea * selectedArea;
@property (weak) IBOutlet AVPlayerView *playerView;
@property NSWindow *mainWindow;
@property NSPoint  previousCentre;
@property NSSize previousPlayerSize;
@property NSMutableArray * allTrackingAreas;
@property NSArray * enabledTracks;
@property NSMutableArray * currentVideoTracks;
@property NSMutableArray * currentProxyVideoTracks;
@property NSMutableArray * selections;
@property id  playBackTimeObserver;
@property CMTimeRange segmentrange;
@property NSFont * usedFont;
@property CMTimeRange lastSelectedTimerange;
@property int mode;
@property BOOL stopOnNextCut;
@property id timeObserver;
@property   SDAVAssetExportSession *encoder ;
@property AVMutableComposition * masterComposition;
@property AVVideoComposition * masterVideoComposition;
@property AVMutableComposition * editedComposition;
@property NSString * outputUrl;
@property CGSize currentPlayerSize;
@property BOOL shouldIUpdateSelectionsRealTime;
@property BOOL multiCamPreview;
@property NSMutableDictionary * currentFilterSettings;
@property NSMutableDictionary * currentCOPIEDFilterSettings;
@property NSMutableDictionary *    defaultfilterSettings ;
@property NSImage * watermarkImage;
@property NSImage * exportSubscribeAdImage;
@property NSTimer * exportProgressBarTimer;
@property float progressStart;
-(CMTime) getPreviousCutTime;
-(NSMutableDictionary*) getSelectionForTime:(CMTime) currentTime;
-(CIImage*) getMeFiltersforComposition:(AVMutableComposition*) composition atTime:(CMTime) currentTime request:(AVAsynchronousCIImageFilteringRequest*) request;
-(void) applyFilterHereForSelection
;
- (void)updateExportDisplay:(NSTimer *)timer;
@property AVVideoComposition * currentEditedVideoComposition;
@property NSURL * currentAssetSourceUrl;
@property NSMutableDictionary * currentCopiedAsset;
@property CMPersistentTrackID  trackId;
@property  NSArray * comps;
@property NSArray * compsPreviewProxy;
@property NSMutableDictionary * cutClip;
@property CMPersistentTrackID currentAssetTrackId;
@property CMTimeRange currentAssetTimeRangeInMasterComposition;
@property AVMutableCompositionTrack * currentTrack;
@property AVMutableCompositionTrack * currentProxyTrack;
@property NSTrackingArea * disabledTrackingArea;
@end
