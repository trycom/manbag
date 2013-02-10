//
//  RMAnnotationDelegate.m
//  RMLocationChooser
//
//  Created by Roy Marmelstein on 02/07/2012.
//

#import "RMAnnotationDelegate.h"

@implementation RMAnnotationDelegate
@synthesize longitude, latitude, coordinate, name;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    coordinate=coord;
    return self;
}

-(CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate; 
}

- (NSString *) title {
    return name;
}

@end
