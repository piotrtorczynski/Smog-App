//
//  JSONDownloader.m
//  Smogapp
//
//  Created by Piotr Torczyski on 12/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "JSONDownloader.h"

@interface JSONDownloader ()

@property (strong, nonatomic) NSArray *dataParse;
@property (strong, nonatomic) NSOperationQueue *queue;

@end


@implementation JSONDownloader

void(^getServerResponseForUrlCallback)(BOOL success, NSArray *response, NSError *error);

NSString * SERVICE_URL=@"http://powietrze.malopolska.pl/data/data.php";

-(instancetype)init{
    if (self == [super init]) {
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
        
        self.httpHeaders = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                             @"Accept"            : @"application/json",
                                                                             @"Content-Type"      : @"application/json"
                                                                             }];
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
        
        sessionConfiguration.HTTPAdditionalHeaders = self.httpHeaders;
        
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:self.queue];
        
        
    }
    
    return self;
}
- (void)getAllCitiesFromCallback :(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=lastmeasurement"] withResults:callback];
}

- (void)getAllInformationFromCity:(NSString*)city callback:(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=smartmeasurement&city=%@", city] withResults:callback];
}

- (void)getAllInformationFromCityAndLocation:(NSString*)city location:(NSString *)location callback:(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=measurement&city=%@&location=%@", city,location] withResults:callback];
}


- (void)getParameterFromCityAndLocation: (NSString*) city location:(NSString *)location parameterType:(NSString*)parameterType callback:(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=lastmeasurement&city=%@&location=%@&parameter=%@", city,location, parameterType] withResults:callback];
}

- (void)getLastInformationFromCity: (NSString*) city :(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=lastmeasurement&city=%@", city] withResults:callback];
}

- (void)getAllParametersFromCityAndLocation:(NSString*)city location:(NSString *)location callback:(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=lastmeasurement&city=%@&location=%@", city,location] withResults:callback];
}

- (void)getServerResponeFor:(NSString*) body withResults:(JSONDownloaderCompletionBlock)callback{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",SERVICE_URL, body];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSLog(@"%@", request);
    __weak JSONDownloader *weakSelf = self;
    [request setTimeoutInterval:240];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *getDataTask = [weakSelf.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (httpResp.statusCode == 200) {
                
                NSError *jsonError;
                BOOL success = NO;
                
                id dataFetch = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
                
                if (jsonError) {
                    NSLog(@"Error parsing JSON: %@", jsonError);
                } else {
                    NSLog(@"Fetched ok");
                    success = YES;
                    callback(success, dataFetch, error);
                }
            }
            else {
                NSLog(@"suno :%@", error);
                callback(NO, nil, error);            }
        });
    }];
    [getDataTask resume];
}
@end
