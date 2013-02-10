//
//  DeliveryModeViewController.m
//  Manbag
//
//  Created by Roy Marmelstein on 10/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "DeliveryModeViewController.h"
#import "AppDelegate.h"
#import "CentralViewController.h"
#import "bagPoints.h"

@interface DeliveryModeViewController ()

@end

@implementation DeliveryModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(goLogout)];
    [logout setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = logout;
    UIImageView* titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navIcon.png"]];
    [self.navigationItem setTitleView:titleView];
    hasZoomed = NO;
    _deliveryMan = [[NSMutableDictionary alloc] init];
    _retainedTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                      target:self
                                                    selector:@selector(fetchDeliveryManLocation)
                                                    userInfo:nil
                                                     repeats:YES];
    NSArray* bags = [_delivery objectForKey:@"bags"];
    int bagCount = 0;
    int i;
    for (i=0; i< [bags count]; i++) {
        NSMutableDictionary* currentBag = [bags objectAtIndex:i];
        PFObject *bag = (PFObject *)currentBag;
        [bag fetch];
        NSLog(@"%@", bag);
        bagCount = bagCount + [[bag objectForKey:@"number"] intValue];
    }
    _bagCount.text = [NSString stringWithFormat:@"%d", bagCount];
    [self fetchDeliveryManLocation];
}

- (void)viewDidAppear:(BOOL)animated{
    [self fetchDeliveryManLocation];
}

- (void)fetchDeliveryManLocation{
    [_delivery refresh];
    PFObject* deliveryMan = [_delivery objectForKey:@"deliveryMan"];
    [deliveryMan fetch];
    PFGeoPoint* deliveryLocation = [_delivery objectForKey:@"deliveryLocation"];
    id userLocation = [_map userLocation];
    [_map removeAnnotations:[_map annotations]];
    if ( userLocation != nil ) {
        [_map addAnnotation:userLocation];
    }
        bagPoints* annotation = [[bagPoints alloc] init];
        annotation.longitude = deliveryLocation.longitude;
        annotation.latitude = deliveryLocation.latitude;
        [_map addAnnotation:annotation];
    [self zoomToFitMapAnnotations:_map];

}

- (void)goLogout{
    [self dismissModalViewControllerAnimated:YES];
    [PFUser logOut];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centralViewController showTop];

}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    MKAnnotationView *annotationView = (MKAnnotationView *)[_map dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    if(annotation != _map.userLocation) {
        annotationView.image = [UIImage imageNamed:@"deliveryMan.png"];
        annotationView.annotation = annotation;
        return annotationView;
    }
    else {
        return nil;
    }
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMap:nil];
    [self setBagCount:nil];
    [super viewDidUnload];
}
- (IBAction)gotBags:(id)sender {
}
@end
