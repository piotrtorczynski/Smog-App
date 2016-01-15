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
- (void)getAllCitiesFromCallback:(JSONDownloaderCompletionBlock)callback;
- (void)getAllInformationFromCity:(NSString*)city callback:(JSONDownloaderCompletionBlock)callback;
- (void)getAllInformationFromCityAndLocation:(NSString*)city location:(NSString *)location callback:(JSONDownloaderCompletionBlock)callback;

- (void)getParameterFromCityAndLocation:(NSString*)city location:(NSString *)location parameterType:(NSString*)parameterType callback:(JSONDownloaderCompletionBlock)callback;
- (void)getLastInformationFromCity: (NSString*) city :(JSONDownloaderCompletionBlock)callback;
- (void)getAllParametersFromCityAndLocation:(NSString*)city location:(NSString *)location callback:(JSONDownloaderCompletionBlock)callback;

@end
