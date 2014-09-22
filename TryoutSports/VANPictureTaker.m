//
//  VANPictureTaker.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-10.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANPictureTaker.h"

static int imageSize = 400;

@implementation VANPictureTaker

-(id)init
{
    self = [super init];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.imagePicker.view.frame.size.width - 40, self.imagePicker.view.frame.size.width - 40)];
    view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
    self.imagePicker.cameraOverlayView = view;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    return self;
}

-(void)callImagePickerController
{
    NSLog(@"*** Warning: This CallImagePickerController Method is Outdated");
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([_delegate respondsToSelector:@selector(pictureTaker:isReadyToDismissWithAnimation:)]) {
        [_delegate pictureTaker:self isReadyToDismissWithAnimation:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:image width:imageSize height:imageSize];
    NSData *imageData = UIImagePNGRepresentation(resizedImage);

    if ([_delegate respondsToSelector:@selector(passBackSelectedImageData:)]) {
        [_delegate passBackSelectedImageData:imageData];
        [_delegate pictureTaker:self isReadyToDismissWithAnimation:YES];
    } else {
        NSLog(@"*** Warning: Image Picker Delegate does not respond to passedImage");
    }
    
}

-(UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height
{
    CGImageRef imageRef = [image CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);

    //if (alphaInfo == kCGImageAlphaNone)
    alphaInfo = kCGImageAlphaNoneSkipLast;
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), (CGBitmapInfo) alphaInfo);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}


@end
