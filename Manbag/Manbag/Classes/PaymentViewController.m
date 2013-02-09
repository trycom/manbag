//
//  PaymentViewController.m
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "PaymentViewController.h"
#import "Stripe.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

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
    self.price = [NSNumber numberWithInt:10];
    // Do any additional setup after loading the view from its nib.
}

- (SEL)textFieldSelectorForCardProperty:(NSString *)property
{
    NSString *fieldName = [property stringByAppendingString:@"TextField"];
    SEL textFieldSelector = NSSelectorFromString(fieldName);
    
    if ([self respondsToSelector:textFieldSelector])
        return textFieldSelector;
    else
        return NULL;
}

- (void)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (IBAction)orderButton:(id)sender
{
    [self resetErrors];
    STPCard *card = [[STPCard alloc] init];
    NSArray *propertiesToValidate = [NSArray arrayWithObjects:@"number", @"expMonth", @"expYear", @"cvc", nil];
    
    BOOL didValidate = YES;
    for (NSString *property in propertiesToValidate)
    {
        SEL textFieldSelector = [self textFieldSelectorForCardProperty:property];
        if (textFieldSelector)
        {
            NSString *textValue = [[self performSelector:textFieldSelector] performSelector:@selector(text)];
            [card setValue:textValue forKey:property];
            /*
             // If you want to do property-by-property validation, uncomment this block.  The call to "validateCardReturningError" below, however, is enough to catch validation errors on the card itself
             NSError *validationError = NULL;
             
             if (![card validateValue:&textValue forKey:property error:&validationError])
             {
             [self handleStripeError:(validationError)];
             didValidate = NO;
             }
             */
            
        }
        
    }
    
    if (didValidate)
    {
        NSError *overallError = NULL;
        [card validateCardReturningError:&overallError];
        if (overallError)
            [self handleStripeError:overallError];
        else
        {
            STPSuccessBlock successHandler = ^(STPToken *token)
            {
                NSLog(@"Created token with ID: %@", token.tokenId);
            };
            
            STPErrorBlock errorHandler = ^(NSError *error)
            {
                NSLog(@"Error code: %d", [error code]);
                NSLog(@"User facing error message: %@", [error localizedDescription]);
                NSLog(@"Error parameter: %@", [[error userInfo] valueForKey:STPErrorParameterKey]);
                NSLog(@"Developer facing error message: %@", [[error userInfo] valueForKey:STPErrorMessageKey]);
                NSLog(@"Card error code: %@", [[error userInfo] valueForKey:STPCardErrorCodeKey]);
                
            };
            
            [Stripe createTokenWithCard:card
                         publishableKey:@"pk_test_GdG6LpjvidWe2gtQ65oPgTRM"
                                success:successHandler
                                  error:errorHandler];
        }
    }
}

- (void)handleStripeError:(NSError *)error
{
    if ([error domain] == StripeDomain)
    {
        if ([[self.cardErrorLabel text] isEqualToString:@""])
            [self.cardErrorLabel setText:[error localizedDescription]];
        if ([error code] == STPCardError)
        {
            NSString *errorParameter = [[error userInfo] valueForKey:STPErrorParameterKey];
            if (errorParameter)
            {
                SEL textFieldSelector = [self textFieldSelectorForCardProperty:errorParameter];
                if (textFieldSelector)
                {
                    [[self performSelector:textFieldSelector] setBackgroundColor:[UIColor redColor]];
                }
            }
        }
    }
}

- (void)resetErrors
{
    [self.cardErrorLabel setText:@""];
    [self.numberTextField setBackgroundColor:[UIColor whiteColor]];
    [self.expMonthTextField setBackgroundColor:[UIColor whiteColor]];
    [self.expYearTextField setBackgroundColor:[UIColor whiteColor]];
    [self.cvcTextField setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
