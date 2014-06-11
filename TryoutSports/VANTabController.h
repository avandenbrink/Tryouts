//
//  VANTabController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-09-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface VANTabController : UITabBarController <UITabBarControllerDelegate>

@property (strong, nonatomic) Event *event;

@end
