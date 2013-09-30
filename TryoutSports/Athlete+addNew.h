//
//  Athlete+addNew.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "Athlete.h"

@interface Athlete (addNew)

-(void)awakeFromInsert;
+ (Athlete *)athleteWithInfo:(NSDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context;

@end
