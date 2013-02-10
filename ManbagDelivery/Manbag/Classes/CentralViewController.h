//
//  CentralViewController.h
//  Manbag
//
//  Created by Roy Marmelstein on 08/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "LoginViewController.h"

@interface CentralViewController : UIViewController {
    int dynamicHeight;
    BOOL topVisible;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) HomeViewController* homeViewController;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) LoginViewController* loginViewController;
@property (strong, nonatomic) IBOutlet UILabel *compliment;
@property (strong, nonatomic) IBOutlet UIView *complimentView;

- (void)showTop;
- (void)hideTop;
- (void)showError:(NSString *)text;
-(void)showCompliment;
@end
