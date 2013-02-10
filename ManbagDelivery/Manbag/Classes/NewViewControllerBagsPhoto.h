//
//  NewViewControllerBagsPhoto.h
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NewViewControllerBagsPhoto : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    int bagNumber;
}

@property (strong, nonatomic) IBOutlet UIScrollView *bagSelector;
@property (strong, nonatomic) NSMutableDictionary* pickUpLocation;
@property (strong, nonatomic) UIImage* chosenPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIImageView *leftArrow;
@property (strong, nonatomic) IBOutlet UILabel *shopTitle;
@property (strong, nonatomic) IBOutlet MKMapView *map;

- (IBAction)addPhoto:(id)sender;
- (IBAction)goDone:(id)sender;

@end
