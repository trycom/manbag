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
#import "ToolbarCell.h"
#import "ShopCell.h"
#import "FinishViewController.h"
#import "DeliveryModeViewController.h"

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
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(goLogout)];
    [logout setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = logout;
    _bags = [[NSMutableArray alloc] init];
    UIImageView* titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navIcon.png"]];
    [self.navigationItem setTitleView:titleView];
    [self validate];
    _retainedTimer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                                                 target:self
                                                                               selector:@selector(pingLocation)
                                                                               userInfo:nil
                                                                                repeats:YES];
    [self pingLocation];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [_delivery setObject:[PFUser currentUser] forKey:@"deliveryMan"];
        [_delivery saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });

}

- (void)viewDidAppear:(BOOL)animated{
    int dynamicHeight = [UIScreen mainScreen].bounds.size.height - 20 - 44;
    [self.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [self updateBags];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    NSLog(@"Making view %d", row);
    switch (row) {
        case 0:
        {
            static NSString *CellIdentifier = @"ToolbarCell";
            ToolbarCell *cell = (ToolbarCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ToolbarCell" owner:self options:nil];
                for (id currentObject in topLevelObjects){
                    if ([currentObject isKindOfClass:[UITableViewCell class]]){
                        cell =  (ToolbarCell *) currentObject;
                        break;
                    }
                }
            }
            UIImage* counterBackg = [UIImage imageNamed:@"counter.png"];
            UIImage* stretchCounter = [counterBackg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
            cell.bagCountBackg.image = stretchCounter;
            cell.slotBackg.image = stretchCounter;
            int i = 0;
            int bagCount = 0;
            for (i=0; i< [_bags count]; i++) {
                NSMutableDictionary* currentBag = [_bags objectAtIndex:i];
                bagCount = bagCount + [[currentBag objectForKey:@"number"] intValue];
            }
            if (bagCount > 0) {
                [cell.finishButton setEnabled:YES];
                cell.slotBackg.alpha = 1.0;
                cell.slotLabel.alpha = 1.0;
                cell.slotTitle.alpha = 1.0;
            }
            else {
                [cell.finishButton setEnabled:NO];
                cell.slotBackg.alpha = 0.0;
                cell.slotLabel.alpha = 0.0;
                cell.slotTitle.alpha = 0.0;
            }
            [cell.finishButton setAction:@selector(goDone:)];
            cell.bagCounter.text = [NSString stringWithFormat:@"%d", bagCount];
            return cell;
            
        }
            break;
        default:
        {
            
            static NSString *CellIdentifier = @"ShopCell";
            ShopCell *cell = (ShopCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShopCell" owner:self options:nil];
                for (id currentObject in topLevelObjects){
                    if ([currentObject isKindOfClass:[UITableViewCell class]]){
                        cell =  (ShopCell *) currentObject;
                        break;
                    }
                }
            }
            int adjustedRow = row - 1;
            NSMutableDictionary* currentBag = [_bags objectAtIndex:adjustedRow];
            cell.shopName.text = [currentBag objectForKey:@"shopName"];
            cell.bagCounter.text = [NSString stringWithFormat:@"%d", [[currentBag objectForKey:@"number"]intValue]];
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    switch (row) {
        case 0:
            return 44;
            break;
        default:
            return 56;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    switch (row) {
        case 0:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bags count]+1;
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
                region = MKCoordinateRegionMakeWithDistance(location, 700, 700);
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
    UIImage* barBackground = [UIImage imageNamed:@"navBar.png"];
    [newNavController.navigationBar setBackgroundImage:barBackground forBarMetrics:UIBarMetricsDefault];
    [self presentModalViewController:newNavController animated:YES];
}

- (void)goLogout{
    [PFUser logOut];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centralViewController showTop];
}

- (void)updateBags{
    [_bags removeAllObjects];
    NSArray* rawBags = [_delivery objectForKey:@"bags"];
    int i;
    for (i=0; i< [rawBags count]; i++) {
        NSMutableDictionary* currentBag = [rawBags objectAtIndex:i];
        PFObject *bag = (PFObject *)currentBag;
        [bag fetch];
        [_bags addObject:bag];
    }
    id userLocation = [_map userLocation];
    [_map removeAnnotations:[_map annotations]];
    if ( userLocation != nil ) {
        [_map addAnnotation:userLocation];
    }
    for (i=0; i<[_bags count]; i++) {
        NSMutableDictionary* currentBag = [_bags objectAtIndex:i];
        bagPoints* annotation = [[bagPoints alloc] init];
        PFGeoPoint* bagGeoPoint = [currentBag objectForKey:@"shopLocation"];
        annotation.longitude = bagGeoPoint.longitude;
        annotation.latitude = bagGeoPoint.latitude;
        [_map addAnnotation:annotation];
    }
    [self zoomToFitMapAnnotations:_map];
    [_tv reloadData];
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

- (void)pingLocation{
    PFGeoPoint *location = [PFGeoPoint geoPointWithLatitude:_map.userLocation.location.coordinate.latitude
                            longitude:_map.userLocation.location.coordinate.longitude];

    [_delivery setObject:location forKey:@"deliveryLocation"];
    [_delivery saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    }];
}

- (IBAction)goDone:(id)sender {
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
    annotationView.image = [UIImage imageNamed:@"pin.png"];
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
    [self setTv:nil];
    [self setDoneBtn:nil];
    [self setMap:nil];
    [super viewDidUnload];
}
@end
