//
//  VANNewAthleteControllerPad.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-02.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANNewAthleteControllerPad.h"

@interface VANNewAthleteControllerPad ()

@end

@implementation VANNewAthleteControllerPad



-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSManagedObjectContext *context = [self.athlete managedObjectContext];
    [context deleteObject:self.athlete];
}

-(void)cancel {
    [self.controller.popController dismissPopoverAnimated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        Athlete *athlete = (Athlete *)[self addNewRelationship:@"athlete" toManagedObject:self.event andSave:YES];
        self.athlete = athlete;
        [self.tableView reloadData];
        NSMutableSet *athleteSet = [self.event mutableSetValueForKey:@"athlete"];
        self.controller.athleteList = (NSMutableArray *)[athleteSet allObjects];
        [self.controller.tableView reloadData];
    } else if (buttonIndex == 1 ) {
        NSMutableSet *athleteSet = [self.event mutableSetValueForKey:@"athlete"];
        self.controller.athleteList = (NSMutableArray *)[athleteSet allObjects];
        [self.controller.tableView reloadData];
        [self.controller.popController dismissPopoverAnimated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 170;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

@end
