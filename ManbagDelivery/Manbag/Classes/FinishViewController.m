//
//  FinishViewController.m
//  Manbag
//
//  Created by Roy Marmelstein on 10/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "FinishViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CentralViewController.h"

@interface FinishViewController ()

@end

@implementation FinishViewController

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
    [self animateOn];
    [self validate:nil];
    UIImage* counterBackg = [UIImage imageNamed:@"counter.png"];
    UIImage* stretchCounter = [counterBackg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    _counterBackg.image = stretchCounter;
    int i = 0;
    int bagCount = 0;
    for (i=0; i< [_bags count]; i++) {
        NSMutableDictionary* currentBag = [_bags objectAtIndex:i];
        bagCount = bagCount + [[currentBag objectForKey:@"number"] intValue];
    }
    _counterNumber.text = [NSString stringWithFormat:@"%d", bagCount];
    [_addressField becomeFirstResponder];
    self.title = @"Confirm Delivery";
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setShadowColor:[UIColor whiteColor]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    UIBarButtonItem* logout = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goCancel)];
    [logout setTintColor:[UIColor lightGrayColor]];
    self.navigationItem.leftBarButtonItem = logout;
}

- (IBAction)validate:(id)sender {
    if (_addressField.text.length > 0) {
        [_payButton setEnabled:YES];
    }
    else {
        [_payButton setEnabled:NO];
    }
}

- (void)goCancel{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)animateOn{
    _ticketView.alpha = 0.0;
    CGFloat scaleFactor = 0.7f;
    _ticketView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    _payButton.alpha = 0.0;
    _payButton.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor); //
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _ticketView.alpha = 1.0;
        CGFloat scaleFactor = 1.15f;
        _ticketView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        _payButton.alpha = 1.0;
        _payButton.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _ticketView.alpha = 1.0;
            CGFloat scaleFactor = 1.0f;
            _ticketView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
            _payButton.alpha = 1.0;
            _payButton.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        } completion:^(BOOL finished) {
                }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPay:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PFObject *delivery = [PFObject objectWithClassName:@"Delivery"];
        [delivery setObject:_bags forKey:@"bags"];
        [delivery setObject:[PFUser currentUser] forKey:@"owner"];
        [delivery setObject:_addressField.text forKey:@"ownerAddress"];
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
}

- (void)viewDidUnload {
    [self setTicketView:nil];
    [self setCounterBackg:nil];
    [self setCounterNumber:nil];
    [self setAddressField:nil];
    [self setPayButton:nil];
    [super viewDidUnload];
}
@end
