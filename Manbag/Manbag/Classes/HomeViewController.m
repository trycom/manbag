//
//  HomeViewController.m
//  Manbag
//
//  Created by Roy Marmelstein on 08/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "HomeViewController.h"
#import "UITableView+ZGParallelView.h"
#import "NewViewControllerShop.h"
#import "AppDelegate.h"
#import "CentralViewController.h"
#import "bagPoints.h"
#import "DeliveryAddressViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hasZoomed = NO;
    [_tv addParallelViewWithUIView:_map withDisplayRadio:0.5 cutOffAtMax:YES];
    UIBarButtonItem* addNew = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goNew)];
    self.navigationItem.rightBarButtonItem = addNew;
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(goLogout)];
    self.navigationItem.leftBarButtonItem = logout;
    _bags = [[NSMutableArray alloc] init];
    [self validate];

}

- (void)viewDidAppear:(BOOL)animated{
    int dynamicHeight = [UIScreen mainScreen].bounds.size.height - 20 - 44;
    [self.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [self updateBags];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProfileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileCell"];
    }
    NSMutableDictionary* currentBag = [_bags objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d bags - %@" ,[[currentBag objectForKey:@"number"]intValue], [currentBag objectForKey:@"shopName"]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteBag:[_bags objectAtIndex:indexPath.row]];
        [_bags removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bags count];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if (hasZoomed == NO) {
            if(annotationView.annotation == mv.userLocation) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:mv.userLocation.location.coordinate.longitude] forKey:@"longitude"] ;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:mv.userLocation.location.coordinate.latitude] forKey:@"latitude"] ;
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

- (void)goNew{
    NewViewControllerShop* newViewControllerShop = [[NewViewControllerShop alloc] init];
    UINavigationController* newNavController = [[UINavigationController alloc] initWithRootViewController:newViewControllerShop];
    [self presentModalViewController:newNavController animated:YES];
}

- (void)goLogout{
    [PFUser logOut];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centralViewController showTop];
}

- (void)updateBags{
    PFQuery *query = [PFQuery queryWithClassName:@"Bag"];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    [query whereKey:@"delivered" equalTo:[NSNumber numberWithBool:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Works");
            _bags = [objects mutableCopy];
            int i;
            [_map removeAnnotations:_map.annotations];
            for (i=0; i<[_bags count]; i++) {
                NSMutableDictionary* currentBag = [_bags objectAtIndex:i];
                bagPoints* annotation = [[bagPoints alloc] init];
                PFGeoPoint* bagGeoPoint = [currentBag objectForKey:@"shopLocation"];
                annotation.longitude = bagGeoPoint.longitude;
                annotation.latitude = bagGeoPoint.latitude;
                [_map addAnnotation:annotation];
            }
            [_tv reloadData];
        } else {
            NSLog(@"Doesn't work");
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.centralViewController showError:@"Couldn't update shopping"];
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self validate];
}

- (void)deleteBag:(NSMutableDictionary *)bag{
    PFObject* bagToDelete = (PFObject *)bag;
    [bagToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.centralViewController showError:@"Delete failed"];
        }
        [self updateBags];
        [self validate];
    }];
}

- (void)validate{
}

- (IBAction)goDone:(id)sender {
    DeliveryAddressViewController* deliveryAddressViewController = [[DeliveryAddressViewController alloc] init];
    UINavigationController* doneNavController = [[UINavigationController alloc] initWithRootViewController:deliveryAddressViewController];
    deliveryAddressViewController.bags = _bags;
    [self presentModalViewController:doneNavController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTv:nil];
    [self setDoneBtn:nil];
    [self setMap:nil];
    [super viewDidUnload];
}
@end
