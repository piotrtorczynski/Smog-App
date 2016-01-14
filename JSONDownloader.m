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
- (void)getAllCities :(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=lastmeasurement"] withResults:callback];
}

- (void)getAllInformationFromCity: (NSString*) city :(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=measurement&city=%@", city] withResults:callback];
}

- (void)getAllInformationFromCityAndLocation: (NSString*) city :(NSString *) location :(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=measurement&city=%@&lcation=%@", city,location] withResults:callback];
}

- (void)getLastInformationFromCity: (NSString*) city :(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=lastmeasurement&city=%@", city] withResults:callback];
}

- (void)getLastInformationFromCityAndLocation: (NSString*) city :(NSString *) location :(JSONDownloaderCompletionBlock)callback{
    [self getServerResponeFor:[NSString stringWithFormat:@"type=lastmeasurement&city=%@&lcation=%@", city,location] withResults:callback];
}

- (void)getServerResponeFor:(NSString*) body withResults:(JSONDownloaderCompletionBlock)callback{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",SERVICE_URL, body];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    __weak JSONDownloader *weakSelf = self;
    [request setTimeoutInterval:240];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *getDataTask = [weakSelf.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (httpResp.statusCode == 200) {
                
                NSError *jsonError;
                BOOL success = NO;
                NSArray *dataArray = [[NSArray alloc] init];
                dataArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
                
                if (jsonError) {
                    NSLog(@"Error parsing JSON: %@", jsonError);
                } else {
                    success = YES;
                    callback(success, dataArray, error);
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
