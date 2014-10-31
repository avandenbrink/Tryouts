//
//  VANAppDelegate.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-07-31.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VANAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)removeAthleteatIndex:(NSInteger)index;

@end