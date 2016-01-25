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

@property NSArray *citiesArrayFromRawJSON;
@property NSArray *timeStamps;
@property NSArray *stationArray;
@property NSNumber *timeStamp;
@property NSString *longitude;
@property NSString *lattitude;
@property  Station *stations;
@property NSArray *pollutionsArray;
@end

@implementation JSONParserToCoreData

- (instancetype)init {
    if (self = [super init]) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.context = appDelegate.managedObjectContext;
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
    
    locations = [NSSet setWithArray: [sanitizedJSON valueForKey: @"location"]];
    cityLocations =  [locations allObjects];
    
    return cityLocations;
    
}

-(void)parseStationFromLocationJSON:(id)JSON{
    NSDictionary *sanitizedJSON = [self sanitizedDictionaryWithJSON:JSON];
    NSError *error = nil;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    
    NSMutableArray *mutableJSONArray = [JSON mutableCopy];
    NSDictionary *firsDictionary = [mutableJSONArray objectAtIndex:1];
    
    self.timeStamp = [firsDictionary valueForKey:@"timestamp"];
    self.longitude = [firsDictionary valueForKey:@"long"];
    self.lattitude = [firsDictionary valueForKey:@"lat"];
    
    //    NSPredicate *timestampPredicate = [NSPredicate predicateWithFormat:@"timestamp == %@",self.timeStamp];
    NSPredicate *longitudePredicate = [NSPredicate predicateWithFormat:@"lattitude == %@",self.lattitude];
    NSPredicate *lattitudePredicate = [NSPredicate predicateWithFormat:@"longitude == %@",self.longitude];
    
    NSPredicate *fetchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[lattitudePredicate, longitudePredicate]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    [fetchRequest setPredicate:fetchPredicate];
    
    
    self.stationArray = [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.stations = [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if(self.stationArray.count == nil ){
        
        if([JSON isKindOfClass:[NSDictionary class]]){
            Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.context];
            Pollution *pollution = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution" inManagedObjectContext:self.context];
            
            NSMutableDictionary *mutableJSON = [JSON mutableCopy];
            
            for (NSString *key in mutableJSON.allKeys) {
                pollution.date = sanitizedJSON[@"date"];
                
                if (sanitizedJSON[@"caqidesc"] == nil) {
                    pollution.desc = sanitizedJSON[@"aqidesc"];
                }
                else {
                    pollution.desc = sanitizedJSON[@"caqidesc"];
                }
                
                pollution.name = sanitizedJSON[@"parameterdesc"];
                pollution.value = [NSNumber numberWithDouble:[sanitizedJSON[@"value"] integerValue]];
                pollution.timestamp = sanitizedJSON[@"timestamp"];
                pollution.unit = sanitizedJSON[@"unit"];
                
                station.name = sanitizedJSON[@"parameterdesc"];
                station.location = sanitizedJSON[@"location"];
                station.locationdesc = sanitizedJSON[@"locationdesc"];
                station.timestamp = [NSNumber numberWithInt:[sanitizedJSON[@"timestamp"]integerValue]];
                station.longitude = [f numberFromString: sanitizedJSON[@"long"]];
                station.lattitude = [f numberFromString: sanitizedJSON[@"lat"]];
                
                [station addParametersObject:pollution];
            }
            
        }
        else if([JSON isKindOfClass:[NSArray class]]){
            
            Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.context];
            
            NSMutableDictionary *dictionaryJSON ;
            NSMutableArray *mutableJSONArray = [JSON mutableCopy];
            NSDictionary *firsDictionary = [mutableJSONArray objectAtIndex:1];
            NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
            formater.numberStyle = NSNumberFormatterCurrencyStyle;
            
            
            //        station.city = firsDictionary[@"city"] ;
            station.name = firsDictionary[@"parameterdesc"];
            station.locationdesc = firsDictionary[@"locationdesc"];
            station.longitude =  [NSNumber numberWithDouble:[firsDictionary[@"long"] doubleValue]];
            station.lattitude = [NSNumber numberWithDouble:[firsDictionary[@"lat"] doubleValue]];
            station.location = firsDictionary[@"location"];
            station.timestamp = [NSNumber numberWithInt:[firsDictionary[@"timestamp"]integerValue]];
            
            for (dictionaryJSON in mutableJSONArray) {
                Pollution *pollution = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution" inManagedObjectContext:self.context];
                
                pollution.value = [NSNumber numberWithDouble:[dictionaryJSON[@"value"] integerValue]];
                
                pollution.date = dictionaryJSON[@"date"];
                
                if (dictionaryJSON[@"caqidesc"] == nil) {
                    pollution.desc = dictionaryJSON[@"aqidesc"];
                }
                else {
                    pollution.desc = dictionaryJSON[@"caqidesc"];
                }
                pollution.value = [NSNumber numberWithDouble:[dictionaryJSON[@"value"] integerValue]];
                pollution.timestamp = [NSNumber numberWithInt:[dictionaryJSON[@"timestamp"]integerValue]];
                pollution.name = dictionaryJSON[@"parameterdesc"];
                
                
                pollution.unit = dictionaryJSON[@"unit"];
                [station addParametersObject:pollution];
            }
        }
        //        }
        
        if (![self.context save:&error]) {
            NSLog(@"Unable to save managed object context for station.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    
    else {
        
        NSPredicate *timestampPredicate = [NSPredicate predicateWithFormat:@"timestamp == %@",self.timeStamp];
        NSPredicate *longitudePredicate = [NSPredicate predicateWithFormat:@"lattitude == %@",self.lattitude];
        NSPredicate *lattitudePredicate = [NSPredicate predicateWithFormat:@"longitude == %@",self.longitude];
        
        NSPredicate *fetchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[lattitudePredicate, longitudePredicate, timestampPredicate]];
        NSFetchRequest *pollutionRequest = [[NSFetchRequest alloc] initWithEntityName:@"Pollution"];
        [fetchRequest setPredicate:fetchPredicate];
        
        
        self.pollutionsArray = [[self.context executeFetchRequest:pollutionRequest error:nil] mutableCopy];
        NSSet *timestampSet;
        for (Pollution *pol in self.pollutionsArray) {
            timestampSet =[NSSet setWithArray: [self.pollutionsArray valueForKey:@"timestamp"]];
        }
        NSLog(@"%@",self.timeStamp);
        NSLog(@"time  %@",timestampSet);
    //    NSMutableArray *timestampsArray = [NSMutableArray arrayWithObject: [timestampSet allObjects]];
        BOOL isTimeStampInCoreData = NO;
        for (NSNumber *timestampNumber in timestampSet) {
            if ([timestampNumber integerValue] == [self.timeStamp integerValue]) {
                isTimeStampInCoreData = YES;
            }
        }
        if( isTimeStampInCoreData ){
            
            return;
        }
        else{
            
            
            
            if([JSON isKindOfClass:[NSDictionary class]]){
                Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.context];
                Pollution *pollution = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution" inManagedObjectContext:self.context];
                
                NSMutableDictionary *mutableJSON = [JSON mutableCopy];
                
                for (NSString *key in mutableJSON.allKeys) {
                    pollution.date = sanitizedJSON[@"date"];
                    
                    if (sanitizedJSON[@"caqidesc"] == nil) {
                        pollution.desc = sanitizedJSON[@"aqidesc"];
                    }
                    else {
                        pollution.desc = sanitizedJSON[@"caqidesc"];
                    }
                    
                    pollution.name = sanitizedJSON[@"parameterdesc"];
                    pollution.value = [NSNumber numberWithDouble:[sanitizedJSON[@"value"] integerValue]];
                    pollution.timestamp = sanitizedJSON[@"timestamp"];
                    pollution.unit = sanitizedJSON[@"unit"];
                    
                    station.name = sanitizedJSON[@"parameterdesc"];
                    station.location = sanitizedJSON[@"location"];
                    station.locationdesc = sanitizedJSON[@"locationdesc"];
                    station.timestamp = [NSNumber numberWithInt:[sanitizedJSON[@"timestamp"]integerValue]];
                    station.longitude = [f numberFromString: sanitizedJSON[@"long"]];
                    station.lattitude = [f numberFromString: sanitizedJSON[@"lat"]];
                    
                    [station addParametersObject:pollution];
                }
                
            }
            else if([JSON isKindOfClass:[NSArray class]]){
                
                Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.context];
                
                NSMutableDictionary *dictionaryJSON ;
                NSMutableArray *mutableJSONArray = [JSON mutableCopy];
                NSDictionary *firsDictionary = [mutableJSONArray objectAtIndex:1];
                NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
                formater.numberStyle = NSNumberFormatterCurrencyStyle;
                
                station.name = firsDictionary[@"parameterdesc"];
                station.locationdesc = firsDictionary[@"locationdesc"];
                station.longitude =  [NSNumber numberWithDouble:[firsDictionary[@"long"] doubleValue]];
                station.lattitude = [NSNumber numberWithDouble:[firsDictionary[@"lat"] doubleValue]];
                station.location = firsDictionary[@"location"];
                station.timestamp = [NSNumber numberWithInt:[firsDictionary[@"timestamp"]integerValue]];
                
                for (dictionaryJSON in mutableJSONArray) {
                    Pollution *pollution = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution" inManagedObjectContext:self.context];
                    
                    pollution.value = [NSNumber numberWithDouble:[dictionaryJSON[@"value"] integerValue]];
                    
                    pollution.date = dictionaryJSON[@"date"];
                    
                    if (dictionaryJSON[@"caqidesc"] == nil) {
                        pollution.desc = dictionaryJSON[@"aqidesc"];
                    }
                    else {
                        pollution.desc = dictionaryJSON[@"caqidesc"];
                    }
                    pollution.value = [NSNumber numberWithDouble:[dictionaryJSON[@"value"] integerValue]];
                    pollution.timestamp = [NSNumber numberWithInt:[dictionaryJSON[@"timestamp"]integerValue]];
                    pollution.name = dictionaryJSON[@"parameterdesc"];
                    
                    
                    pollution.unit = dictionaryJSON[@"unit"];
                    [station addParametersObject:pollution];
                }
            }
            
            if (![self.context save:&error]) {
                NSLog(@"Unable to save managed object context for station.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            
        }
        
    }
    
    
}
@end
