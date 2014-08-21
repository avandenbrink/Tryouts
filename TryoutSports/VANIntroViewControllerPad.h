//
//  VANIntroViewControllerPAD.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANIntroViewController.h"
@class VANMainMenuViewController;

@interface VANIntroViewControllerPad : VANIntroViewController <UIPopoverControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) VANMainMenuViewController *delegate;

@end
  