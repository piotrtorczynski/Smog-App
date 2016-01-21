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

@interface StationResultTableViewController ()
@property NSArray *stationPollution;
@end

@implementation StationResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.context = appDelegate.managedObjectContext;
    self.lattitude =[ NSNumber numberWithDouble:self.stationLocation.coordinate.latitude];
    self.longitude =[NSNumber numberWithDouble:self.stationLocation.coordinate.longitude];
    NSLog(@"latlongi %@  %@", self.lattitude, self.longitude);
    
    
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.stationPollution.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultTableCell" forIndexPath:indexPath];
    
    NSManagedObjectContext *pollutionFetched = [self.stationPollution objectAtIndex:indexPath.row];
    
    Station *station = [self.stationPollution objectAtIndex:indexPath.row];
    
    for (Pollution *pol in station.parameters) {
        [cell.textLabel setText:[pol valueForKey:@"name"]];
        [cell.detailTextLabel setText:[pol valueForKey:@"desc"]];
    }
    
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
