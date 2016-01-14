//
//  JSONParserToCoreData.m
//  Smogapp
//
//  Created by Piotr Torczyski on 14/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "JSONParserToCoreData.h"
#import "Station+CoreDataProperties.h"

@interface JSONParserToCoreData()
@property NSInteger counterOfResurces;
@property NSInteger cityNumber;
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
    
    station.city = sanitizedJSON[@"citydesc"];
    station.name = sanitizedJSON[@"locaiondesc"];
    station.longitude = sanitizedJSON[@"long"];
    station.lattitude = sanitizedJSON[@"lat"];
//    [station addParametersObject: ]

}


@end
