//
//  VANAthleteListTabController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
#import "VANAthleteListTabController.h"
#import "VANAthleteListsController.h"
#import "VANNewAthleteController.h"
#import "VANGlobalMethods.h"

@interface VANAthleteListTabController ()

@end

@implementation VANAthleteListTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tab Bar Delegate Methods

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    VANAthleteListsController *controller = (VANAthleteListsController *)viewController;
    controller.event = self.event;
    controller.athleteList = [self.event.athletes allObjects];
    [controller.tableView reloadData];
}

#pragma mark - Custom Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VANNewAthleteController *controller;
    if ([segue.identifier isEqualToString:@"toNewAthlete"]) {
        NSString *device = [[UIDevice currentDevice] model];
        if ([device isEqualToString:@"iPad"]) {
            UINavigationController *nav = segue.destinationViewController;
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            controller = (VANNewAthleteController *)[nav topViewController];
            controller.delegate = self;

        } else {
            controller = segue.destinationViewController;
        }
        controller.athlete = sender;
    }
}

-(void)addNewAthlete:(id)sender {
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    Athlete *athlete = (Athlete *)[methods addNewRelationship:@"athletes" toManagedObject:self.event andSave:NO];
    [self performSegueWithIdentifier:@"toNewAthlete" sender:athlete];
    
}

@end