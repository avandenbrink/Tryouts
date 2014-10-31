//
//  VANAthleteListTabController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
#import "VANAthleteListTabController.h"
#import "VANAthleteListsController.h"
#import "VANAthleteEditController.h"
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
    controller.athleteList = (NSMutableArray *)[self.event.athletes allObjects];
    [controller.tableView reloadData];
}

#pragma mark - Custom Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VANAthleteEditController *controller;
    if ([segue.identifier isEqualToString:@"toNewAthlete"]) {
        NSString *device = [[UIDevice currentDevice] model];
        if ([device isEqualToString:@"iPad"]) {
            UINavigationController *nav = segue.destinationViewController;
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            controller = (VANAthleteEditController *)[nav topViewController];
            controller.delegate = self;

        } else {
            controller = segue.destinationViewController;
        }
        controller.athlete = sender;
    }
}

-(void)addNewAthlete:(id)sender {
    Athlete *athlete = (Athlete *)[VANGlobalMethods addNewRelationship:@"athletes" toManagedObject:self.event andSave:NO];
    [self performSegueWithIdentifier:@"toNewAthlete" sender:athlete];
    
}

@end