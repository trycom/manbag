//
//  DeliveryModeViewController.m
//  Manbag
//
//  Created by Roy Marmelstein on 10/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "DeliveryModeViewController.h"
#import "AppDelegate.h"
#import "CentralViewController.h"

@interface DeliveryModeViewController ()

@end

@implementation DeliveryModeViewController

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
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(goLogout)];
    [logout setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = logout;
    UIImageView* titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navIcon.png"]];
    [self.navigationItem setTitleView:titleView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)goLogout{
    [self dismissModalViewControllerAnimated:YES];
    [PFUser logOut];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.centralViewController showTop];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
