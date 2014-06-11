//
//  VANSettingTabsController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANTabController.h"
#import "VANNewEventViewController.h"
#import "VANNewSkillsAndTestsController.h"

@interface VANSettingTabsController : VANTabController <UITabBarControllerDelegate>

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject;
- (IBAction)saveEvent:(id)sender;
- (void)cancel;

@end
