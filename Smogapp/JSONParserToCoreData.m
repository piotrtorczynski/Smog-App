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

- (id )sanitizedDictionaryWithJSON:(id)JSON {
    id returnData;
    
    if([JSON isKindOfClass:[NSDictionary class]]){
        
        NSMutableDictionary *mutableJSON = [JSON mutableCopy];
        
        for (NSString *key in mutableJSON.allKeys) {
            if (mutableJSON[key] == [NSNull null]) {
                [mutableJSON removeObjectForKey:key];
            }
        }
        returnData = [mutableJSON copy];
    }
    else if([JSON isKindOfClass:[NSArray class]]){
        
        NSMutableDictionary *sanitezJSON ;
        NSMutableArray *mutableJSONArray = [JSON mutableCopy];
        
        for (sanitezJSON in mutableJSONArray) {
            
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
    
    
    return returnData;
}


-(NSArray *)parseLocationFromJSON:(id)JSON{
    
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    NSArray *cityLocations;
    
    
    NSSet* locations;
    for (id dict in sanitizedJSON){
        locations = [NSSet setWithArray: [sanitizedJSON valueForKey: @"location"]];
        NSLog(@"%@", locations);
    }
    cityLocations =  [locations allObjects];
    return cityLocations;
    
}



-(void)parseCitiesFromJSON:(id)JSON{
    
    id sanitizedJSONArray = [self sanitizedDictionaryWithJSON:JSON];
    
    if([JSON isKindOfClass:[NSDictionary class]]){
        
        NSMutableDictionary *mutableJSON = [JSON mutableCopy];
        
        for (NSString *key in mutableJSON.allKeys) {
            //tutaj sie dzieje
        }
        //        returnData = [mutableJSON copy];
    }
    else if([JSON isKindOfClass:[NSArray class]]){
        
        NSMutableDictionary *sanitezJSON ;
        NSMutableArray *mutableJSONArray = [JSON mutableCopy];
        
        for (sanitezJSON in mutableJSONArray) {
            
            for (NSString *key in sanitezJSON.allKeys) {
                //tutaj tez}
                
            }
            //        returnData = [mutableJSONArray copy];
        }
    }
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (id dict in sanitizedJSONArray){
        
        for(id key in dict){
            //            NSLog(@"%d",i++);
            
            station.city = dict[@"citydesc"];
            station.name = dict[@"parameterdesc"];
            station.longitude = [f numberFromString: dict[@"long"]];
            station.lattitude = [f numberFromString: dict[@"lat"]];
            
        }
    }
    
    
    NSLog(@"%@",station.longitude);
    NSLog(@"%@",station.lattitude);
}


-(void)parsePollutionFromJSON:(id)JSON{
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    
    Pollution *pollution = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution" inManagedObjectContext:self.context];
    
    pollution.date = sanitizedJSON[@"date"];
    pollution.desc = sanitizedJSON[@"caqidesc"];
    pollution.name = sanitizedJSON[@"parameterdesc"];
    pollution.value = sanitizedJSON[@"value"];
    
}

-(void)parseStationFromLocationJSON:(id)JSON{
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
    Pollution *pollution = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution" inManagedObjectContext:context];
    
    
    if([JSON isKindOfClass:[NSDictionary class]]){
        
        NSMutableDictionary *mutableJSON = [JSON mutableCopy];
        
        for (NSString *key in mutableJSON.allKeys) {
            
            pollution.date = sanitizedJSON[@"date"];
            pollution.desc = sanitizedJSON[@"caqidesc"];
            pollution.name = sanitizedJSON[@"parameterdesc"];
            pollution.value = sanitizedJSON[@"value"];
            
            station.city = sanitizedJSON[@"citydesc"];
            station.name = sanitizedJSON[@"parameterdesc"];
            station.longitude = [f numberFromString: sanitizedJSON[@"long"]];
            station.lattitude = [f numberFromString: sanitizedJSON[@"lat"]];
            
        }
        
    }
    else if([JSON isKindOfClass:[NSArray class]]){
        
        NSMutableDictionary *sanitezJSON ;
        NSMutableArray *mutableJSONArray = [JSON mutableCopy];
        
        for (sanitezJSON in mutableJSONArray) {
            
            for (NSString *key in sanitezJSON.allKeys) {
            
                
            }
            
        }
    }
    
    
    
    
}
@end
