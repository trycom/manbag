//
//  NewViewControllerShop.m
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "NewViewControllerShop.h"
#import "UITableView+ZGParallelView.h"
#import "AppDelegate.h"
#import "CentralViewController.h"
#import "APICalls.h"
#import "NewViewControllerBagsPhoto.h"


@interface NewViewControllerShop ()

@end

@implementation NewViewControllerShop

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processFoursquare:) name:@"FoursquareSuccess" object:nil];
    hasZoomed = NO;
    _locations = [[NSMutableArray alloc] init];
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goCancel)];
    self.navigationItem.leftBarButtonItem = logout;
    [_tv addParallelViewWithUIView:_map withDisplayRadio:0.5 cutOffAtMax:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewViewControllerBagsPhoto* newViewControllerBagsPhoto = [[NewViewControllerBagsPhoto alloc] init];
    newViewControllerBagsPhoto.pickUpLocation = [_locations objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:newViewControllerBagsPhoto animated:YES];
    [_tv deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProfileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileCell"];
    }
    NSMutableDictionary* currentLocation = [_locations objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentLocation objectForKey:@"name"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_locations count];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if (hasZoomed == NO) {
            if(annotationView.annotation == mv.userLocation) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:mv.userLocation.location.coordinate.longitude] forKey:@"longitude"] ;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:mv.userLocation.location.coordinate.latitude] forKey:@"latitude"];
                APICalls* apiCalls = [[APICalls alloc] init];
                [apiCalls getFoursquare:nil];
                MKCoordinateRegion region;
                MKCoordinateSpan span;
                span.latitudeDelta=0.1;
                span.longitudeDelta=0.1;
                CLLocationCoordinate2D location=mv.userLocation.coordinate;
                region = MKCoordinateRegionMakeWithDistance(location, 500, 500);
                [mv setRegion:region animated:TRUE];
                [mv regionThatFits:region];
                hasZoomed = YES;
            }
        }
    }
}

-(void)processFoursquare:(NSNotification *)notification{
    NSDictionary* foursquareDict = notification.userInfo;
    NSArray *itemsArray = [[[[foursquareDict objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
    [_locations removeAllObjects];
    int i;
    for (i=0; i<[itemsArray count]; i++) {
        NSDictionary *foursquareLocation = [itemsArray objectAtIndex:i];
        NSMutableDictionary* tempLocation = [[NSMutableDictionary alloc] init];
        [tempLocation setObject:[foursquareLocation objectForKey:@"name"] forKey:@"name"];
        NSString* address = [[foursquareLocation objectForKey:@"location"] objectForKey:@"address"];
        [tempLocation setObject:[[foursquareLocation objectForKey:@"location"] objectForKey:@"lat"] forKey:@"lat"];

        [tempLocation setObject:[[foursquareLocation objectForKey:@"location"] objectForKey:@"lng"] forKey:@"lng"];
        if (address.length > 0) {
            [tempLocation setObject:[[foursquareLocation objectForKey:@"location"] objectForKey:@"address"] forKey:@"address"];
            [_locations addObject:tempLocation];
        }
    }
    [_tv reloadData];
    NSLog(@"items array is %@", itemsArray);
}

- (void)goCancel{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTv:nil];
    [self setMap:nil];
    [super viewDidUnload];
}


@end
