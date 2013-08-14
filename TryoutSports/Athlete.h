//
//  Athlete.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;
@class Image;

@interface Athlete : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * teamSelected;
@property (nonatomic, retain) NSNumber * seen;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *headShotImage;
@property (nonatomic, retain) NSSet *skills;
@property (nonatomic, retain) NSSet *tests;
@property (nonatomic, retain) NSSet *aTags;
@property (nonatomic, readonly) NSArray *teamAthletes;


@end
