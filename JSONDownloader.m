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

- (void)getAllInformationFromCity:(NSString*)city results:(void (^)(NSArray *results))callback{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?type=measurement&city=%@",SERVICE_URL, city];
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
                    callback(dataArray);
                }
            }
            else {
                NSLog(@"suno :%@", error);
                callback(nil);
            }
        });
    }];
    [getDataTask resume];
    
    
    //    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:
    //      ^(NSData *data, NSURLResponse *response, NSError *error) {
    //          id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    //          if ([result isKindOfClass:[NSDictionary class]]) {
    //              NSArray *results = result[@"result"];
    //              callback(results);
    //              NSNumber* numberOfPages = result[@"number_of_pages"];
    //              NSUInteger nextPage = city + 1;
    //              if (nextPage < numberOfPages.unsignedIntegerValue) {
    //                  [self fetchAllPods:callback city:nextPage];
    //              }
    //          }
    //      }] resume];
    
    
}
@end
