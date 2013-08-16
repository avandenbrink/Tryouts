//
//  VANConnectCentreController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "VANManagedObjectViewController.h"


@interface VANConnectCentreController : VANManagedObjectViewController <MFMailComposeViewControllerDelegate>


- (IBAction)exportEvent:(id)sender;

@end
