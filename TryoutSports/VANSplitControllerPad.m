//
//  VANSplitControllerPad.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-08.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANSplitControllerPad.h"
#import "VANAthleteDetailControllerPad.h"


@interface VANSplitControllerPad ()

@end

@implementation VANSplitControllerPad

-(void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
 //   UINavigationController *nav = [self.viewControllers objectAtIndex:1];
 //   VANAthleteDetailControllerPad *controller = (VANAthleteDetailControllerPad *)[nav topViewController];
//    [controller.tableView reloadData];
    return NO;
}

@end
