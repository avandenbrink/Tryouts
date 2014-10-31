//
//  VANInterviewTableDelegate.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-24.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VANTextFieldCell.h"
#import "VANNewEventData.h"

@protocol VANInterviewTableDelegatesDelegate <NSObject>

@optional
-(void)hasInteractedWithTableView;

@end


@interface VANInterviewTableDelegate : NSObject <UITableViewDataSource, UITableViewDelegate, VANTextFieldCellDelegate>

@property (weak, nonatomic) id <VANInterviewTableDelegatesDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *values;
@property (strong, nonatomic) VANNewEventData *data;

-(void)collectValuesFromTable;
-(BOOL)canPrepareToMoveForward;

@end
