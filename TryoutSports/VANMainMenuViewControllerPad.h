//
//  VANMainMenuViewControllerPad.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMainMenuViewController.h"

typedef NS_ENUM(NSUInteger, VANNotificationImportance) {
    VANNotificationImportanceDone = 0,
    VANNotificationImportanceNeutral,
    VANNotificationImportanceWarning,
    VANNotificationImportanceError
};

typedef NS_ENUM(NSUInteger, VANNotificationAction) {
    VANNotificationActionToSettings = 0,
    VANNotificationActionToTeams,
    VANNotificationActionToAthletes,
    VANNotificationActionToAthletesFlagged,
    VANNotificationActionToAthletesSeen,
};

@interface VANMainMenuViewControllerPad : VANMainMenuViewController <UIActionSheetDelegate, UIActivityItemSource>


@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet UIView *infoContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTrailingConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *athletesImageView;

//Inside info Container
@property (weak, nonatomic) IBOutlet UITableView *notificationTable;


- (IBAction)sendToDevice:(id)sender;
-(void)releaseAthleteDetailViews;
-(IBAction)toAthleteSignIn:(id)sender;

@end
