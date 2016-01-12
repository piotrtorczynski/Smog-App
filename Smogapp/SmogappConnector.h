//
//  SmogappConnector.h
//  Smogapp
//
//  Created by Piotr Torczyski on 11/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SmogappConnector : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>


typedef void (^SmogAppCompletionBlock)(BOOL parseSuccess, NSArray *response, NSError *connectionError);


- (BOOL)isInternetConnection;
- (void)getAkkResultFromCity:(NSString*) city WithResponse:(SmogAppCompletionBlock)callback;
- (void)fdfd:(NSDictionary*)dicObject WithResponse:(SmogAppCompletionBlock)callback;

@end
