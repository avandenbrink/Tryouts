//
//  TeamName.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-20.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface TeamName : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *atheltes;
@property (nonatomic, retain) Event *event;
@end
