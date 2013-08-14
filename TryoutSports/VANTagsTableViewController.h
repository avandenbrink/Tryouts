//
//  VANTagsTableViewController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-06.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANManagedObjectTableViewController.h"

@interface VANTagsTableViewController : VANManagedObjectTableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *selectedTagsArray;
@property (strong, nonatomic) NSMutableArray *tagsArray;

-(void)buildnewTagWithString:(NSString *)string andType:(NSInteger)type;

@end
