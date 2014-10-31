//
//  VANGlobalMethods.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-26.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event;

static NSDateFormatter *__dateFormatt = nil;

static NSString *athleteRelationship = @"athletes";
static NSString *skillRelationship = @"skill";
static NSString *testRelationship = @"test";

@interface VANGlobalMethods : NSObject

@property (strong, nonatomic) Event *event;
-(id)initwithEvent:(Event *)event;
+ (void)saveManagedObject:(NSManagedObject *)managedObject;
-(NSManagedObject *)addNewRelationship:(NSString *)relationship;


//From ManageTableView

- (void)removeRelationshipObjectInIndexPath:(NSIndexPath *)indexPath forKey:(NSString *)key;
+(NSManagedObject *)addNewRelationship:(NSString *)relationship toManagedObject:(NSManagedObject *)managedObject andSave:(BOOL)save;

@end
