//
//  JSONDownloader.h
//  Smogapp
//
//  Created by Piotr Torczyski on 12/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONDownloader : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableDictionary *httpHeaders;

typedef void (^JSONDownloaderCompletionBlock)(BOOL parseSuccess, NSArray *response, NSError *connectionError);

- (void)getAllInformationFromCity:(NSString*)city callback:(JSONDownloaderCompletionBlock)callback;
- (void)getAllParametersFromCityAndLocation:(NSString*)city location:(NSString *)location callback:(JSONDownloaderCompletionBlock)callback;

@end
