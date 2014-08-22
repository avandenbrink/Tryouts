//
//  VANConnectCentreController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "VANManagedObjectViewController.h"
#import "VANMainMenuViewController.h"


@interface VANConnectCentreController : VANManagedObjectViewController <MFMailComposeViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *airdrop;

- (IBAction)sendViaAirdrop:(id)sender;

- (IBAction)exportEvent:(id)sender;

@end
