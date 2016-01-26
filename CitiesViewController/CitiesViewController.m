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

@interface ViewController ()

@end

@implementation ViewController{
    NSArray *cities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cities = [NSArray arrayWithObjects:@"Kraków", @"Nowy Sącz",  @"Olkusz", @"Skawina", @"Sucha Beskidzka", @"Szarów", @"Szymbark", @"Tarnów", @"Trzebinia", @"Zakopane", nil];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [cities objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCityMap"]) {
        NSIndexPath *indexPath = [self.citiesTableView indexPathForSelectedRow];
        CityMapViewController *destViewController = segue.destinationViewController;
        destViewController.cityName = [cities objectAtIndex:indexPath.row];
    }
}

@end


