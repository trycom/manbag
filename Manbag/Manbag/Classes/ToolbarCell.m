//
//  ShopCell.m
//  alertus
//
//  Created by Roy Marmelstein on 25/01/2013.
//  Copyright (c) 2013 Alert.us. All rights reserved.
//

#import "ToolbarCell.h"


@implementation ToolbarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage* counterBackg = [UIImage imageNamed:@"counter.png"];
        UIImage* stretchCounter = [counterBackg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        _bagCountBackg.image = stretchCounter;
        _slotBackg.image = stretchCounter;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}


@end
