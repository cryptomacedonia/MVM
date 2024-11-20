//
//  globalData.m
//  Wedding Video Maker Pro
//
//  Created by Igor Jovcevski on 5/6/17.
//  Copyright © 2017 Woowave. All rights reserved.
//

#import "globalData.h"

@implementation globalData



#pragma mark Singleton Methods

+ (id)sharedManager {
    static globalData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _someProperty = @"Default Property Value";
        _assetTracks = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
