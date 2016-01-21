//
//  PollutionFromStationViewController.h
//  Smogapp
//
//  Created by Piotr Torczyski on 21/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PollutionFromStationViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *stationTableView;
@property NSNumber *tableViewTimeStamp;
@property (nonatomic) NSManagedObjectContext *context;
@property NSNumber *longitude;
@property NSNumber *lattitude;

@end
