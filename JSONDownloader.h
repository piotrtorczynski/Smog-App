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

- (void)getAllInformationFromCity:(void (^)(NSArray *results))callback;
- (void)getAllInformationFromCity:(void (^)(NSArray *results))callback;
@end
