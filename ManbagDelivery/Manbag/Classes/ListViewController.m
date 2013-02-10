//
//  ListViewController.m
//  Deliver
//
//  Created by Roy Marmelstein on 10/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "ListViewController.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CentralViewController.h"
#import "HomeViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

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
    _deliveries = [[NSMutableArray alloc] init];
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(goLogout)];
    [logout setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = logout;
    UIImageView* titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navIcon.png"]];
    [self.navigationItem setTitleView:titleView];
}

- (void)viewDidAppear:(BOOL)animated{
    [self checkDelivery];
}

- (void)checkDelivery{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        {
            PFQuery *query = [PFQuery queryWithClassName:@"Delivery"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSLog(@"GETS %@", objects);
                    _deliveries = [objects mutableCopy];
                    [_tv reloadData];
                } else {
                }
            }];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *delivery = (PFObject *)[_deliveries objectAtIndex:indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [delivery setObject:[PFUser currentUser] forKey:@"deliveryMan"];
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                [delivery setObject:geoPoint forKey:@"deliveryLocation"];
            }
        }];
        [delivery saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self dismissModalViewControllerAnimated:YES];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                [appDelegate.centralViewController showError:@"Ordering failed. Please try again."];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });

    
   HomeViewController* homeViewController = [[HomeViewController alloc] init];
    homeViewController.delivery = delivery;
    [self.navigationController pushViewController:homeViewController animated:YES];
    [_tv deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProfileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ProfileCell"];
    }
    NSMutableDictionary* currentDelivery = [_deliveries objectAtIndex:indexPath.row];
//    cell.textLabel.text = [currentLocation objectForKey:@"name"];
    NSArray* bags = [currentDelivery objectForKey:@"bags"];
    int bagCount = 0;
    int i;
    for (i=0; i< [bags count]; i++) {
        NSMutableDictionary* currentBag = [bags objectAtIndex:i];
        PFObject *bag = (PFObject *)currentBag;
        [bag fetch];
        NSLog(@"%@", bag);
        bagCount = bagCount + [[bag objectForKey:@"number"] intValue];
    }
    cell.detailTextLabel.text= [currentDelivery objectForKey:@"ownerAddress"];
    cell.textLabel.text = [NSString stringWithFormat:@"%d shops - %d bags", [bags count], bagCount];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_deliveries count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTv:nil];
    [super viewDidUnload];
}
@end
