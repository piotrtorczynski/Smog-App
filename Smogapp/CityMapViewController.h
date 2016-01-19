//
//  CityMapViewController.h
//  Smogapp
//
//  Created by Myrenkar on 08.01.2016.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface CityMapViewController : UIViewController  <MKMapViewDelegate, CLLocationManagerDelegate>

//labels
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) NSString *cityName;

//buttons
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

//actions
- (IBAction)backButtonClick:(id)sender;
- (IBAction)checkJSONParsing:(id)sender;

//mapView
@property (weak, nonatomic) IBOutlet MKMapView *cityMapView;
@property(nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic) NSManagedObjectContext *context;
@end
