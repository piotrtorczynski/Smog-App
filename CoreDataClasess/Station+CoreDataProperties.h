//
//  Station+CoreDataProperties.h
//  Smogapp
//
//  Created by Piotr Torczyski on 26/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Station.h"

NS_ASSUME_NONNULL_BEGIN

@interface Station (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *lattitude;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *locationdesc;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *timestamp;
@property (nullable, nonatomic, retain) NSSet<Pollution *> *parameters;

@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addParametersObject:(Pollution *)value;
- (void)removeParametersObject:(Pollution *)value;
- (void)addParameters:(NSSet<Pollution *> *)values;
- (void)removeParameters:(NSSet<Pollution *> *)values;

@end

NS_ASSUME_NONNULL_END
