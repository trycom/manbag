//
//  RMAnnotationDelegate.h
//  RMLocationChooser
//
//  Created by Roy Marmelstein on 02/07/2012.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RMAnnotationDelegate : NSObject <MKAnnotation> {

}

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate; 

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
