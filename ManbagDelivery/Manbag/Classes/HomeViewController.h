//
//  HomeViewController.h
//  Manbag
//
//  Created by Roy Marmelstein on 08/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    BOOL hasZoomed;
}

@property (strong, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSMutableArray* bags;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;

- (IBAction)goDone:(id)sender;

@end
