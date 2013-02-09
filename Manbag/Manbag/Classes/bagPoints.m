//
//  bagPoints.m
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "bagPoints.h"

@implementation bagPoints

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coord = {self.latitude, self.longitude};
    return coord;
}

- (NSString *) title {
    return _name;
}

@end
