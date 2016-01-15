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

@interface JSONParserToCoreData()
@property NSInteger counterOfResurces;
@property NSInteger cityNumber;
@property NSArray* citiesArrayFromRawJSON;

@end

@implementation JSONParserToCoreData

- (instancetype)init {
    if (self = [super init]) {
        
        self.counterOfResurces = 0;
        
    }
    return self;
}

- (NSDictionary *)sanitizedDictionaryWithJSON:(NSDictionary *)JSON {
    NSMutableDictionary *mutableJSON = [JSON mutableCopy];
    for (NSString *key in mutableJSON.allKeys) {
        if (mutableJSON[key] == [NSNull null]) {
            [mutableJSON removeObjectForKey:key];
        }
    }
    self.counterOfResurces++;
    return [mutableJSON copy];
}

-(void)parseCitiesFromJSON:(NSDictionary *)JSON{
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    
    Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.context];
    
//    station.city = sanitizedJSON[@"citydesc"];
//    station.name = sanitizedJSON[@"locaiondesc"];
//    station.longitude = sanitizedJSON[@"long"];
//    station.lattitude = sanitizedJSON[@"lat"];

    
//    NSArray *citiesArray = sanitizedJSON[@"city"];
//    self.citiesArrayFromRawJSON = [[NSMutableArray alloc]init];
//    for(NSNumber * cityName in citiesArray){
//    
//        NSLog(@"City name: %@",cityName);
//        [self.citiesArrayFromRawJSON obj];
//    }

}

-(void)parsePollutionFromJSON:(NSDictionary *)JSON{
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    
    Pollution *pollution = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution" inManagedObjectContext:self.context];
    
    pollution.date = sanitizedJSON[@"date"];
    pollution.desc = sanitizedJSON[@"caqidesc"];
    pollution.name = sanitizedJSON[@"parameterdesc"];
    pollution.value = sanitizedJSON[@"value"];
    
   }
@end
