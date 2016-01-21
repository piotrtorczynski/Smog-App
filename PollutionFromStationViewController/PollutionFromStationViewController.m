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
@property NSArray *pollutionForStationArray;

@end

@implementation PollutionFromStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.tableViewTimeStamp);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.context = appDelegate.managedObjectContext;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    NSPredicate *longitudePredicate = [NSPredicate predicateWithFormat:@"lattitude == %@",self.lattitude];
    NSPredicate *lattitudePredicate = [NSPredicate predicateWithFormat:@"longitude == %@",self.longitude];
//    NSPredicate *timeStampPredicate = [NSPredicate predicateWithFormat:@"timestamp == %@",self.tableViewTimeStamp];
    
    NSPredicate *fetchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[lattitudePredicate, longitudePredicate]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    [fetchRequest setPredicate:fetchPredicate];
    
    self.pollutionForStationArray = [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.stationTableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pollutionForStationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pollutionCell" forIndexPath:indexPath];
    
   Station *station = [self.pollutionForStationArray objectAtIndex:indexPath.row];

    for (Pollution *pollution in station.parameters){
        if ([pollution.timestamp isEqual: self.tableViewTimeStamp]) {
            [cell.textLabel setText:pollution.name];
            [cell.detailTextLabel setText:pollution.desc];
        }
        else{
            NSLog(@"Probleeeeem");
        }
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
