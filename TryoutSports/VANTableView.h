//
//  VANTableView.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 11/5/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Athlete;
@class Event;

@interface VANTableView : UITableView

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Athlete *athlete;

-(void)adjustTableForKeyboard;
-(void)saveManagedObjectContext:(NSManagedObject *)managedObject;


//Used by VANAddTagCell to create new Characteristic also declaired in VANManagedObjectTableViewController
-(void)buildnewTagWithString:(NSString *)string andType:(NSInteger)type;


@end
