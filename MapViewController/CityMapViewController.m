//
//  CityMapViewController.m
//  Smogapp
//
//  Created by Myrenkar on 08.01.2016.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#define MINIMUM_ZOOM_ARC 0.010 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

#import "AppDelegate.h"
#import "CiteisViewController.h"
#import "CityMapViewController.h"
#import "JSONDownloader.h"
#import "JSONParserToCoreData.h"
#import "Station+CoreDataProperties.h"
#import "StationResultTableViewController.h"

@interface CityMapViewController ()
@property (nonatomic) JSONParserToCoreData* parser;
@property NSArray* cityLocations;
@property NSString* cityNameForRequest;
@property NSArray* pointsLocations;
@property NSString* locationName;
@end

@implementation CityMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    self.context = appDelegate.managedObjectContext;

    self.cityLabel.text = self.cityName;
    self.cityMapView.delegate = self;

    NSString* cellName = self.cityName;

    if ([cellName isEqual:@"Kraków"]) {
        self.cityNameForRequest = @"krakow";
    }
    else if ([cellName isEqual:@"Tarnów"]) {
        self.cityNameForRequest = @"tarnow";
    }
    else if ([cellName isEqual:@"Nowy Sącz"]) {
        self.cityNameForRequest = @"nowysacz";
    }
    else if ([cellName isEqual:@"Olkusz"]) {
        self.cityNameForRequest = @"olkusz";
    }
    else if ([cellName isEqual:@"Skawina"]) {
        self.cityNameForRequest = @"skawina";
    }
    else if ([cellName isEqual:@"Sucha Beskidzka"]) {
        self.cityNameForRequest = @"suchabeskidzka";
    }
    else if ([cellName isEqual:@"Szymbark"]) {
        self.cityNameForRequest = @"szymbark";
    }
    else if ([cellName isEqual:@"Szarów"]) {
        self.cityNameForRequest = @"szarow";
    }
    else if ([cellName isEqual:@"Trzebinia"]) {
        self.cityNameForRequest = @"trzebinia";
    }
    else if ([cellName isEqual:@"Zakopane"]) {
        self.cityNameForRequest = @"zakopane";
    }

    [self.changeMapTypeButton addTarget:self
                                 action:@selector(changeMapType:)
                       forControlEvents:UIControlEventTouchDown];
    [self.changeMapTypeButton setTitle:@"Zmień rodzaj mapy"
                              forState:UIControlStateNormal];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];

    JSONDownloader* downloader = [[JSONDownloader alloc] init];
    [downloader
            getAllInformationFromCity:self.cityNameForRequest
                             callback:^(BOOL parseSuccess, id response,
                                     NSError* connectionError) {
                                 self.parser = [[JSONParserToCoreData alloc] init];
                                 self.cityLocations =
                                         [self.parser parseLocationFromJSON:response];

                                 for (NSInteger i = 0; i < self.cityLocations.count;
                                      i++) {
                                     [downloader
                                             getAllParametersFromCityAndLocation:
                                                     self.cityNameForRequest
                                                                        location:
                                                                                [self.cityLocations objectAtIndex:i]
                                                                        callback:^(BOOL parseSuccess,
                                                                                id response,
                                                                                NSError* connectionError) {
                                                                            NSLog(@"%@", [self.cityLocations objectAtIndex:i]);
                                                                            [self.parser parseStationFromLocationJSON:response];
                                                                            [self setAnnotationsStationsWithLocation:[self.cityLocations objectAtIndex:i]];
                                                                        }];
                                 }

                             }];
}

- (void)setAnnotationsStationsWithLocation:(NSArray*)location
{
    NSNumber* lattitude = [[NSNumber alloc] init];
    NSNumber* longitude = [[NSNumber alloc] init];

    NSString* description;

    NSFetchRequest* fetchRequest =
            [[NSFetchRequest alloc] initWithEntityName:@"Station"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"location == %@",
                                                                location]];
    [fetchRequest setFetchLimit:1];
    self.pointsLocations =
            [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy];

    if (self.pointsLocations.count > 0) {
        for (Station* station in self.pointsLocations) {
            lattitude = station.lattitude;
            longitude = station.longitude;
            description = station.locationdesc;
        }
    }

    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.longitude = longitude.doubleValue;
    pinCoordinate.latitude = lattitude.doubleValue;

    MKPointAnnotation* point = [[MKPointAnnotation alloc] init];
    point.coordinate = pinCoordinate;
    point.title = [NSString stringWithFormat:@"%@", description];

    [self.cityMapView addAnnotation:point];
    [self zoomMapViewToFitAnnotations:self.cityMapView animated:YES];
}

- (MKAnnotationView*)mapView:(MKMapView*)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString* identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[self.cityMapView
                dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView =
                    [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                    reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView =
                    [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        else {
            annotationView.annotation = annotation;
        }

        return annotationView;
    }

    return nil;
}

- (void)mapView:(MKMapView*)mapView
 annotationView:(MKAnnotationView*)view
        calloutAccessoryControlTapped:(UIControl*)control
{
    if (![view.annotation isKindOfClass:[MKPointAnnotation class]])
        return;
    [self performSegueWithIdentifier:@"pushDBResults" sender:view.annotation];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushDBResults"]) {
        MKPointAnnotation* point = (MKPointAnnotation*)sender;

        StationResultTableViewController* destinationViewController = segue.destinationViewController;
        CLLocation* pinCoordinate =
                [[CLLocation alloc] initWithLatitude:(point.coordinate.latitude)
                                           longitude:point.coordinate.longitude];
        destinationViewController.stationLocation = pinCoordinate;
    }
    else {
        NSLog(@"PFS:something else");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeMapTypeButtonAction:(id)sender
{
    [self.changeMapTypeButton addTarget:self
                                 action:@selector(changeMapType:)
                       forControlEvents:UIControlEventTouchDown];
    [self.changeMapTypeButton setTitle:@"Zmień rodzaj mapy"
                              forState:UIControlStateNormal];
}

- (void)changeMapType:(id)sender
{
    if (self.cityMapView.mapType == MKMapTypeStandard)
        self.cityMapView.mapType = MKMapTypeSatellite;

    else if (self.cityMapView.mapType == MKMapTypeSatellite) {
        self.cityMapView.mapType = MKMapTypeHybrid;
    }
    else {
        self.cityMapView.mapType = MKMapTypeStandard;
    }
}

- (void)zoomMapViewToFitAnnotations:(MKMapView*)mapView animated:(BOOL)animated
{
    NSMutableArray* annotations = self.cityMapView.annotations;
    NSMutableArray* pinsAnnotations = [[NSMutableArray alloc] init];
    for (id location in annotations) {

        if ([location isKindOfClass:[MKPointAnnotation class]]) {
            [pinsAnnotations addObject:location];
        }
    }
    int count = pinsAnnotations.count;
    if (count == 0) {
        return;
    } //bail if no annotations

    MKMapPoint points[count]; //C array of MKMapPoint struct
    for (int i = 0; i < count; i++) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id<MKAnnotation>)[pinsAnnotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);

    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if (region.span.latitudeDelta > MAX_DEGREES_ARC) {
        region.span.latitudeDelta = MAX_DEGREES_ARC;
    }
    if (region.span.longitudeDelta > MAX_DEGREES_ARC) {
        region.span.longitudeDelta = MAX_DEGREES_ARC;
    }

    //and don't zoom in stupid-close on small samples
    if (region.span.latitudeDelta < MINIMUM_ZOOM_ARC) {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
    }
    if (region.span.longitudeDelta < MINIMUM_ZOOM_ARC) {
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if (count == 1 ) {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

@end
