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
#import "PollutionCellTableViewCell.h"

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
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    NSPredicate *timeStampPredicate = [NSPredicate predicateWithFormat:@"timestamp == %@",self.tableViewTimeStamp];
    self.pollutionsArray = [self.selectedStation.parameters.allObjects filteredArrayUsingPredicate:timeStampPredicate];
    self.pollutionsArray = [self.pollutionsArray sortedArrayUsingDescriptors:sortDescriptors];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
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
    PollutionCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pollutionCell" forIndexPath:indexPath];
    
    Pollution *pollution = [ self.pollutionsArray objectAtIndex:indexPath.row];

    [cell.paramatereNameLabel setText:pollution.name];
    [cell.parameterValueLabel setText:pollution.value.stringValue];
    [cell.parameterUnitLabel setText:pollution.unit];
    [cell.parameterDescLabel setText:pollution.desc];
        if (cell.parameterDescLabel.text == nil) {
            cell.backgroundColor = [UIColor grayColor];
        }
        else if ([cell.parameterDescLabel.text isEqual:@"bardzo niski"]){
         cell.backgroundColor = [UIColor greenColor];
            
        }
        else if ([cell.parameterDescLabel.text isEqual:@"niski"]){
            cell.backgroundColor = [UIColor greenColor];
        }
        else if ([pollution.desc isEqual:@"średni"]){
            cell.backgroundColor = [UIColor yellowColor];
        }
        else if ([cell.parameterDescLabel.text isEqual:@"wysoki"]){
            cell.backgroundColor = [UIColor redColor];
        }
        else if ([cell.parameterDescLabel.text isEqual:@"bardzo wysoki"]){
            cell.backgroundColor = [UIColor greenColor];
        }
    
    [cell.parameterDescLabel setText:[NSString stringWithFormat:@"Poziom: %@",pollution.desc]];

    return cell;
}

@end
