//
//  customImageView.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 4/21/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "customImageView.h"

@implementation customImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    _linked = YES;
   
    [self setWantsLayer:YES];
        self.layer.masksToBounds = YES;
    self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    
   
    
    self.layer.needsDisplayOnBoundsChange = YES;
    if (_linkButton==nil)
    {
        
        _linkButton= [[NSButton alloc] initWithFrame:NSMakeRect(0.0, self.frame.size.height-25, 25.0, 25.0)];
   // [_linkButton setButtonType:NSMomentaryPushInButton];
   // [_linkButton setTitle:@"U"];
    [_linkButton setToolTip:@"unlink"];
        [_linkButton setImage:[NSImage imageNamed:@"button_u.png"]];
        [_linkButton setImagePosition:NSImageOnly];
        [_linkButton setBordered:NO];
    [_linkButton setAction:@selector(buttonAction)];
    [_linkButton setTarget:self];
//   _linkButton.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:_linkButton];
    
  
    
    }
    // Drawing code here.
}

-(void) buttonAction
{
    if (_linked)
    {
        _linked = NO;
        [_linkButton setTitle:@"L"];
        [self disableTraCkingArea];
    }
    else
    {
        [_linkButton setTitle:@"U"];
        _linked = YES;
        [self enableTrackingArea];
    }
    
    
    
}

-(void)mouseDown:(NSEvent *)event
{
    [super mouseDown:event];
    if (!_linked)
    {
        if (CMTimeCompare(_time1,kCMTimeInvalid)==0)
        {
            _time1 = _player.currentTime;
            _drawInOut = YES;
            
            
            
        } else if (CMTimeCompare(_time2,kCMTimeInvalid)==0)
        {
            
            
            _time2 = _player.currentTime;
            _drawInOut = YES;

            
            
        }
            
        
        
        
        
    }
    
    
}
-(void)mouseEntered:(NSEvent *)theEvent {
    NSLog(@"Mouse entered");
}

-(void)mouseExited:(NSEvent *)theEvent
{
    NSLog(@"Mouse exited");
}
-(void)disableTraCkingArea
{
  
      //  [self removeTrackingArea:self.trackingArea];
        
    self.alphaValue = 0.5f;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
}
-(void)enableTrackingArea
{
    _inPoint = kCMTimeZero;
    _outPoint = _assetUsedForAngle.duration;
   _assetDuration = CMTimeGetSeconds(_assetUsedForAngle.duration);
    
    if(self.trackingArea != nil) {
        [self removeTrackingArea:self.trackingArea];
        
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingCursorUpdate | NSTrackingMouseMoved);
    self.trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
  
    _player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@PROXY.MP4",NSTemporaryDirectory(),[doo generateMD5Hash:[_assetUsedForAngle.URL path]]]]];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    [_playerLayer setFrame:self.bounds];
    [self.layer addSublayer:_playerLayer];
   // _playerLayer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.alphaValue = 1.0;
    _scrubber = [[NSView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 5, self.frame.size.height)];
    _scrubber.wantsLayer = YES;
  //  _scrubber.canDrawSubviewsIntoLayer = YES;
    _scrubber.layer.backgroundColor =[[NSColor redColor] CGColor];
    [self.playerLayer addSublayer:_scrubber.layer];
    [self addTrackingArea:self.trackingArea];
    
}
- (void)layoutSubviews {
    // resize your layers based on the view's new frame
    self.layer.frame = self.bounds;
}
- (void)mouseMoved:(NSEvent *)theEvent {
     [super mouseMoved: theEvent];
    NSPoint eyeCenter = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSRect scrubberPrevousFrame = _scrubber.layer.frame;
    scrubberPrevousFrame.origin.x =eyeCenter.x;
    float e = scale(eyeCenter.x, 0, self.layer.frame.size.width, 0,self.assetDuration );
    [_player seekToTime:CMTimeMakeWithSeconds(e, 30)];
    NSLog(@"duration = %f scrubber x = %f e = %f",self.assetDuration,scrubberPrevousFrame.origin.x,e);
    //_scrubber.layer.frame = scrubberPrevousFrame;
         //   NSPoint positionNow = _scrubber.layer.position;
       [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    _scrubber.layer.position = CGPointMake(eyeCenter.x, 0);
    [CATransaction commit];
      //
   // eyeBox = NSMakeRect((eyeCenter.x-10.0), (eyeCenter.y-10.0), 20.0, 20.0);
  //  NSLog(@"cursor ->(%f, %f) ",eyeCenter.x,eyeCenter.y);
    //[self setNeedsDisplayInRect:eyeBox];
    [self displayIfNeeded];
}

//-(CMTime) getTimeForMouseLocation:(float) x
//{
//    
//    float test = scale(x, 0, self.fra, <#double limitMin#>, <#double limitMax#>)
//    return 0;
//}


float scale( float valueIn,  float baseMin,  float baseMax,  float limitMin,  float limitMax) {
    return ((limitMax - limitMin) * (valueIn - baseMin) / (baseMax - baseMin)) + limitMin;
}

//-(BOOL)acceptsFirstResponder
//{
//    return YES;
//}


//-(BOOL)becomeFirstResponder
//{
//    return YES;
//}
//- (void)keyDown:(NSEvent *)event
//{
//    [super keyDown:event];
//    
//    
//    
//}
















































-(void)awakeFromNib
{
   // [self setEditable:YES];
}

-(void) setInPoint
{
    _inPoint = self.player.currentTime;
}
-(void) setOutPoint
{
    _outPoint = self.player.currentTime;
}
@end
