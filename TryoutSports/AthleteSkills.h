//
//  AthleteSkills.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Athlete;

@interface AthleteSkills : NSManagedObject

@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Athlete *athlete;

@end
