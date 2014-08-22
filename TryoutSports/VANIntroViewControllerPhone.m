//
//  VANIntroViewControllerPhone.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-12.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANIntroViewControllerPhone.h"
#import "VANSettingTabsController.h"


@interface VANIntroViewControllerPhone ()

@end

@implementation VANIntroViewControllerPhone


#pragma mark - TableView Delegate Methods

 -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 return 40;
 }
 
 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,40)];
 view.backgroundColor = [UIColor clearColor];
 return view;
 }

#pragma mark - Segue Methods - iPhone/Pod Specific

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toAppSettings"]) {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        VANAppSettingsViewController *settingsController = (VANAppSettingsViewController *)[navController topViewController];
        settingsController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"toNewEvent"]) {
        if ([sender isKindOfClass:[NSManagedObject class]]) {
            VANNewEventViewController *newEventController = segue.destinationViewController;
            newEventController.event = sender;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Event Detail Error", @"Event Detail Error") message:NSLocalizedString(@"Error Showing Detail",@"Error Showing Detail") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
            [alert show];
        }
    } else if ([segue.identifier isEqualToString:@"toNewEventSettings"]) {
        if ([sender isKindOfClass:[NSArray class]]) {
            VANNewEventViewController *controller = segue.destinationViewController;
            controller.event = [sender firstObject];
            controller.document = [sender lastObject];
            controller.isNewEvent = YES;
            controller.delegate = self;
        } else {
            NSLog(@"Sender is not an array!");
        }

        
//        VANSettingTabsController *tabBarController = segue.destinationViewController;
//        tabBarController.delegate = tabBarController;
//        tabBarController.event = sender;
//        tabBarController.selectedIndex = 0;
//        if (tabBarController.selectedIndex == 1) {
//            VANNewSkillsAndTestsController *controller = (VANNewSkillsAndTestsController *)[tabBarController.viewControllers objectAtIndex:1];
//            controller.event = sender;
//        } else {
//            VANNewEventViewController *controller = (VANNewEventViewController *)[tabBarController.viewControllers objectAtIndex:0];
//            controller.event = tabBarController.event;
//        }
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}
#pragma mark - Add new Event to iPhone

- (IBAction)addEvent:(id)sender
{
    [self createNewFileWithName:defaultName]; //Requires the listener function completeNewEventCreationWithEvent
}

-(void)completeNewEventCreationWithEvent:(Event *)event inDocument:(VANTryoutDocument *)document {
    [self performSegueWithIdentifier:@"toNewEventSettings" sender:@[event, document]];
}

@end
