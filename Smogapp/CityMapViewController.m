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
#import "AppDelegate.h"
#import "Station+CoreDataProperties.h"

@interface CityMapViewController ()
@property (nonatomic) JSONParserToCoreData *parser;
@property NSArray *cityLocations;
@property NSString *cityNameForRequest;
@property NSArray *pointsLocations;

@end

@implementation CityMapViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.context = appDelegate.managedObjectContext;


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
    
    [self.changeMapTypeButton addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventTouchDown];
    [self.changeMapTypeButton setTitle:@"Zmień rodzaj mapy" forState:UIControlStateNormal];

    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    JSONDownloader *downloader = [[JSONDownloader alloc]init];
    [downloader getAllInformationFromCity:self.cityNameForRequest callback:^(BOOL parseSuccess, id response, NSError *connectionError) {
        self.parser = [[JSONParserToCoreData alloc]init];
        self.cityLocations = [self.parser parseLocationFromJSON:response];
        
        for(NSInteger i = 0; i<self.cityLocations.count; i++){
            [downloader getAllParametersFromCityAndLocation:self.cityNameForRequest location:[self.cityLocations objectAtIndex:i] callback:^(BOOL parseSuccess, id response, NSError *connectionError) {
                NSLog(@"%@",[self.cityLocations objectAtIndex:i]);
                [self.parser parseStationFromLocationJSON:response];
                [self setAnnotationsStations];
                }];
        }
       
    }];

}

-(void)setAnnotationsStations{
    
    NSNumber *lattitude = [[NSNumber alloc]init];
    NSNumber *longitude = [[NSNumber alloc]init];
    
    NSString *description;
    NSString *parameterdescription;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"city == %@", self.cityNameForRequest]];
    
    self.pointsLocations = [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];

    
    if (self.pointsLocations.count >0) {
        for(Station *station in self.pointsLocations){
            lattitude = station.lattitude;
            longitude = station.longitude;
            description = station.locationdesc;
            parameterdescription = station.name;
           NSLog(@"%f %f",station.lattitude.doubleValue, station.longitude.doubleValue );
        }
        
    }
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.longitude = longitude.doubleValue;
    pinCoordinate.latitude = lattitude.doubleValue;
    point.coordinate = pinCoordinate;
    point.title =  description;
    point.subtitle = parameterdescription;
    
    
    [self.cityMapView addAnnotation:point];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 18000, 18000);
        [self.cityMapView setRegion:[self.cityMapView regionThatFits:region] animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkJSONParsing:(id)sender {
    
    [self.changeMapTypeButton addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventTouchDown];
    [self.changeMapTypeButton setTitle:@"Zmień rodzaj mapy" forState:UIControlStateNormal];
    
}

- (void) changeMapType: (id)sender
{
    if (self.cityMapView.mapType == MKMapTypeStandard)
        self.cityMapView.mapType = MKMapTypeSatellite;
    else
        self.cityMapView.mapType = MKMapTypeStandard;
}

@end
