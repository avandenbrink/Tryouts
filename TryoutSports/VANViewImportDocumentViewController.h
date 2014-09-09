//
//  VANViewImportDocumentViewController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-22.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//


#import "VANManagedObjectViewController.h"

@interface VANViewImportDocumentViewController : VANManagedObjectViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *valueArray;
@property (strong, nonatomic) NSMutableArray *labelArray;


@end
