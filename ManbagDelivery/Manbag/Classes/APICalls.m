//
//  APICalls.m
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "APICalls.h"
#import "AppDelegate.h"
#import "CentralViewController.h"

@implementation APICalls

- (void)getFoursquare:(NSString *)searchTerm {
    double longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue];
    double latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue];
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://api.foursquare.com/v2/venues/search"];
    [urlString appendString:@"?ll="];
    [urlString appendFormat:@"%f,%f", latitude, longitude];
    if (searchTerm.length > 0) {
        [urlString appendString:@"&query="];
        [urlString appendFormat:@"%@", searchTerm];
    }
    [urlString appendString:@"&client_id=FTSMY4GREBF2XBKCQWMXCVTANJHGSFF4IYUW30J5OB42DCEZ"];
    [urlString appendString:@"&client_secret=TMKBKLONRZ3JTIXQGNKYR2E1DISZRCH3WWYFT14PUAJP2OOY"];    
    MKNetworkOperation *op = [self operationWithURLString:urlString params:nil httpMethod:@"GET"];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
            if ([completedOperation responseData]  != nil) {
                NSDictionary *responseDictionary = [[completedOperation responseData] toObject];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FoursquareSuccess" object:self userInfo:responseDictionary];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FoursquareFail" object:nil];
                [self showError:@"Foursquare connection failed"];
            }
    }
             onError:^(NSError *error) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"FoursquareFail" object:nil];
                 [self showError:@"Foursquare connection failed"];
             }];
    [self enqueueOperation:op];
}

- (void)showError:(NSString *)text {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CentralViewController* centralVC = appDelegate.centralViewController;
    [centralVC showError:text];
}

@end
