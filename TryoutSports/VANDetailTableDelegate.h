//
//  VANDetailTableDelegate.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/2/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VANAthleteProfileCell.h"
#import "NewTableConfiguration.h"

#import "VANScrollViewTeamSelectionCell.h"

@class Athlete;
@class Event;

@protocol VANDetailTableDelegate <NSObject>

-(Event *)collectEvent;

-(void)introduceTagsViewWithAnimation:(BOOL)animate;

// ------ Forwarded from AThelteProfileCell Delegate
-(void)VANTableViewCellrequestsActivateCameraForAthlete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell;
-(void)VANTableViewCellrequestsImageforAthete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell;
// ------- Optional based on If the TextField is used or not; Forwarded from VANTextFieldCell Delegate

@optional
-(Athlete *)collectAthlete;
-(void)addTextFieldContent:(NSString *)string ToContextForTitle:(NSString *)title;
-(void)adjustContentInsetsForEditing:(BOOL)editing;
-(void)updateAthleteListTable;

@end



@interface VANDetailTableDelegate : NSObject <UITableViewDataSource, UITableViewDelegate, VANAthleteProfileDelegate, VANTableViewCellExpansionDelegate, VANTextFieldCellDelegate, VANScrollViewDelegate>

@property (nonatomic, weak) id <VANDetailTableDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Athlete *athlete;
@property (nonatomic, strong) Event *event;
@property (strong, nonatomic) NewTableConfiguration *config;

-(id)initWithTableView:(UITableView *)tableView;
-(void)updateAthlete:(Athlete *)athlete;
-(void)moveTeamScrollViewWithAnimation:(BOOL)animate;
-(void)readjustTeamCellWithAnimation:(BOOL)animate;
-(void)prepareToLeaveAthleteProfile;
-(void)updateTagsCellWithAthlete:(Athlete *)athlete andReloadCell:(BOOL)reload;

@end
