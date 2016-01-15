//
//  CityMapViewController.m
//  Smogapp
//
//  Created by Myrenkar on 08.01.2016.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import "CityMapViewController.h"
#import "JSONParserToCoreData.h"
#import "JSONDownloader.h"

@interface CityMapViewController ()
@property (nonatomic) JSONParserToCoreData *parser;
@end

@implementation CityMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cityLabel.text = self.cityName;
    self.cityMapView.delegate = self;
   
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkJSONParsing:(id)sender {
    JSONDownloader *downloader = [[JSONDownloader alloc]init];
    [downloader getParameterFromCityAndLocation:@"krakow" location:@"bujaka" parameterType:@"caqi" callback:^(BOOL parseSuccess, id response, NSError *connectionError) {
        
        self.parser = [[JSONParserToCoreData alloc]init];
        [self.parser parseCitiesFromJSON:response];
    }];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.cityMapView setRegion:[self.cityMapView regionThatFits:region] animated:YES];
    
}

@end
