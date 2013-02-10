//
//  ListViewController.h
//  Deliver
//
//  Created by Roy Marmelstein on 10/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) NSMutableArray *deliveries;

@end
