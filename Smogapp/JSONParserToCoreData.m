//
//  JSONParserToCoreData.m
//  Smogapp
//
//  Created by Piotr Torczyski on 14/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "JSONParserToCoreData.h"
#import "Station+CoreDataProperties.h"
#import "Pollution+CoreDataProperties.h"
#import "AppDelegate.h"

@interface JSONParserToCoreData()
@property NSInteger counterOfResurces;
@property NSInteger cityNumber;
@property NSArray *citiesArrayFromRawJSON;

@end

@implementation JSONParserToCoreData

- (instancetype)init {
    if (self = [super init]) {
        
        self.counterOfResurces = 0;
        
    }
    return self;
}

- (NSDictionary *)sanitizedDictionaryWithJSON:(id)JSON {
    id returnData;
    
    if([JSON isKindOfClass:[NSDictionary class]]){
        
        NSMutableDictionary *mutableJSON = [JSON mutableCopy];
        
        for (NSString *key in mutableJSON.allKeys) {
            if (mutableJSON[key] == [NSNull null]) {
                [mutableJSON removeObjectForKey:key];
            }
        }
//        self.counterOfResurces++;
        returnData = [mutableJSON copy];
    }
    else if([JSON isKindOfClass:[NSArray class]]){
        
        NSMutableDictionary *sanitezJSON ;
        NSMutableArray *mutableJSONArray = [JSON mutableCopy];
        
        for (id arrayObject in mutableJSONArray) {
            
            for (NSString *key in sanitezJSON.allKeys) {
                if (sanitezJSON[key] == [NSNull null]) {
                    [sanitezJSON removeObjectForKey:key];
                }
            }
            
        }
        returnData = [mutableJSONArray copy];
    }
    else{
        
        NSLog(@"Error in casting response");
    }
    
    //    NSMutableDictionary *mutableJSON = [JSON mutableCopy];
    //    for (NSString *key in mutableJSON.allKeys) {
    //        if (mutableJSON[key] == [NSNull null]) {
    //            [mutableJSON removeObjectForKey:key];
    //        }
    //    }
    //    self.counterOfResurces++;
    
    //    return [mutableJSON copy];
    
    return returnData;
}



-(void)parseCitiesFromJSON:(id)JSON{
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext]
    ;
    Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
    
    
    
    station.city = sanitizedJSON[@"citydesc"];
    //    station.name = sanitizedJSON[@"locaiondesc"];
    //    station.longitude = sanitizedJSON[@"long"];
    //    station.lattitude = sanitizedJSON[@"lat"];
    
    
    //        NSArray *citiesArray = sanitizedJSON[@"city"];
    //        self.citiesArrayFromRawJSON = [[NSMutableArray alloc]init];
    //        for(NSNumber * cityName in citiesArray){
    
    
    //        }
    
    NSLog(@"%@",station.city);
    
}

-(void)parsePollutionFromJSON:(id)JSON{
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    
    Pollution *pollution = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution" inManagedObjectContext:self.context];
    
    pollution.date = sanitizedJSON[@"date"];
    pollution.desc = sanitizedJSON[@"caqidesc"];
    pollution.name = sanitizedJSON[@"parameterdesc"];
    pollution.value = sanitizedJSON[@"value"];
    
}
-(void)parseStationFromJSON:(id)JSON{
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.context];
    
    station.city = sanitizedJSON[@"citydesc"];
    station.name = sanitizedJSON[@"locaiondesc"];
    station.longitude = sanitizedJSON[@"long"];
    station.lattitude = sanitizedJSON[@"lat"];
}
@end
