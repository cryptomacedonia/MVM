//
//  imageCalibrationPopoverController.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 6/1/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "imageCalibrationPopoverController.h"
#import <CoreImage/CoreImage.h>

@interface imageCalibrationPopoverController ()

@end

@implementation imageCalibrationPopoverController
-(void) getCurrentFilterSettings
{
    
  
}
-(void) timeChanged:(NSNotification*) notification
{
    NSMutableDictionary * selection = [_parentPlayController getSelectionForTime:_parentPlayController.playerView.player.currentTime];
    if (selection[@"filterSettings"])
    {
    _redSlider.doubleValue = [selection[@"filterSettings"][@"_redSlider"] floatValue];
    _greenSlider.doubleValue = [selection[@"filterSettings"][@"_greenSlider"] floatValue];
    _blueSlider.doubleValue = [selection[@"filterSettings"][@"_blueSlider"] floatValue];
    _gammaSlider.doubleValue = [selection[@"filterSettings"][@"_gammaSlider"] floatValue];
    _brightnessSlider.doubleValue = [selection[@"filterSettings"][@"_brightnessSlider"] floatValue];
    _contrastSlider.doubleValue = [selection[@"filterSettings"][@"_contrastSlider"] floatValue];
    _saturationSlider.doubleValue = [selection[@"filterSettings"][@"_saturationSlider"] floatValue];
    _sepiaSlider.doubleValue = [selection[@"filterSettings"][@"_sepiaSlider"] floatValue];
    _hueSlider.doubleValue = [selection[@"filterSettings"][@"_hueSlider"] floatValue];
    _exposureSlider.doubleValue = [selection[@"filterSettings"][@"_exposureSlider"] floatValue];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeChanged:)
                                                 name:@"timeChanged"
                                               object:nil];
    
    // Do view setup here.
     _filterSettings = @{@"_redSlider":@(_redSlider.doubleValue),@"_greenSlider":@(_greenSlider.doubleValue),@"_blueSlider":@(_blueSlider.doubleValue),@"_brightnessSlider":@(_brightnessSlider.doubleValue),@"_contrastSlider":@(_contrastSlider.doubleValue),@"_exposureSlider":@(_exposureSlider.doubleValue),@"_gammaSlider":@(_gammaSlider.doubleValue),@"_hueSlider":@(_hueSlider.doubleValue),@"_sepiaSlider":@(_sepiaSlider.doubleValue),@"_saturationSlider":@(_saturationSlider.doubleValue)};
}


