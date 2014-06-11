//
//  VANCompareControllerViewController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/7/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANManagedObjectViewController.h"

@interface VANCompareController : VANManagedObjectViewController <UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewA;
@property (strong, nonatomic) IBOutlet UIView *viewB;

@end
