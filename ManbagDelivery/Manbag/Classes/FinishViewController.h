//
//  FinishViewController.h
//  Manbag
//
//  Created by Roy Marmelstein on 10/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *ticketView;
@property (strong, nonatomic) IBOutlet UIImageView *counterBackg;
@property (strong, nonatomic) IBOutlet UILabel *counterNumber;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) NSMutableArray* bags;
@property (strong, nonatomic) IBOutlet UIButton *payButton;


- (IBAction)goPay:(id)sender;
- (IBAction)validate:(id)sender;

@end
