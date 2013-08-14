//
//  AthleteTags.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-08.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Athlete;

@interface AthleteTags : NSManagedObject

@property (nonatomic, retain) NSString * descriptor;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Athlete *athlete;

@end
