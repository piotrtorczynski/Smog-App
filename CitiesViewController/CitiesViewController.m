//
//  ViewController.m
//  Smogapp
//
//  Created by Piotr Torczyski on 08/01/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "CiteisViewController.h"
#import "CityMapViewController.h"
#import "JSONParserToCoreData.h"
#import "JSONDownloader.h"

@interface ViewController ()
@property NSArray *cities;
@property (nonatomic) JSONParserToCoreData *parser;
@end

@implementation ViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        JSONDownloader *downloader = [[JSONDownloader alloc]init];
        [downloader getAllCitiesWithCallback:^(BOOL parseSuccess, id response, NSError *connectionError) {
            self.parser = [[JSONParserToCoreData alloc]init];
            self.cities = [self.parser parseCitiesFromJSON:response];
            [self.citiesTableView reloadData];
              NSLog(@"Cities :%@",self.cities);
        }];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
  
    

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.cities objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCityMap"]) {
        NSIndexPath *indexPath = [self.citiesTableView indexPathForSelectedRow];
        CityMapViewController *destViewController = segue.destinationViewController;
        destViewController.cityName = [self.cities objectAtIndex:indexPath.row];
    }
}

@end


