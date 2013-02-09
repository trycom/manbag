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
#import "MBProgressHUD.h"


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudDisappear) name:@"FoursquareFail" object:nil];
    hasZoomed = NO;
    self.title = @"Select Shop";
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setShadowColor:[UIColor whiteColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    _locations = [[NSMutableArray alloc] init];
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goCancel)];
    [logout setTintColor:[UIColor lightGrayColor]];
    self.navigationItem.leftBarButtonItem = logout;
    UIBarButtonItem* locate = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"22-location-arrow.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(resetSearch)];
    [locate setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = locate;

    
    [_tv addParallelViewWithUIView:_map withDisplayRadio:0.5 cutOffAtMax:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        [_searchBar setShowsCancelButton:YES animated:YES];
    }
    else {
        [self resetSearch];
    }
}



- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self resetSearch];
}

- (void)resetSearch{
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    APICalls* apiCalls = [[APICalls alloc] init];
    [apiCalls getFoursquare:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    APICalls* apiCalls = [[APICalls alloc] init];
    [apiCalls getFoursquare:_searchBar.text];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ProfileCell"];
    }
    NSMutableDictionary* currentLocation = [_locations objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentLocation objectForKey:@"name"];
    cell.detailTextLabel.text= [currentLocation objectForKey:@"address"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                APICalls* apiCalls = [[APICalls alloc] init];
                [apiCalls getFoursquare:nil];
                MKCoordinateRegion region;
                MKCoordinateSpan span;
                span.latitudeDelta=0.1;
                span.longitudeDelta=0.1;
                CLLocationCoordinate2D location=mv.userLocation.coordinate;
                region = MKCoordinateRegionMakeWithDistance(location, 500, 500);
                [mv setRegion:region animated:NO];
                [mv regionThatFits:region];
                hasZoomed = YES;
            }
        }
    }
}

-(void)processFoursquare:(NSNotification *)notification{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

- (void)hudDisappear{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    [self setSearchBar:nil];
    [super viewDidUnload];
}


@end
