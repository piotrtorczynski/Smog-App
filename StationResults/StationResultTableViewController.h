//
//  TableViewController.h
//  Smogapp
//
//  Created by Myrenkar on 20.01.2016.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>




@interface StationResultTableViewController : UITableViewController
@property NSNumber *longitude;
@property NSNumber *lattitude;
@property CLLocation *stationLocation;

@property (nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;

@end
