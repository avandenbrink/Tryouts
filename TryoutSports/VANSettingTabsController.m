//
//  VANSettingTabsController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//


#import "VANSettingTabsController.h"
#import "VANEditAthletesViewController.h"


@interface VANSettingTabsController ()

@property (strong, nonatomic) UIBarButtonItem *saveButton;

@end

@implementation VANSettingTabsController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveEvent:)];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    [self.view setTintColor:[teamColor findTeamColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tab Bar Controller Delegate Methods

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[VANNewEventViewController class]]) {
        VANNewEventViewController *controller = (VANNewEventViewController *)viewController;
        controller.event = self.event;
    } else if ([viewController isKindOfClass:[VANNewSkillsAndTestsController class]] || [viewController isKindOfClass:[VANEditAthletesViewController class]]) {
        VANManagedObjectTableViewController *contorller = (VANManagedObjectTableViewController *)viewController;
        contorller.event = self.event;
        [contorller.tableView reloadData];
    }
}

#pragma mark - Custom Methods

- (IBAction)saveEvent:(id)sender {
    [self.view endEditing:YES];
    
    //Checks to ensure that the Name quality is not Empty
    if (self.event.name == nil || [self.event.name isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info Missing" message:@"Your Event must have a name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self saveManagedObjectContext:self.event];
        NSInteger count = [self.navigationController.viewControllers count];
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 2];
        if ([controller isKindOfClass:[VANMainMenuViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self performSegueWithIdentifier:@"toMain" sender:self.event];
        }
    }
}

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject {
    NSError *error = nil;
    if (![managedObject.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.", @"Eror was: %@, quitting."), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts") otherButtonTitles:nil];
        [alert show];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMain"]) {
        VANMainMenuViewController *controller = segue.destinationViewController;
        controller.event = sender;
    }
}

@end
