//
//  HTFBAdDownloader.h
//  HighTea_V4
//
//  Created by Jay on 5/12/15.
//  Copyright (c) 2015 Trusper. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HTFBAdDownloaderCompletedBlock)(NSArray *ads);

@interface HTFBAdDownloader : NSObject

+ (instancetype)sharedInstance;
- (void)downloadFBAdWithPlacementId:(NSString *)placementId count:(NSInteger)count completeBlock:(HTFBAdDownloaderCompletedBlock)completeBlock;

@end
