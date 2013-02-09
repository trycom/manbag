//
//  DeliveryAddressViewController.h
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DeliveryAddressViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate> {
    BOOL didLocationZoom;
}

@property (strong, nonatomic) IBOutlet MKMapView *RMMapview;
@property (strong, nonatomic) IBOutlet UISearchBar *RMSearchBar;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) NSMutableArray* bags;

- (IBAction)goDone:(id)sender;

@end
