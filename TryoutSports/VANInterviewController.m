//
//  VANInterviewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-23.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANInterviewController.h"

@interface VANInterviewController ()

@end

@implementation VANInterviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!self.canSkip) {
        [self.delegate updateForwardButtonToTitle:@"Next" isActive:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareToResignSpotlight {}
-(BOOL)canPrepareToMoveForward {
    return true;
}
-(void)successfullyBuiltEvent {}

@end
