//
//  VANAthleteListControllerPad.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-02.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
//  While this Page has 3 Table Views associated with it.  Only tableView uses this class as a Delegate and Data Source.
//  athleteDetailTable and tagsTableView are both handled externally.

#import "VANAthleteListViewController.h"
#import "VANAthleteDetailControllerPad.h"

#import "VANDetailTableDelegate.h"
#import "VANTagsTableDelegate.h"

#import "VANAthleteProfileCell.h"

#import "VANPictureTaker.h"
#import "VANSoloImageViewer.h"
#import "VANAthleteDetailTable.h"

@class VANTagsTable;

@interface VANAthleteListControllerPad : VANAthleteListViewController <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, VANAthleteProfileDelegate, VANPictureTakerDelegate, VANSoloImageViewerDelegate, VANDetailTableDelegate, VANTagsTableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *starterLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeTabsButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (strong, nonatomic) VANAthleteDetailTable *tableViewDetail;
@property (strong, nonatomic) UITableView *tableViewTags;
@property (strong, nonatomic) VANDetailTableDelegate *tableViewDetailDelegate;
@property (strong, nonatomic) VANTagsTableDelegate *tableViewTagsDelegate;

-(void)toggleDetailVisible;
-(void)introduceTagsViewWithAnimation:(BOOL)animate;
-(IBAction)closeTagsTable;
-(void)toggleTablesVisible;

@end
