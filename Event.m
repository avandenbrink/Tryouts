//
//  Event.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-08.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "Event.h"
#import "Athlete.h"
#import "Positions.h"
#import "Skills.h"
#import "Tests.h"


@implementation Event

@dynamic athleteAge;
@dynamic athleteSignIn;
@dynamic athletesPerTeam;
@dynamic birthYear;
@dynamic endDate;
@dynamic location;
@dynamic manageInfo;
@dynamic name;
@dynamic numTeams;
@dynamic startDate;
@dynamic athletes;
@dynamic positions;
@dynamic skills;
@dynamic tests;

@dynamic teamAthlete;

-(void)awakeFromInsert {
    self.startDate = [NSDate date];
    self.numTeams = [NSNumber numberWithInt:2];
    self.athleteAge = [NSNumber numberWithInt:1];
    self.athletesPerTeam = [NSNumber numberWithInt:1];
    self.athleteSignIn = [NSNumber numberWithInt:1];
    self.manageInfo = [NSNumber numberWithInt:1];
    
    [super awakeFromInsert];
}

@end
