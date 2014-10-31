//
//  VANCreateSuccessController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-28.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANInterviewController.h"

@interface VANCreateSuccessController : VANInterviewController

@property (weak, nonatomic) IBOutlet UILabel *titleMain;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *getStarted;
@property (weak, nonatomic) IBOutlet UIButton *close;

-(IBAction)close:(id)sender;
-(IBAction)openEvent:(id)sender;

@end
