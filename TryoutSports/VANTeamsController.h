//
//  VANTeamsController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-23.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANManagedObjectViewController.h"

@interface VANTeamsController : VANManagedObjectViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@end
