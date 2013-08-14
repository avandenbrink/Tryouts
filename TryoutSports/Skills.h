//
//  Skills.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-08.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Skills : NSManagedObject

@property (nonatomic, retain) NSString * descriptor;
@property (nonatomic, retain) Event *event;

@end
