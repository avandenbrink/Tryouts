//
//  Positions.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Positions : NSManagedObject

@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) Event *event;

@end
