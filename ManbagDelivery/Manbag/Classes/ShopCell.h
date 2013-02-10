//
//  ShopCell.h
//  alertus
//
//  Created by Roy Marmelstein on 25/01/2013.
//  Copyright (c) 2013 Alert.us. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShopCell : UITableViewCell {
    
}
@property (strong, nonatomic) IBOutlet UIImageView *preview;
@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UIImageView *bagNumber;
@property (strong, nonatomic) IBOutlet UILabel *bagCounter;

@end
