//
//  VANNewEventInterview.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-21.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VANInterviewController.h"
#import "VANNewEventData.h"
#import "Event.h"

@protocol VANNewEventInterviewDelegate

-(void)closeInterview;
-(UIStoryboard *)getStoryboard;
-(void)buildNewEventWithData:(VANNewEventData *)data;

@end


@interface VANNewEventInterview : NSObject <UIPageViewControllerDelegate, VANInterviewControllerDelegate>

@property (weak, nonatomic) id <VANNewEventInterviewDelegate> delegate;
@property (strong, nonatomic) UIPageViewController *pager;
@property (strong, nonatomic) VANNewEventData *data;

-(void)initiateInterview;
-(void)addValuestoEventDocument:(Event *)doc;

@end
