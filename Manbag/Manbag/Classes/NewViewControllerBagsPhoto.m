//
//  NewViewControllerBagsPhoto.m
//  Manbag
//
//  Created by Roy Marmelstein on 09/02/2013.
//  Copyright (c) 2013 Seedhack. All rights reserved.
//

#import "NewViewControllerBagsPhoto.h"
#import "AppDelegate.h"
#import "CentralViewController.h"
#import "MBProgressHUD.h"

@interface NewViewControllerBagsPhoto ()

@end

@implementation NewViewControllerBagsPhoto

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
    _chosenPhoto = nil;
    [self validate];
    [self fillBagScroller];
    self.title = [_pickUpLocation objectForKey:@"name"];
    // Do any additional setup after loading the view from its nib.
}

- (void)fillBagScroller{
    int i = 0;
    int width = _bagSelector.frame.size.width;
    int height = _bagSelector.frame.size.height;
    for (i=0; i<20; i++) {
        UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [numberLabel setFont:[UIFont boldSystemFontOfSize:46]];
        [numberLabel setText:[NSString stringWithFormat:@"%d", i+1]];
        [_bagSelector addSubview:numberLabel];
        [_bagSelector setContentSize:CGSizeMake(width*i, 0)];
    }
    [_bagSelector setPagingEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBagSelector:nil];
    [self setPreviewImage:nil];
    [self setDoneBtn:nil];
    [super viewDidUnload];
}

- (IBAction)addPhoto:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select Photo", @"") delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"New Photo", @""), NSLocalizedString(@"Photo Gallery", @""), nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            picker.allowsEditing = YES;
            picker.showsCameraControls = YES;
            [self presentModalViewController:picker animated:YES];
        }
            break;
        case 1:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissModalViewControllerAnimated:YES];
    _chosenPhoto = image;
    _previewImage.image = _chosenPhoto;
    [self validate];
}

- (void)validate{
    int i = 0;
    if (bagNumber == 0) {
        i++;
    }
    NSData *imageData = UIImagePNGRepresentation(_chosenPhoto);

    if (imageData != (NSData *)nil) {
    }
    else {
        i++;
    }
    if (i==0) {
        [_doneBtn setEnabled:YES];
    }
    else {
        [_doneBtn setEnabled:NO];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float fractionalPage = scrollView.contentOffset.x / _bagSelector.frame.size.width;
    NSInteger page = lround(fractionalPage);
    bagNumber = page + 1;
    [self validate];
}

- (IBAction)goDone:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PFObject *bag = [PFObject objectWithClassName:@"Bag"];
        [bag setObject:[NSNumber numberWithInt:bagNumber] forKey:@"number"];
        [bag setObject:[NSNumber numberWithBool:NO] forKey:@"delivered"];
        [bag setObject:[NSNumber numberWithBool:NO] forKey:@"inProgress"];
        [bag setObject:[PFUser currentUser] forKey:@"owner"];
        [bag setObject:[_pickUpLocation objectForKey:@"name"] forKey:@"shopName"];
        [bag setObject:[_pickUpLocation objectForKey:@"address"] forKey:@"shopAddress"];
        PFGeoPoint *location = [PFGeoPoint geoPointWithLatitude:[[_pickUpLocation objectForKey:@"lat"] doubleValue] longitude:[[_pickUpLocation objectForKey:@"lng"] doubleValue]];
        [bag setObject:location forKey:@"shopLocation"];
        NSData *imageData = UIImageJPEGRepresentation(_chosenPhoto, 0.7);
        PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
        [imageFile save];
        [bag setObject:@"receipt" forKey:@"imageName"];
        [bag setObject:imageFile forKey:@"imageFile"];
        [bag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self dismissModalViewControllerAnimated:YES];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                [appDelegate.centralViewController showError:@"Saving failed. Please try again."];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

    
@end
