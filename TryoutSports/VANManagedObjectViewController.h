//
//  VANManagedObjectConfiguration.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Athlete.h"
#import "Skills.h"
#import "Tests.h"
#import "Positions.h"
#import "VANAppDelegate.h"
#import "VANTeamColor.h"


static NSString *athleteRelationship = @"athletes";
static NSString *skillRelationship = @"skill";
static NSString *testRelationship = @"test";

@interface VANManagedObjectViewController : UIViewController

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Athlete *athlete;
@property (strong, nonatomic) Skills *skill;
@property (strong, nonatomic) Tests *test;
@property (strong, nonatomic) Positions *position;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject;
-(NSManagedObject *)addNewRelationship:(NSString *)relationship;

@end
