//
//  VANSettingTabsController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
#warning // Possible Crash Issue
//For Some reason on this page some time when the number of teams is changed and the controller is left quickly, the number is regerstered as 1 (or 0) teams as opposed to the real number.  Possibly a cause of the Save button being pressed before the slide is done its animation, but not 100%. Seems to happen when number starts high and moves lower.
#import "VANSettingTabsController.h"
#import "VANNewEventViewController.h"
#import "VANNewSkillsAndTestsController.h"

@interface VANSettingTabsController ()

@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;

- (IBAction)saveEvent:(id)sender;
- (void)cancel;
-(void)saveManagedObjectContext:(NSManagedObject *)managedObject;

@end

@implementation VANSettingTabsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEvent:)];
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    [self.view setTintColor:[teamColor findTeamColor]];
    NSLog(@"Number of Teams Entering %@", self.event.numTeams);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[VANNewEventViewController class]]) {
        VANNewEventViewController *controller = (VANNewEventViewController *)viewController;
        controller.event = self.event;
    } else {
        VANNewSkillsAndTestsController *contorller = (VANNewSkillsAndTestsController *)viewController;
        contorller.event = self.event;
        [contorller.tableView reloadData];
    }
    
}

-(void)cancel {
    NSInteger count = [self.navigationController.viewControllers count];
    UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 2];
    if (![controller isKindOfClass:[VANMainMenuViewController class]]) {
        NSManagedObjectContext *context = [self.event managedObjectContext];
        [context deleteObject:self.event];
    } else {
        self.event.numTeams = [NSNumber numberWithInteger:[self.event.numTeams integerValue] + 1];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveEvent:(id)sender {
    [self.view endEditing:YES];
    
    //Log the Event qualities for debugging Purposes
//    NSLog(@"Name: %@", self.event.name);
//    NSLog(@"Date: %@", [self.event.startDate description]);
//    NSLog(@"Location: %@", self.event.location);
//    NSLog(@"Number of Teams: %@", self.event.numTeams);
//    NSLog(@"Athlete Age: %@", self.event.athleteAge);
//    NSLog(@"Athletes Per Team: %@", self.event.athletesPerTeam);
    
    self.event.numTeams = [NSNumber numberWithInt:[self.event.numTeams intValue] + 1];
    
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
    NSLog(@"Number of Teams : %@", self.event.numTeams);
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
