//
//  VANGlobalMethods.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-26.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANGlobalMethods.h"
#import "Event.h"

@implementation VANGlobalMethods

+ (void)initialize {
    __dateFormatt = [[NSDateFormatter alloc] init];
    [__dateFormatt setDateStyle:NSDateFormatterLongStyle];
}

-(id)initwithEvent:(Event *)event {
    self.event = event;
    return self;
}


-(void)saveManagedObject:(NSManagedObject *)managedObject {
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
    [self saveManagedObject:self.event];
    return newAthlete;
}


#pragma mark - from Manage Table View Methods

- (void)removeRelationshipObjectInIndexPath:(NSIndexPath *)indexPath forKey:(NSString *)key {
    
    NSMutableSet *relationshipSet = [self.event mutableSetValueForKey:key];
    NSManagedObject *relationshipObject = [[relationshipSet allObjects] objectAtIndex:[indexPath row]];
    [relationshipSet removeObject:relationshipObject];
    [self saveManagedObject:self.event];
}

-(NSManagedObject *)addNewRelationship:(NSString *)relationship toManagedObject:(NSManagedObject *)managedObject andSave:(BOOL)save {
    
    NSMutableSet *relationshipSet = [managedObject mutableSetValueForKey:relationship];
    NSEntityDescription *entity = [managedObject entity];
    NSDictionary *relationships = [entity relationshipsByName];
    NSRelationshipDescription *destRelationship = [relationships objectForKey:relationship];
    NSEntityDescription *destEntity = [destRelationship destinationEntity];
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[destEntity name] inManagedObjectContext:managedObject.managedObjectContext];
    [relationshipSet addObject:newManagedObject];
    if (save) {
        [self saveManagedObject:managedObject];
        
    }
    return newManagedObject;
}

@end
