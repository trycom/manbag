//
//  ShopCell.h
//  alertus
//
//  Created by Roy Marmelstein on 25/01/2013.
//  Copyright (c) 2013 Alert.us. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ToolbarCell : UITableViewCell {
    
}
@property (strong, nonatomic) IBOutlet UIImageView *bagCountBackg;
@property (strong, nonatomic) IBOutlet UIImageView *slotBackg;
@property (strong, nonatomic) IBOutlet UILabel *bagCounter;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *finishButton;
@property (strong, nonatomic) IBOutlet UILabel *slotLabel;
@property (strong, nonatomic) IBOutlet UILabel *slotTitle;

@end
