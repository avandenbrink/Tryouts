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

@class Athlete;
@class Event;

@protocol VANDetailTableDelegate <NSObject>

-(Event *)collectEvent;
-(Athlete *)collectAthlete;
-(void)introduceTagsViewWithAnimation:(BOOL)animate;
// ------ Forwarded from AThelteProfileCell Delegate
-(void)VANTableViewCellrequestsActivateCameraForAthlete:(Athlete *)athlete fromCell:(VANAthleteProfileCell *)cell;
-(void)VANTableViewCellrequestsImageInFullScreen:(UIImage *)image fromCell:(VANAthleteProfileCell *)cell;
// ------- Optional based on If the TextField is used or not; Forwarded from VANTextFieldCell Delegate
-(void)addTextFieldContent:(NSString *)string ToContextForTitle:(NSString *)title;
-(void)adjustContentInsetsForEditing:(BOOL)editing;

@end



@interface VANDetailTableDelegate : NSObject <UITableViewDataSource, UITableViewDelegate, VANAthleteProfileDelegate, VANTableViewCellExpansionDelegate, VANTextFieldCellDelegate>

@property (nonatomic, weak) id <VANDetailTableDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Athlete *athlete;
@property (nonatomic, strong) Event *event;
@property (strong, nonatomic) NewTableConfiguration *config;

-(id)initWithTableView:(UITableView *)tableView;
-(void)moveTeamScrollViewWithAnimation:(BOOL)animate;
-(void)reloadTagsCollectionViewCell;

-(void)resetAthletesPointertoAthlete:(Athlete *)athlete;
-(void)readjustTeamCellWithAnimation:(BOOL)animate;
-(void)updateAthleteTagsCell;
@end
