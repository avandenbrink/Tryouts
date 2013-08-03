//
//  VANEventSettingsViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-14.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANNewEventViewController.h"

@interface VANEventSettingsViewController : VANManagedObjectViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@end
