//
//  VANSettingTabsController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-15.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface VANSettingTabsController : UITabBarController <UITabBarControllerDelegate>

@property (strong, nonatomic) Event *event;

@end
