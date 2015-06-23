//
//  HTFBAdNotice.h
//  HighTea_V4
//
//  Created by Jay on 3/25/15.
//  Copyright (c) 2015 Trusper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import "HTFBAdRequestDelegate.h"

typedef NS_ENUM(NSInteger, HTFBAdRequestStatus) {
    HTFBAdRequestStatusDefault,
    HTFBAdRequestStatusSuccess,
    HTFBAdRequestStatusFail
};

@interface HTFBAdRequest : NSObject <FBNativeAdDelegate>
@property (strong, nonatomic) FBNativeAd *nativeAd;
@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic) NSDate *loadedDate;
@property (strong, nonatomic) NSNumber *requestId;
@property (strong, nonatomic) NSString *placementId;
@property (strong, nonatomic) NSString *mode; // use for A/B test
@property (assign, nonatomic) HTFBAdRequestStatus status;
@property (weak, nonatomic) id<HTFBAdRequestDelegate> delegate;

- (instancetype)initWithPlacementId:(NSString *)placementId;
- (void)loadNativeAd;
- (BOOL)isAdExpire;
@end
