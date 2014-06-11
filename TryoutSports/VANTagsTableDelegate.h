//
//  VANTagsTableDelegate.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/9/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VANAddTagCell.h"

@class Athlete;
@class Event;

@protocol VANTagsTableViewDelegate <NSObject>

@optional
-(void)athleteTagProfileHasBeenUpdated;
-(void)VANAddTagCellBecameFirstResponder;
-(void)VANAddTagCellIsReleasingFirstResponder;


@end


@interface VANTagsTableDelegate : NSObject <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, VANAddTagDelegate>

@property (nonatomic, weak) id <VANTagsTableViewDelegate> delegate;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Athlete *athlete;
@property (nonatomic, strong) Event *event;

-(id)initWithTableView:(UITableView *)tableView;

-(void)filterTagArraysWithAthlete:(Athlete *)athlete;
-(void)resetTagsFiltertoAll;
-(void)saveMasterTagsArrayToFile;


@end
