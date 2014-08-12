//
//  Event.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-08.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Athlete, Positions, Skills, Tests;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * athleteAge;
@property (nonatomic, retain) NSNumber * athleteSignIn;
@property (nonatomic, retain) NSNumber * athletesPerTeam;
@property (nonatomic, retain) NSDate * birthYear;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSData *logo;
@property (nonatomic, retain) NSNumber * manageInfo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numTeams;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSSet *athletes;
@property (nonatomic, retain) NSSet *positions;
@property (nonatomic, retain) NSSet *skills;
@property (nonatomic, retain) NSSet *tests;

@property (nonatomic, retain) NSArray *teamAthlete;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addAthleteObject:(Athlete *)value;
- (void)removeAthleteObject:(Athlete *)value;
- (void)addAthlete:(NSSet *)values;
- (void)removeAthlete:(NSSet *)values;

- (void)addPositionsObject:(Positions *)value;
- (void)removePositionsObject:(Positions *)value;
- (void)addPositions:(NSSet *)values;
- (void)removePositions:(NSSet *)values;

- (void)addSkillsObject:(Skills *)value;
- (void)removeSkillsObject:(Skills *)value;
- (void)addSkills:(NSSet *)values;
- (void)removeSkills:(NSSet *)values;

- (void)addTestsObject:(Tests *)value;
- (void)removeTestsObject:(Tests *)value;
- (void)addTests:(NSSet *)values;
- (void)removeTests:(NSSet *)values;

@end
