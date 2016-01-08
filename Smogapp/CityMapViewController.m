//
//  CityMapViewController.m
//  Smogapp
//
//  Created by Myrenkar on 08.01.2016.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "CityMapViewController.h"

@interface CityMapViewController ()

@end

@implementation CityMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cityLabel.text = self.cityName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
