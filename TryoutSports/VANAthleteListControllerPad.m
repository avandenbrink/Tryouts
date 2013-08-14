//
//  VANAthleteListControllerPad.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-02.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteListControllerPad.h"
#import "VANNewAthleteControllerPad.h"

@interface VANAthleteListControllerPad ()

@end

@implementation VANAthleteListControllerPad

-(void)viewDidLoad {
    [super viewDidLoad];
    self.detailController = (VANAthleteDetailControllerPad *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

-(void)addNewAthlete:(id)sender {
    Athlete *athlete = (Athlete *)[self addNewRelationship:@"athlete" toManagedObject:self.event andSave:NO];
    UIStoryboard *storyboard = self.storyboard;
    VANNewAthleteControllerPad *controller = [storyboard instantiateViewControllerWithIdentifier:@"newAthlete"];
    controller.athlete = athlete;
    controller.event = self.event;
    controller.controller = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.popController = [[UIPopoverController alloc] initWithContentViewController:nav];
    self.popController.popoverContentSize = CGSizeMake(320, self.view.frame.size.height - 50);
    controller.preferredContentSize = CGSizeMake(self.popController.popoverContentSize.width, self.popController.popoverContentSize.height);
    self.popController.delegate = controller;
    [self.popController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailController.athlete = [self.athleteList objectAtIndex:indexPath.row];
    self.detailController.navigationItem.title = self.detailController.athlete.name;
    NSLog(@"%@", self.detailController.athlete.name);
    [self.detailController.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


@end
