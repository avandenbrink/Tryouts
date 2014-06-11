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

@interface VANMainMenuViewControllerPad : VANMainMenuViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notificationTable;
@property (weak, nonatomic) IBOutlet UIView *logoBGView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIView *logoSeparator;

-(void)releaseAthleteDetailViews;
-(IBAction)toAthleteSignIn:(id)sender;

@end
