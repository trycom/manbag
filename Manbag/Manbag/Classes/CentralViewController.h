//
//  CentralViewController.h
//  Manbag
//
//  Created by Roy Marmelstein on 08/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface CentralViewController : UIViewController {
    int dynamicHeight;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) HomeViewController* homeViewController;

- (void)showTop;
- (void)hideTop;
- (void)showError:(NSString *)text;

@end
