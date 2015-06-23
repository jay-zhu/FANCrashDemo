//
//  HTFBAdDownloader.m
//  HighTea_V4
//
//  Created by Jay on 5/12/15.
//  Copyright (c) 2015 Trusper. All rights reserved.
//

#import "HTFBAdDownloader.h"
#import "HTFBAdRequest.h"
#import "HTFBAdRequestDelegate.h"

@interface HTFBAdDownloader() <HTFBAdRequestDelegate>
@property (strong, nonatomic) NSMutableDictionary *callbacks;
@property (strong, nonatomic) NSMutableDictionary *requests;
@end

@implementation HTFBAdDownloader

+ (instancetype)sharedInstance {
    static HTFBAdDownloader *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HTFBAdDownloader alloc]init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _callbacks = [NSMutableDictionary dictionary];
    _requests = [NSMutableDictionary dictionary];
    return self;
}

- (void)downloadFBAdWithPlacementId:(NSString *)placementId count:(NSInteger)count completeBlock:(HTFBAdDownloaderCompletedBlock)completeBlock
{
    if (!placementId || count < 1 || completeBlock == nil) {
        return;
    }
    
    NSDate *requestDate = [NSDate date];
    NSNumber *taskId = @([requestDate timeIntervalSinceReferenceDate]);
    if (completeBlock) {
        self.callbacks[taskId] = [completeBlock copy];
    }
    NSMutableSet *requests = [NSMutableSet set];
    self.requests[taskId] = requests;
    for (NSInteger i = 0; i < count; ++i) {
        HTFBAdRequest *request = [[HTFBAdRequest alloc]initWithPlacementId:placementId];
        request.requestId = taskId;
        request.delegate = self;
        [requests addObject:request];
        [request loadNativeAd];
    }
}

#pragma mark - private
- (BOOL)isTaskFinished:(NSNumber *)taskId
{
    if ([taskId isKindOfClass:[NSNumber class]]) {
        NSMutableSet *requests = self.requests[taskId];
        for (HTFBAdRequest *request in requests) {
            if (request.status == HTFBAdRequestStatusDefault) {
                return false;
            }
        }
        return true;
    }
    return false;
}

- (void)checkAndRunCallback:(HTFBAdRequest *)request
{
    NSNumber *taskId = request.requestId;
    
    if ([taskId isKindOfClass:[NSNumber class]]) {
        HTFBAdDownloaderCompletedBlock completeBlock = self.callbacks[taskId];
        if (completeBlock) {
            if ([self isTaskFinished:taskId]) {
                NSMutableArray *successRequests = [NSMutableArray array];
                NSMutableSet *requests = self.requests[taskId];
                for (HTFBAdRequest *request in requests) {
                    if (request.status == HTFBAdRequestStatusSuccess) {
                        [successRequests addObject:request];
                    }
                }
                //clean
                [self.requests removeObjectForKey:taskId];
                [self.callbacks removeObjectForKey:taskId];
                
                //run callback
                completeBlock(successRequests);
                
            }
        }
    }
}

#pragma mark - ad request delegate
- (void)fBAdRequestDidLoaded: (HTFBAdRequest *)request
{
    request.delegate = nil;
    [self checkAndRunCallback:request];
}

- (void)fBAdRequest: (HTFBAdRequest *)request didFailWithError:(NSError *)error
{
    request.delegate = nil;
    [self checkAndRunCallback:request];
}

@end
