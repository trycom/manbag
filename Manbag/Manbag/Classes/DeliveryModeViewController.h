//
//  DeliveryModeViewController.h
//  Manbag
//
//  Created by Roy Marmelstein on 10/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DeliveryModeViewController : UIViewController {
    BOOL hasZoomed;
}

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) PFObject *delivery;
@property (strong, nonatomic) NSMutableDictionary *deliveryMan;
@property (strong, nonatomic) NSTimer *retainedTimer;
@property (strong, nonatomic) IBOutlet UILabel *bagCount;
- (IBAction)gotBags:(id)sender;

@end
