//
//  VANNewAthleteController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "VANManagedObjectTableViewController.h"
#import "VANAthleteListTabController.h"
#import "VANPictureTaker.h"
#import "NewTableConfiguration.h"

@protocol VANAthleteEditDelegate <NSObject>

@optional
-(void)closeAthleteEditPopover;

@end


@interface VANAthleteEditController : VANManagedObjectTableViewController <UIActionSheetDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, VANPictureTakerDelegate, VANTableViewCellExpansionDelegate>

@property (nonatomic, weak) id <VANAthleteEditDelegate> delegate;
@property (nonatomic) BOOL isNew;


-(void)saveAthleteAndClose;
-(void)cancel;
- (IBAction)launchCamera:(id)sender;
@end
