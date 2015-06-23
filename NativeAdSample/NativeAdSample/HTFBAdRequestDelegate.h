//
//  HTFBAdRequestDelegate.h
//  HighTea_V4
//
//  Created by Jay on 3/28/15.
//  Copyright (c) 2015 Trusper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTFBAdRequest;

@protocol HTFBAdRequestDelegate <NSObject>

@optional
- (void)fBAdRequestDidLoaded: (HTFBAdRequest *)request;
- (void)fBAdRequest: (HTFBAdRequest *)request didFailWithError:(NSError *)error;
@end
