//
//  HTFBAdNotice.m
//  HighTea_V4
//
//  Created by Jay on 3/25/15.
//  Copyright (c) 2015 Trusper. All rights reserved.
//

#import "HTFBAdRequest.h"

@implementation HTFBAdRequest

- (instancetype)initWithPlacementId:(NSString *)placementId
{
    self = [super init];
    if (self) {
        _isLoading = false;
        _nativeAd = nil;
        _placementId = placementId;
        _status = HTFBAdRequestStatusDefault;
    }
    return self;
}

- (void)dealloc
{
    [self.nativeAd unregisterView];
    self.delegate = nil;
}

- (BOOL)isAdExpire
{
    if (!self.loadedDate) {
        return true;
    }
    
    return -[self.loadedDate timeIntervalSinceNow] > 3600;
}

#pragma mark - load ad
- (void)loadNativeAd
{
    if (!self.isLoading && self.placementId) {
        FBNativeAd *nativeAd = [[FBNativeAd alloc] initWithPlacementID:self.placementId];
        nativeAd.delegate = self;
        self.isLoading = true;
        [nativeAd loadAd];
    }
}

#pragma mark - FB Ad Delegate
- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad was loaded, constructing native UI...");
    
    if (self.nativeAd) {
        // Since we re-use the same UITableViewCell to show different ads over time, we call
        // unregisterView before registering the same view with a different   instance of FBNativeAd.
        [self.nativeAd unregisterView];
    }
    self.nativeAd = nativeAd;
    self.isLoading = false;
    self.loadedDate = [NSDate date];
    self.status = HTFBAdRequestStatusSuccess;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fBAdRequestDidLoaded:)]) {
        [self.delegate fBAdRequestDidLoaded:self];
    }
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@, %@", error,error.userInfo);
    if (self.nativeAd) {
        // Since we re-use the same UITableViewCell to show different ads over time, we call
        // unregisterView before registering the same view with a different   instance of FBNativeAd.
        [self.nativeAd unregisterView];
    }
    self.isLoading = false;
    self.status = HTFBAdRequestStatusFail;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fBAdRequest:didFailWithError:)]) {
        [self.delegate fBAdRequest:self didFailWithError:error];
    }
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad was clicked.");
}

- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad did finish click handling.");
}

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad impression is being captured.");
}

@end
