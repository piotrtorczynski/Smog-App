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
    self.cityMapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.cityMapView setRegion:[self.cityMapView regionThatFits:region] animated:YES];
}

@end
