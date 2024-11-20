//
//  globalData.h
//  Wedding Video Maker Pro
//
//  Created by Igor Jovcevski on 5/6/17.
//  Copyright © 2017 Woowave. All rights reserved.
//

#import <foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface globalData : NSObject {
    NSString *someProperty;
}

@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic, retain) NSMutableArray *assetTracks;
+ (id)sharedManager;

@end
