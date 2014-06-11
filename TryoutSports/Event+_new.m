//
//  Event+_new.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/2/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "Event+_new.h"

@implementation Event (_new)

-(void)awakeFromInsert {
    self.startDate = [NSDate date];
    self.numTeams = [NSNumber numberWithInt:1];
    self.athleteAge = [NSNumber numberWithInt:1];
    self.athletesPerTeam = [NSNumber numberWithInt:1];
    self.athleteSignIn = [NSNumber numberWithBool:YES];
    self.manageInfo = [NSNumber numberWithBool:YES];
    
    [super awakeFromInsert];
}

@end
