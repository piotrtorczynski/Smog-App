//
//  JSONParserToCoreData.h
//  Smogapp
//
//  Created by Piotr Torczyski on 14/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface JSONParserToCoreData : NSObject

@property (nonatomic) NSManagedObjectContext *context;

-(void)parseCitiesFromJSON:(id)JSON;
-(void)parsePollutionFromJSON:(id)JSON;
-(void)parseStationFromJSON:(id)JSON;

@end
