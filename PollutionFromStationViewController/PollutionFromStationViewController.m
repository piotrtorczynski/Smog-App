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
        cell.backgroundColor = [self colorWithHexString:@"79bc6a"];
        
    }
    else if ([cell.parameterDescLabel.text isEqual:@"niski"]){
        cell.backgroundColor = [self colorWithHexString:@"bbcf4c"];
    }
    else if ([pollution.desc isEqual:@"średni"]){
        cell.backgroundColor = [self colorWithHexString:@"eec20b"];
    }
    else if ([cell.parameterDescLabel.text isEqual:@"wysoki"]){
        cell.backgroundColor = [self colorWithHexString:@"#29305"];
        
    }
    else if ([cell.parameterDescLabel.text isEqual:@"bardzo wysoki"]){
        cell.backgroundColor = [self colorWithHexString:@"960018"];
    }
    else if ([cell.parameterDescLabel.text isEqual:@"dobry"]){
        cell.backgroundColor = [self colorWithHexString:@"960018"];
    }
    else if ([cell.parameterDescLabel.text isEqual:@"umiarkowany"]){
        cell.backgroundColor = [self colorWithHexString:@"ffff00"];
    }
    else if ([cell.parameterDescLabel.text isEqual:@"niezdrowy dla grup wrażliwych"]){
        cell.backgroundColor = [self colorWithHexString:@"ff7e00"];
    }
    else if ([cell.parameterDescLabel.text isEqual:@"niezdrowy"]){
        cell.backgroundColor = [self colorWithHexString:@"ff0000"];
    }
    else if ([cell.parameterDescLabel.text isEqual:@"bardzo niezdrowy"]){
        cell.backgroundColor = [self colorWithHexString:@"99004c"];
    }
    else if ([cell.parameterDescLabel.text isEqual:@"niebezpieczny"]){
        cell.backgroundColor = [self colorWithHexString:@"7e0023"];
    }
    
    
    [cell.parameterDescLabel setText:[NSString stringWithFormat:@"Poziom: %@",pollution.desc]];
    
    return cell;
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
