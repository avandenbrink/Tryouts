//
//  VANTagsTableViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-06.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTagsTableViewController.h"
#import "AthleteTags.h"
#import "VANTagsTableDelegate.h"

#import "VANFilterButtonCell.h"

static NSString *tagsFileName = @"tags";


static NSString *kTagNameKey = @"value";
static NSString *kTagCountKey = @"count";
static NSString *kTagTypeKey = @"type";

@interface VANTagsTableViewController ()

@property (strong, nonatomic) VANTagsTableDelegate *tableDelegate;

@end

@implementation VANTagsTableViewController

- (void)viewDidLoad {
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = done;
    
    VANTeamColor *teamColor = [[VANTeamColor alloc] init];
    [self.view setTintColor:[teamColor findTeamColor]];
    
    
    //Build Our Table Delegate and Datasource Object
    _tableDelegate = [[VANTagsTableDelegate alloc] initWithTableView:self.tableView];
    _tableDelegate.event = self.event;
    [_tableDelegate filterTagArraysWithAthlete:self.athlete];
}

-(void)done
{
    [_tableDelegate saveMasterTagsArrayToFile];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
