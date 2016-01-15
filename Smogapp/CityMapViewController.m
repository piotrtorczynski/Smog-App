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
#import "CiteisViewController.h"

@interface CityMapViewController ()
@property (nonatomic) JSONParserToCoreData *parser;
@property NSArray *cityLocations;
@property NSString *cityNameForRequest;
@end

@implementation CityMapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cityLabel.text = self.cityName;
    self.cityMapView.delegate = self;
    NSString *cellName = self.cityName;
    
    if ([cellName  isEqual: @"Kraków"]) {
        self.cityNameForRequest = @"krakow";
    }
    else if([cellName  isEqual: @"Tarnów"]) {
        self.cityNameForRequest = @"tarnow";
    }
    else if([cellName  isEqual: @"Nowy Sącz"]) {
        self.cityNameForRequest = @"nowysacz";
    }
    else if([cellName  isEqual: @"Olkusz"]) {
        self.cityNameForRequest = @"olkusz";
    }
    else if([cellName  isEqual: @"Skawina"]) {
        self.cityNameForRequest = @"skawina";
    }
    else if([cellName  isEqual: @"Sucha Beskidzka"]) {
        self.cityNameForRequest = @"suchabeskidzka";
    }
    else if([cellName  isEqual: @"Szymbark"]) {
        self.cityNameForRequest = @"szymbark";
    }
    else if([cellName  isEqual: @"Szarów"]) {
        self.cityNameForRequest = @"szarow";
    }
    else if([cellName  isEqual: @"Trzebinia"]) {
        self.cityNameForRequest = @"trzebinia";
    }
    else if([cellName  isEqual: @"Zakopane"]) {
        self.cityNameForRequest = @"zakopane";
    }
    
    NSLog(@"%@", self.cityNameForRequest);
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Use one or the other, not both. Depending on what you put in info.plist
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    JSONDownloader *downloader = [[JSONDownloader alloc]init];
    [downloader getAllInformationFromCity:self.cityNameForRequest callback:^(BOOL parseSuccess, id response, NSError *connectionError) {
        self.parser = [[JSONParserToCoreData alloc]init];
        //        [self.parser parseStationFromJSON:response];
        
        self.cityLocations =  [[self.parser parseStationFromJSON:response ] allObjects];
        
        for(NSInteger i = 0; i<self.cityLocations.count; i++){
            [downloader getAllParametersFromCityAndLocation:self.cityNameForRequest location:[self.cityLocations objectAtIndex:i] callback:^(BOOL parseSuccess, id response, NSError *connectionError) {
                NSLog(@"%@",[self.cityLocations objectAtIndex:i]);
                [self.parser parseCitiesFromJSON:response];
            }];
        }
    }
     
     ];
    
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
