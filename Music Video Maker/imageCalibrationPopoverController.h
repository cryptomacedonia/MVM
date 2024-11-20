//
//  imageCalibrationPopoverController.h
//  Music Video Maker
//
//  Created by Igor Jovcevski on 6/1/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "playController.h"
@class playController;
@interface imageCalibrationPopoverController : NSViewController
@property (weak) IBOutlet NSSlider *gammaSlider;
@property playController * parentPlayController;
@property (weak) IBOutlet NSSlider *redSlider;
@property (weak) IBOutlet NSSlider *greenSlider;
@property (weak) IBOutlet NSSlider *blueSlider;
@property (weak) IBOutlet NSSlider *brightnessSlider;
@property (weak) IBOutlet NSSlider *contrastSlider;
@property (weak) IBOutlet NSSlider *hueSlider;
@property (weak) IBOutlet NSSlider *saturationSlider;
@property (weak) IBOutlet NSSlider *exposureSlider;
@property (weak) IBOutlet NSSlider *sepiaSlider;
@property (weak) IBOutlet NSButtonCell *vintageToggle;
@property NSDictionary * filterSettings;

@end
