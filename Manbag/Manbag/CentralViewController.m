//
//  CentralViewController.m
//  Manbag
//
//  Created by Roy Marmelstein on 08/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "CentralViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface CentralViewController ()

@end

@implementation CentralViewController

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
    PFUser *currentUser = [PFUser currentUser];
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [self addChildViewController:navController];
    [_mainView addSubview:navController.view];
    [navController didMoveToParentViewController:self];
    if (currentUser) {
        [self hideTop];
    } else {
        [self showTop];
        [self showLogin];
    }
}

- (void)showLogin{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self addChildViewController:loginViewController];
    [_topView addSubview:loginViewController.view];
    [loginViewController didMoveToParentViewController:self];
}

- (void)showTop{
    _topView.alpha = 1.0;
}

- (void)hideTop{
    _topView.alpha = 0.0;
}

- (void)showError:(NSString *)text{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setMainView:nil];
    [self setTopView:nil];
    [super viewDidUnload];
}
@end
