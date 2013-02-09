//
//  PaymentViewController.h
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (copy) NSNumber *price;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *expMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *expYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvcTextField;
@property (weak, nonatomic) IBOutlet UILabel *cardErrorLabel;

- (IBAction)orderButton:(id)sender;

@end
