//
//  VANPictureTaker.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-10.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VANManagedObjectTableViewController.h"

@interface VANPictureTaker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) VANManagedObjectTableViewController *controller;

-(void)callImagePickerController;

@end
