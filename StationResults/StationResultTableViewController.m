//
//  TableViewController.m
//  Smogapp
//
//  Created by Myrenkar on 20.01.2016.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "StationResultTableViewController.h"
#import "AppDelegate.h"
#import "Station+CoreDataProperties.h"
#import "Pollution+CoreDataProperties.h"
#import "PollutionFromStationViewController.h"


@interface StationResultTableViewController ()
@property NSArray *stationPollution;
@property NSNumber *resultTimeStamp;
@end

@implementation StationResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.context = appDelegate.managedObjectContext;
    self.lattitude =[ NSNumber numberWithDouble:self.stationLocation.coordinate.latitude];
    self.longitude =[NSNumber numberWithDouble:self.stationLocation.coordinate.longitude];
    
    NSPredicate *longitudePredicate = [NSPredicate predicateWithFormat:@"lattitude == %@",self.lattitude];
    NSPredicate *lattitudePredicate = [NSPredicate predicateWithFormat:@"longitude == %@",self.longitude];
    NSPredicate *fetchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[lattitudePredicate, longitudePredicate]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    [fetchRequest setPredicate:fetchPredicate];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    self.stationPollution = [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.resultTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.stationPollution.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Station *station = [self.stationPollution objectAtIndex:indexPath.row];
    NSNumber *time = [NSNumber new];
    
    time = station.timestamp;
   
    PollutionFromStationViewController *pollutionFromStationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PollutionFromStationViewController"];
    pollutionFromStationViewController.tableViewTimeStamp = time;
    pollutionFromStationViewController.lattitude = self.lattitude;
    pollutionFromStationViewController.longitude = self.longitude;
    pollutionFromStationViewController.selectedStation = station;
    
    [self.navigationController pushViewController:pollutionFromStationViewController animated:YES];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultTableCell" forIndexPath:indexPath];
    
    Station *station = [self.stationPollution objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[self parseTimeStampToDate:station.timestamp]];
    [cell.detailTextLabel setText:@""];
    
    return cell;
    
}

-(NSString *)parseTimeStampToDate:(NSNumber *)timestamp{
    
    double unixTimeStamp = [timestamp doubleValue];
    NSTimeInterval interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *parsedDate=[formatter stringFromDate:date];
    
    return parsedDate;
}


@end
