//
//  Athlete+addNew.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "Athlete+addNew.h"

@implementation Athlete (addNew)

-(void)awakeFromInsert {
    self.teamSelected = 0;
    self.seen = 0;
    self.flagged = 0;
    self.checkedIn = 0;
}

+ (Athlete *)athleteWithInfo:(NSDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context
{
    Athlete *athlete = nil;
    
    athlete = [NSEntityDescription insertNewObjectForEntityForName:@"Athlete" inManagedObjectContext:context];
    
    athlete.name = [info valueForKey:@"name"];
    athlete.number = [info valueForKey:@"number"];
    athlete.birthday = [info valueForKey:@"birthday"];
    athlete.email = [info valueForKey:@"email"];
    athlete.position = [info valueForKey:@"position"];
    athlete.phoneNumber = [info valueForKey:@"phoneNumber"];
    
    return  athlete;
}

@end
