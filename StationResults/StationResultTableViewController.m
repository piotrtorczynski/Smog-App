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
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    NSPredicate *longitudePredicate = [NSPredicate predicateWithFormat:@"lattitude == %@",self.lattitude];
    NSPredicate *lattitudePredicate = [NSPredicate predicateWithFormat:@"longitude == %@",self.longitude];
    NSPredicate *fetchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[lattitudePredicate, longitudePredicate]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    [fetchRequest setPredicate:fetchPredicate];
    
    self.stationPollution = [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.resultTableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
   return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.stationPollution.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultTableCell" forIndexPath:indexPath];
    
    
    Station *station = [self.stationPollution objectAtIndex:indexPath.row];
    self.resultTimeStamp =station.timestamp;
    
        [cell.textLabel setText:[self parseTimeStampToDate:station.timestamp]];
        [cell.detailTextLabel setText:@""];

     return cell;
  
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showResultForSpecificTime"])
    {

        PollutionFromStationViewController *destinationViewController = segue.destinationViewController;

        destinationViewController.tableViewTimeStamp  = self.resultTimeStamp;
        destinationViewController.lattitude = self.lattitude;
        destinationViewController.longitude = self.longitude;
    } else {
        NSLog(@"PFS:something else");
    }
}

-(NSString *)parseTimeStampToDate:(NSNumber *)timestamp{

    double unixTimeStamp = [timestamp doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *_date=[_formatter stringFromDate:date];

    return _date;
}


@end
