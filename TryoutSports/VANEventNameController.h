//
//  VANEventNameController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-23.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VANInterviewController.h"

@interface VANEventNameController : VANInterviewController <UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIButton *next;

@property (strong, nonatomic) NSString *eventName;

@end
