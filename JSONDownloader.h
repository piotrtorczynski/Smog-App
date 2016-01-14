//
//  JSONDownloader.h
//  Smogapp
//
//  Created by Piotr Torczyski on 12/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONDownloader : NSObject

@property (nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableDictionary *httpHeaders;

typedef void (^JSONDownloaderCompletionBlock)(BOOL parseSuccess, NSArray *response, NSError *connectionError);
- (void)getAllCities :(JSONDownloaderCompletionBlock)callback;
- (void)getAllInformationFromCity: (NSString*) city :(JSONDownloaderCompletionBlock)callback;
- (void)getAllInformationFromCityAndLocation: (NSString*) city :(NSString *) location :(JSONDownloaderCompletionBlock)callback;

- (void)getLastInformationFromCity: (NSString*) city :(JSONDownloaderCompletionBlock)callback;
- (void)getLastInformationFromCityAndLocation: (NSString*) city :(NSString *) location :(JSONDownloaderCompletionBlock)callback;
@end
