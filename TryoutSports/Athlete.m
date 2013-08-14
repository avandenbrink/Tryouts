//
//  Athlete.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "Athlete.h"
#import "Event.h"


@implementation Athlete

@dynamic age;
@dynamic birthday;
@dynamic email;
@dynamic name;
@dynamic number;
@dynamic phoneNumber;
@dynamic position;
@dynamic teamSelected;
@dynamic seen;
@dynamic event;
@dynamic headShotImage;
@dynamic skills;
@dynamic aTags;
@dynamic tests;
@dynamic teamAthletes;

-(void)awakeFromInsert {
    self.teamSelected = 0;
    self.seen = 0;
}

@end
