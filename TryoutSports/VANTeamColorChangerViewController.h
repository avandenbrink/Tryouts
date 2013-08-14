//
//  VANTeamColorChangerViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-04-24.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VANTeamColorChangerViewController;

/*
@protocol VANTeamColorChangerViewControllerDelegate
- (void)teamColorChangerViewControllerDidFinish:(VANTeamColorChangerViewController *)controller;
@end*/

@interface VANTeamColorChangerViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

//@property (weak, nonatomic) id <VANTeamColorChangerViewControllerDelegate> delegate;

- (IBAction)confirmColorChange:(id)sender;

@end
