//
//  VANPictureTaker.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-10.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANPictureTaker.h"
#import "Image.h"

@implementation VANPictureTaker

-(id)init {
    self = [super init];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.imagePicker.view.frame.size.width - 40, self.imagePicker.view.frame.size.width - 40)];
    ////view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
    //self.imagePicker.cameraOverlayView = view;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    return self;
}

-(void)callImagePickerController {
    [self.controller presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    Image *imageMO = (Image *)[self.controller addNewRelationship:@"headShotImage" toManagedObject:self.controller.athlete andSave:NO];
    imageMO.headShot = imageData;

    [self.controller placeImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    NSLog(@"Number of Images: %lu", (unsigned long)[self.controller.athlete.headShotImage count]);
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

@end
