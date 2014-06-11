//
//  VANMainMenuViewController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-03-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMainMenuViewController.h"
#import "VANTeamColor.h"
#import "VANEventSettingsViewController.h"
#import "VANNewSkillsAndTestsController.h"
#import "VANTagsViewController.h"
#import "VANTeamsController.h"
#import "VANSettingTabsController.h"
#import "VANConnectCentreController.h"
#import "VANDecisionRoomViewController.h"


@interface VANMainMenuViewController ()
@property (strong, nonatomic) UIBarButtonItem *backButton;
-(void)back;

@end

@implementation VANMainMenuViewController

+ (void)initialize {
    __dateFormatter = [[NSDateFormatter alloc] init];
    [__dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.title = self.event.name;
    if (self.event.athleteSignIn == [NSNumber numberWithInt:0]) {
        self.athleteSignIn.hidden = YES;
    }
    [self.athleteStatView initiateWithEventInfo:self.event];
    
    //Customize Some of the views
    self.mainView.layer.shadowOpacity = 0.3;
    self.mainView.layer.shadowOffset = CGSizeMake(0, 3);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.athleteStatView findPercentAndAnimateChangesForEvent:self.event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toEventSettings"]) {
        if ([sender isKindOfClass:[NSManagedObject class]]) {
            VANSettingTabsController *tabBarController = segue.destinationViewController;
            tabBarController.delegate = tabBarController;
            tabBarController.event = sender;
            if (tabBarController.selectedIndex == 1) {
                VANNewSkillsAndTestsController *controller = (VANNewSkillsAndTestsController *)[tabBarController.viewControllers objectAtIndex:1];
                controller.event = sender;
            } else {
                VANNewEventViewController *controller = (VANNewEventViewController *)[tabBarController.viewControllers objectAtIndex:0];
                controller.event = sender;
            }

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hero Detail Error", @"Hero Detail Error") message:NSLocalizedString(@"Error Showing Detail",@"Error Showing Detail") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
            [alert show];
        }
    } else /*if ([segue.identifier isEqualToString:@"toAthleteList"])*/ {
        VANAthleteListViewController *viewController = segue.destinationViewController;
        viewController.event = sender;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.athleteStatView findPercentAndAnimateChangesForEvent:self.event];
}

#pragma mark - Custom Controller Button Actions

- (IBAction)pushtoEventSettings:(id)sender {
    [self performSegueWithIdentifier:@"toEventSettings" sender:self.event];
}

- (IBAction)pushToAthleteList:(id)sender {
    [self performSegueWithIdentifier:@"toAthleteList" sender:self.event];
}

- (IBAction)editSkills:(id)sender {
    
    //// Considered Looking at whether this VANSettingsController Already existed in the Navigation Stack (AKA even was newly created, so duplication of controllers wouldn't be needed but the Issue became trying to differenctiate the Cancel Button to decided wether to delete the Event and return to Intro Controller, or Move back to Main View and preserve the event (which is obviously what is need when editing these settings at a later date) So for now will work with adding a second Tab View Controller to the stack if it is edited in the same session as the event was created.
    //UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:1];
    //if ([controller isKindOfClass:[VANSettingTabsController class]]) {
    //    NSLog(@"Popping Edit View Controller");
    //    [self.navigationController popViewControllerAnimated:YES];
    //} else {
    //    NSLog(@"Pushing Edit View Controller");
        [self performSegueWithIdentifier:@"toEventSettings" sender:self.event];
    //}
}

- (IBAction)toTeams:(id)sender {
    [self performSegueWithIdentifier:@"toTeams" sender:self.event];
}

- (IBAction)toConnectCentre:(id)sender {
    [self performSegueWithIdentifier:@"toConnect" sender:self.event];
}

- (IBAction)toDecisionRoom:(id)sender {
    [self performSegueWithIdentifier:@"toDecisionRoom" sender:self.event];
}



@end
