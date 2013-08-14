//
//  Tags.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-08.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Athlete, Event;

@interface Tags : NSManagedObject

@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) Athlete *characteristics;
@property (nonatomic, retain) Event *event;

@end
