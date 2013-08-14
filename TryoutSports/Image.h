//
//  Image.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-11.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Athlete;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSData *headShot;
@property (nonatomic, retain) Athlete *athlete;
@end

