//
//  VANSimpleTableViewController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-23.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANInterviewController.h"
#import "VANInterviewTableDelegate.h"

@interface VANSimpleTableViewController : VANInterviewController <UITableViewDataSource, UITableViewDelegate, VANInterviewTableDelegatesDelegate>

@property (strong, nonatomic) NSString *tableTitle;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDictionary *elements;
@property (strong, nonatomic) NSArray *values;
@property (nonatomic) BOOL showAddMore;
@property (strong, nonatomic) VANInterviewTableDelegate *tableDelegate;

@property (weak, nonatomic) IBOutlet UITableView *table;

@end
