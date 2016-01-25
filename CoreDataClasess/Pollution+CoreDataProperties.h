//
//  Pollution+CoreDataProperties.h
//  Smogapp
//
//  Created by Piotr Torczyski on 25/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Pollution.h"

NS_ASSUME_NONNULL_BEGIN

@interface Pollution (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *timestamp;
@property (nullable, nonatomic, retain) NSString *unit;
@property (nullable, nonatomic, retain) NSNumber *value;
@property (nullable, nonatomic, retain) Station *station;

@end

NS_ASSUME_NONNULL_END
