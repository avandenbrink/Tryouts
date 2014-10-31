//
//  VANInterviewController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-23.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANNewEventData.h"

@protocol VANInterviewControllerDelegate <NSObject>

-(void)updateForwardButtonToTitle:(NSString *)title isActive:(BOOL)active;
-(void)updateBackButtonToTitle:(NSString *)title isActive:(BOOL)active;
-(void)requestCloseContainer;
-(void)requestFileBuild;

@end

@interface VANInterviewController : UIViewController

@property (weak, nonatomic) id <VANInterviewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *instructions;
@property (weak, nonatomic) VANNewEventData *data;

@property (nonatomic) BOOL canSkip;
@property (nonatomic) BOOL hasBeenTouched;
@property (nonatomic) BOOL isLastView;


-(void)prepareToResignSpotlight;
-(BOOL)canPrepareToMoveForward;
-(void)successfullyBuiltEvent;

@end
