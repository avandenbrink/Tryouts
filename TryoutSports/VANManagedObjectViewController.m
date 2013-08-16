//
//  VANManagedObjectConfiguration.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANManagedObjectViewController.h"


@implementation VANManagedObjectViewController

+ (void)initialize {
    __dateFormatt = [[NSDateFormatter alloc] init];
    [__dateFormatt setDateStyle:NSDateFormatterLongStyle];
}

-(void)viewDidLoad {
    VANTeamColor *teamcolor = [[VANTeamColor alloc] init];
    [self.view setTintColor:[teamcolor findTeamColor]];
    
}

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject {
    NSError *error = nil;
    if (![managedObject.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.", @"Eror was: %@, quitting."), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts") otherButtonTitles:nil];
        [alert show];
    }
}

-(NSManagedObject *)addNewRelationship:(NSString *)relationship {
    NSMutableSet *relationshipSet = [self.event mutableSetValueForKey:relationship];
    
    NSEntityDescription *entity = [self.event entity];
    NSDictionary *relationships = [entity relationshipsByName];
    NSRelationshipDescription *destRelationship = [relationships objectForKey:relationship];
    NSEntityDescription *destEntity = [destRelationship destinationEntity];
    
    NSManagedObject *newAthlete = [NSEntityDescription insertNewObjectForEntityForName:[destEntity name] inManagedObjectContext:[self.event managedObjectContext]];
    [relationshipSet addObject:newAthlete];
    [self saveManagedObjectContext:self.event];
    return newAthlete;
}

@end
