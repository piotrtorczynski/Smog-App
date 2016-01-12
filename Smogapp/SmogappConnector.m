//
//  SmogappConnector.m
//  Smogapp
//
//  Created by Piotr Torczyski on 11/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "SmogappConnector.h"
#import "Reachability/Reachability.h"
// @"powietrze.malopolska.pl/data/data.php?";

@implementation SmogappConnector


- (void)getAkkResultFromCity:(NSString*) city WithResponse:(SmogAppCompletionBlock)callback{

   
}


- (BOOL)isInternetConnection {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable)
        
    {
        // Write your code here.
        return YES;
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return NO;
    }
    
}


- (void)postVisitWithJSON:(NSDictionary*)dicObject WithResponse:(SmogAppCompletionBlock)callback{
    
    
}


@end
