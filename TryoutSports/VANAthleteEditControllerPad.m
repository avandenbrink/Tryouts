//
//  VANNewAthleteControllerPad.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-02.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteEditControllerPad.h"

@interface VANAthleteEditControllerPad ()

@end

@implementation VANAthleteEditControllerPad

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(void)cancel {
    NSManagedObjectContext *context = [self.athlete managedObjectContext];
    [context deleteObject:self.athlete];
    [self.controller toggleTablesVisible];
    [self.controller dismissViewControllerAnimated:YES
                                                  completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //"YES" create a new athlete and reload the same table with new athlete's data.
        Athlete *athlete = (Athlete *)[self addNewRelationship:@"athletes" toManagedObject:self.event andSave:YES];
        NSNumber *athleteNumber = self.athlete.number;
        athlete.number = [NSNumber numberWithInt:[athleteNumber intValue]+1];
        self.athlete = athlete;
        [self.tableView reloadData];
        //NSMutableSet *athleteSet = [self.event mutableSetValueForKey:@"athletes"];
        //self.controller.athleteList = (NSMutableArray *)[athleteSet allObjects];
        //[self.controller.tableView reloadData];
        
    } else if (buttonIndex == 1 ) { // "NO" Save athlete data and return to athlete list
        //NSMutableSet *athleteSet = [self.event mutableSetValueForKey:@"athletes"];
        //self.controller.athleteList = (NSMutableArray *)[athleteSet allObjects];
        //[self.controller.tableView reloadData];
        [self.controller tabBar:self.controller.tabBar didSelectItem:self.controller.tabBar.selectedItem]; //Finding which controller is selected and reselecting it so that the Athlete list is updated based on its results.
        [self.controller toggleTablesVisible];
        [self.controller dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 170;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}*/


@end