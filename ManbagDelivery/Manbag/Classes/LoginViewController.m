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
    dynamicHeight = [UIScreen mainScreen].bounds.size.height - 20;
    [self animateOn];
}

- (void)viewDidAppear:(BOOL)animated{
    dynamicHeight = [UIScreen mainScreen].bounds.size.height - 20;
    [self.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
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

- (void)animateOn{
    int dynamicHalf = dynamicHeight/2;
    [_bottom setFrame:CGRectMake(0, 600, 320, dynamicHalf)];
    _logo.alpha = 0.0;
    CGFloat scaleFactor = 0.7f;
    _logo.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor); //
    [UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _logo.alpha = 1.0;
        CGFloat scaleFactor = 1.15f;
        _logo.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _logo.alpha = 1.0;
            CGFloat scaleFactor = 1.0f;
            _logo.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.9 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_bottom setFrame:CGRectMake(0, dynamicHalf-10, 320, dynamicHalf+10)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [_bottom setFrame:CGRectMake(0, dynamicHalf, 320, dynamicHalf)];
                } completion:^(BOOL finished) {
                    
                }];

            }];
        }];
    }];

}

- (void)animateOff{

}

- (void)viewDidUnload {
    [self setBottom:nil];
    [self setLogo:nil];
    [self setButton:nil];
    [self setBottom:nil];
    [super viewDidUnload];
}
@end
