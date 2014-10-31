//
//  VANNewEventData.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-24.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VANNewEventData : NSObject

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSArray *positions;
@property (strong, nonatomic) NSArray *skills;
@property (strong, nonatomic) NSArray *tests;
@property (strong, nonatomic) NSArray *teams;

@end
