//
//  LoginViewController.m
//  Manbag
//
//  Created by Roy Marmelstein on 08/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CentralViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)goLogin:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        if (!user) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [appDelegate.centralViewController showError:@"Log in failed. Please try again."];
        } else if (user.isNew) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [appDelegate.centralViewController hideTop];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [appDelegate.centralViewController hideTop];
        }
    }];
}
@end
