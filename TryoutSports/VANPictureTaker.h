//
//  VANPictureTaker.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-10.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VANManagedObjectTableViewController.h"
#import "Image.h"

@class VANPictureTaker;

@protocol VANPictureTakerDelegate <NSObject>

//Tells the Delegate that is is completed doing is work and is ready to be dismissed
-(void)pictureTaker:(VANPictureTaker *)object isReadyToDismissWithAnimation:(BOOL)animation;

//Passes the Image that it has taken and selected back to the delegate
-(void)passBackSelectedImageData:(NSData *)imageData;

@end


@interface VANPictureTaker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) id <VANPictureTakerDelegate> delegate;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

-(void)callImagePickerController;

@end
