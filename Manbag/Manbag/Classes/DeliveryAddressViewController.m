//
//  DeliveryAddressViewController.m
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "DeliveryAddressViewController.h"
#import "RMAnnotationDelegate.h"
#import "PaymentViewController.h"

@interface DeliveryAddressViewController ()

@end

@implementation DeliveryAddressViewController

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
    self.title = @"Select Address";
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goCancel)];
    self.navigationItem.leftBarButtonItem = logout;
    didLocationZoom = NO;
    _latitude = 600;
    _longitude = 600;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)goCancel{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        _latitude = droppedAt.latitude;
        _longitude = droppedAt.longitude;
    }
}

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return nil;
    }
    else{
        static NSString * const kPinIdentifier = @"Pin";
        MKPinAnnotationView * pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:kPinIdentifier];
        if (!pin)
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinIdentifier];
        
        pin.draggable = YES;
        pin.pinColor = MKPinAnnotationColorPurple;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        [pin isDraggable];
        return pin;
    }
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if (didLocationZoom == NO) {
            if(annotationView.annotation == mv.userLocation) {
                MKCoordinateRegion region;
                MKCoordinateSpan span;
                
                span.latitudeDelta=0.1;
                span.longitudeDelta=0.1;
                
                CLLocationCoordinate2D location=mv.userLocation.coordinate;
                region = MKCoordinateRegionMakeWithDistance(location, 1300, 1300);
                [mv setRegion:region animated:TRUE];
                [mv regionThatFits:region];
                didLocationZoom = YES;
            }
            
        }
    }
}

- (IBAction)goSearch:(id)sender {
    //    Remove all annotations that are not the user's location.
    for (int i =0; i < [_RMMapview.annotations count]; i++) {
        if ([[_RMMapview.annotations objectAtIndex:i] isKindOfClass:[MKUserLocation class]]) {
        }
        else {
            [_RMMapview removeAnnotation:[_RMMapview.annotations objectAtIndex:i]];
        }
    }
    
    
    NSString *feedSearchTerm = _RMSearchBar.text;
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
                           [feedSearchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double receivedLatitude = 0.0;
    double receivedLongitude = 0.0;
    int resultChecker = 0;
    if([listItems count] == 0) {
        resultChecker++;
    }
    if (![[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        resultChecker++;
    }
    
    if (resultChecker == 0) {
        receivedLatitude = [[listItems objectAtIndex:2] doubleValue];
        receivedLongitude = [[listItems objectAtIndex:3] doubleValue];
        _latitude = receivedLatitude;
        _longitude = receivedLongitude;
        CLLocationCoordinate2D coordTemp = {_latitude, _longitude};
        RMAnnotationDelegate* RMAnnotation = [[RMAnnotationDelegate alloc] initWithCoordinate:coordTemp];
        RMAnnotation.name = @"Selected Location";
        [_RMMapview addAnnotation:RMAnnotation];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordTemp, 1000, 1000);
        MKCoordinateRegion adjustedRegion = [_RMMapview regionThatFits:viewRegion];
        [_RMMapview setRegion:adjustedRegion animated:YES];
        
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't Find Location. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [_RMSearchBar resignFirstResponder];
    _RMSearchBar.text = @"";
}

- (IBAction)goDropPin:(id)sender {
    
    [_RMSearchBar resignFirstResponder];
    for (int i =0; i < [_RMMapview.annotations count]; i++) {
        if ([[_RMMapview.annotations objectAtIndex:i] isKindOfClass:[MKUserLocation class]]) {
        }
        else {
            [_RMMapview removeAnnotation:[_RMMapview.annotations objectAtIndex:i]];
        }
    }
    
    
    _latitude = self.RMMapview.centerCoordinate.latitude;
    _longitude = self.RMMapview.centerCoordinate.longitude;
    CLLocationCoordinate2D coordTemp = {_latitude, _longitude};
    RMAnnotationDelegate* RMAnnotation = [[RMAnnotationDelegate alloc] initWithCoordinate:coordTemp];
    RMAnnotation.name = @"Selected Location";
    [_RMMapview addAnnotation:RMAnnotation];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordTemp, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [_RMMapview regionThatFits:viewRegion];
    [_RMMapview setRegion:adjustedRegion animated:YES];    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self goSearch:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goDone:(id)sender {
        int checker = 0;
        if (_latitude == 600) {
            checker ++;
        }
        if (_longitude == 600) {
            checker ++;
        }
        if (checker == 0) {
            PaymentViewController* paymentViewController = [[PaymentViewController alloc] init];
            [self.navigationController pushViewController:paymentViewController animated:YES];
        }
}

- (void)viewDidUnload {
    [self setDoneBtn:nil];
    [super viewDidUnload];
}
@end
