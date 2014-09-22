//
//  VANManagedObjectTableViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
static NSDateFormatter *__dateFormatter = nil;

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "Event.h"   
#import "Skills.h"
#import "Tests.h"
#import "TeamName.h"
#import "VANTeamColor.h"
#import "Positions.h"
#import "VANGlobalMethods.h"


#define kDefaultDate =  @"defaultDate"

@interface VANManagedObjectTableViewController : UITableViewController

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Athlete *athlete;
@property (strong, nonatomic) Skills *skill;
@property (strong, nonatomic) Tests *test;
@property (strong, nonatomic) Positions *position;
-(void)saveManagedObjectContext:(NSManagedObject *)managedObject;

- (void)removeRelationshipObjectInIndexPath:(NSIndexPath *)indexPath forKey:(NSString *)key;
-(NSManagedObject *)addNewRelationship:(NSString *)relationship toManagedObject:(NSManagedObject *)managedObject andSave:(BOOL)save;
 //-(void)addTextFieldContent:(NSString *)content ToContextForTitle:(NSString *)title;
// -(void)adjustContentInsetsForEditing:(BOOL)editing;

@end