-(void) applyFilter
{
    _filterSettings = @{@"_redSlider":@(_redSlider.doubleValue),@"_greenSlider":@(_greenSlider.doubleValue),@"_blueSlider":@(_blueSlider.doubleValue),@"_brightnessSlider":@(_brightnessSlider.doubleValue),@"_contrastSlider":@(_contrastSlider.doubleValue),@"_exposureSlider":@(_exposureSlider.doubleValue),@"_gammaSlider":@(_gammaSlider.doubleValue),@"_hueSlider":@(_hueSlider.doubleValue),@"_sepiaSlider":@(_sepiaSlider.doubleValue),@"_saturationSlider":@(_saturationSlider.doubleValue)};
    _parentPlayController.currentFilterSettings = _filterSettings;
    CGFloat rArray[] ={_redSlider.doubleValue,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
     CGFloat gArray[] ={0.0,_greenSlider.doubleValue, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
     CGFloat bArray[] ={0.0, 0.0,_blueSlider.doubleValue, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    CIVector *r = [CIVector vectorWithValues:rArray count:10];
     CIVector *g = [CIVector vectorWithValues:gArray count:10];
     CIVector *b = [CIVector vectorWithValues:bArray count:10];
   
    //let g: [CGFloat] = [0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    //let b: [CGFloat] = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    //
    //// apply RGB value to the filter
    //myColorFilter!.setValue(CIVector(values: r, count: 10), forKey: "inputRedCoefficients")
    //myColorFilter!.setValue(CIVector(values: g, count: 10), forKey: "inputGreenCoefficients")
    //myColorFilter!.setValue(CIVector(values: b, count: 10), forKey: "inputBlueCoefficients")
      NSLog(@"brightness:%f contrast:%f saturation:%f",_brightnessSlider.doubleValue,_contrastSlider.doubleValue,_saturationSlider.doubleValue);
    AVVideoComposition * videoComp = [AVVideoComposition videoCompositionWithAsset:_parentPlayController.editedComposition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        float seconds = CMTimeGetSeconds(request.compositionTime);
//       CIImage * filtered =[_parentPlayController getMeFiltersforComposition:_parentPlayController.editedComposition atTime:request.compositionTime request:request];
        CIImage * filtered = request.sourceImage;
        
        
        
        
        
        if (_exposureSlider.doubleValue<.49|_exposureSlider.doubleValue>.51)
        {
            filtered = [filtered imageByApplyingFilter:@"CIExposureAdjust" withInputParameters:@{ @"inputEV":@(_exposureSlider.doubleValue)}];
            
            NSLog(@"exposure change to :%f",_exposureSlider.doubleValue);
            
            
            
        }
        
        if (1)
        {
            /*
             inputImage
             A CIImage object whose display name is Image.
             inputRedCoefficients
             A CIVector object whose display name is RedCoefficients.
             
             Default value: [1 0 0 0 0 0 0 0 0 0] Identity: [1 0 0 0 0 0 0 0 0 0]
             inputGreenCoefficients
             A CIVector object whose display name is GreenCoefficients.
             
             Default value: [0 1 0 0 0 0 0 0 0 0] Identity: [0 1 0 0 0 0 0 0 0 0]
             inputBlueCoefficients
             A CIVector object whose display name is BlueCoefficients.
             
             Default value: [0 0 1 0 0 0 0 0 0 0] Identity: [0 0 1 0 0 0 0 0 0 0]
             
             
             
             */
            
            filtered = [filtered imageByApplyingFilter:@"CIColorCrossPolynomial" withInputParameters:@{@"inputRedCoefficients":r,@"inputGreenCoefficients":g,@"inputBlueCoefficients":b }];
            
            
            
            
            
        }
        
        
//        if (_vintageToggle.state==NSOnState)
//        {
//            filtered = [filtered imageByApplyingFilter:@"  CIPhotoEffectInstant" withInputParameters:@{}];
//         
//          //  NSLog(@"exposure change to :%f",_exposureSlider.doubleValue);
//            
//            
//            
//        }
      
        if (_brightnessSlider.doubleValue>0.51||_brightnessSlider.doubleValue<0.49||_contrastSlider.doubleValue>0.51||_contrastSlider.doubleValue<0.49||_saturationSlider.doubleValue>0.51||_saturationSlider.doubleValue<0.49)
        {
            float brightness = _brightnessSlider.doubleValue;
            float contrast = _contrastSlider.doubleValue;
            float saturation = _saturationSlider.doubleValue;
        filtered = [filtered imageByApplyingFilter:@"CIColorControls" withInputParameters:@{kCIInputSaturationKey:@(saturation),kCIInputContrastKey:@(contrast),kCIInputBrightnessKey:@(brightness)}];
        }
//        filtered = [filtered imageByApplyingFilter:@"CIColorControls" withInputParameters:@{kCIInputSaturationKey:@(_saturationSlider.doubleValue),kCIInputContrastKey:@(_contrastSlider.doubleValue),kCIInputBrightnessKey:@(_brightnessSlider.doubleValue)}];
    
        if (_gammaSlider.doubleValue>.76|_gammaSlider.doubleValue<0.74)
        {
            
            filtered = [filtered imageByApplyingFilter:@"CIGammaAdjust" withInputParameters:@{ @"inputPower":@(_gammaSlider.doubleValue)}];
            
            
            
            
            
        }
        if (_sepiaSlider.doubleValue>1.01)
        {
            filtered = [filtered imageByApplyingFilter:@"CISepiaTone" withInputParameters:@{kCIInputIntensityKey:@(_sepiaSlider.doubleValue)}];
            
            
            
            
            
        }
        
        if (_hueSlider.doubleValue>0.01)
        {
            filtered = [filtered imageByApplyingFilter:@"CIHueAdjust" withInputParameters:@{@"inputAngle":@(_hueSlider.doubleValue)}];
            
            
            
            
            
        }

        
        [request finishWithImage:filtered context:nil];
    }];

    _parentPlayController.playerView.player.currentItem.videoComposition = videoComp;
    
    
    
    
    
}
//inputImage
//A CIImage object whose display name is Image.
//inputSaturation
//An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Saturation.
//
//Default value: 1.00
//inputBrightness
//An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Brightness.
//inputContrast
//An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Contrast.
//
//Default value: 1.00
- (IBAction)redChanged:(id)sender {
   [self applyFilter];
     [self addToSelections];
    
    
}
- (IBAction)GreenChanged:(id)sender {
     [self applyFilter];
     [self addToSelections];
}
- (IBAction)blueChanged:(id)sender {
     [self applyFilter];
     [self addToSelections];
}
- (IBAction)constrastChanged:(id)sender {
   
  
     [self applyFilter];
     [self addToSelections];
    
}
- (IBAction)brightnessChanged:(id)sender {
    [self applyFilter];
     [self addToSelections];
}
- (IBAction)saturationChanged:(id)sender {
     [self applyFilter];
     [self addToSelections];
}

- (IBAction)hueChanged:(id)sender {
    [self applyFilter];
     [self addToSelections];
}
- (IBAction)gammaChanged:(id)sender {
    [self applyFilter];
     [self addToSelections];
    
}
- (IBAction)exposureChanged:(id)sender {
    [self applyFilter];
     [self addToSelections];
}
- (IBAction)sepiaChanged:(id)sender {
    [self applyFilter];
     [self addToSelections];
}
- (IBAction)viontageStateChange:(id)sender {
    [self applyFilter];
    [self addToSelections];
}

-(void) addToSelections
{
    
    CMTime currentTime = _parentPlayController.playerView.player.currentTime;
    NSMutableDictionary * selection = [_parentPlayController getSelectionForTime:currentTime];
    [ selection setObject:_filterSettings forKey:@"filterSettings"];

    NSLog(@"selection:%@",selection);
    [_parentPlayController  applyFilterHereForSelection];
    
}




@end
