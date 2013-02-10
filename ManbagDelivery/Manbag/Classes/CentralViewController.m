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
    if (currentUser) {
        [self hideTop];
    } else {
        [self showTop];
    }
    dynamicHeight = [UIScreen mainScreen].bounds.size.height - 20;
    _homeViewController = [[HomeViewController alloc] init];
    _navController = [[UINavigationController alloc] initWithRootViewController:_homeViewController];
    [self addChildViewController:_navController];
    [_navController.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [_mainView addSubview:_navController.view];
    [_navController.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [_mainView setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [_topView setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [_navController.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    UIImage* barBackground = [UIImage imageNamed:@"navBar.png"];
    [_navController.navigationBar setBackgroundImage:barBackground forBarMetrics:UIBarMetricsDefault];
    [_homeViewController.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [_navController didMoveToParentViewController:self];
    _loginViewController = [[LoginViewController alloc] init];
    [self addChildViewController:_loginViewController];
    [_loginViewController.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [_topView addSubview:_loginViewController.view];
    [_topView setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [_loginViewController.view setFrame:CGRectMake(0, 0, 320, dynamicHeight)];
    [_loginViewController didMoveToParentViewController:self];
    _complimentView.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)showLogin{
}

- (void)showTop{
    [UIView animateWithDuration:0.8 animations:^{
        _topView.alpha = 1.0;
        _mainView.alpha = 0.6;
    } completion:^(BOOL finished) {
        topVisible =  YES;
    }];

}

- (void)hideTop{
    [UIView animateWithDuration:0.8 animations:^{
        _mainView.alpha = 1.0;
        _topView.alpha = 0.0;
    } completion:^(BOOL finished) {
        topVisible =  NO;
    }];
    [_homeViewController viewDidAppear:YES];
}


- (void)showError:(NSString *)text{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

-(void)showCompliment{
    int random = arc4random() % 4;
    NSArray* complimentsArray = [[NSArray alloc] initWithObjects:@"You look fantastic!", @"I love it", @"Awesome!", @"Brilliant!", @"Just perfect...", nil];
    _compliment.text = [complimentsArray objectAtIndex:random];
    _complimentView.alpha = 1.0;
    _complimentView.transform = CGAffineTransformMakeRotation(-M_PI);
    CGFloat scaleFactor = 0.5f;
    _complimentView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _complimentView.transform = CGAffineTransformMakeRotation(M_PI);
        CGFloat scaleFactor = 1.15f;
        _complimentView.alpha = 1.0;
        _complimentView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGFloat scaleFactor = 1.0f;
            _complimentView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(hideCompliment) withObject:self afterDelay:1.3];
        }];
    }];
    
}

- (void)hideCompliment{
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGFloat scaleFactor = 0.5f;
        _complimentView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _complimentView.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setMainView:nil];
    [self setTopView:nil];
    [self setCompliment:nil];
    [self setComplimentView:nil];
    [super viewDidUnload];
}
@end
