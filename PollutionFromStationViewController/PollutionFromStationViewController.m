//
//  PollutionFromStationViewController.m
//  Smogapp
//
//  Created by Piotr Torczyski on 21/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "PollutionFromStationViewController.h"
#import "AppDelegate.h"
#import "Pollution+CoreDataProperties.h"
#import "Station+CoreDataProperties.h"

@interface PollutionFromStationViewController ()
@property NSArray *stationsArray;
@property NSArray *pollutionsArray;
@end

@implementation PollutionFromStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.tableViewTimeStamp);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.context = appDelegate.managedObjectContext;
    
    NSPredicate *timeStampPredicate = [NSPredicate predicateWithFormat:@"timestamp == %@",self.tableViewTimeStamp];
    self.pollutionsArray = [self.selectedStation.parameters.allObjects filteredArrayUsingPredicate:timeStampPredicate];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pollutionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pollutionCell" forIndexPath:indexPath];
    
    
    Pollution *pollution = [ self.pollutionsArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:pollution.name];
    [cell.detailTextLabel setText:pollution.desc];
    
    return cell;
}

@end
