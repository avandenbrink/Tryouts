//
//  VANCreateSuccessController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-28.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANCreateSuccessController.h"

@interface VANCreateSuccessController ()

@end

@implementation VANCreateSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.delegate requestFileBuild];
}

-(void)successfullyBuiltEvent {
    [self.delegate updateBackButtonToTitle:nil isActive:NO];
    self.titleMain.text = [NSString localizedStringWithFormat:@"Success"];
    self.spinner.hidden = YES;
    self.instructions.hidden = NO;
    self.close.hidden = NO;
    self.getStarted.hidden = NO;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.delegate updateForwardButtonToTitle:nil isActive:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)close:(id)sender {
    if ([self.delegate respondsToSelector:@selector(requestCloseContainer)]) {
        [self.delegate requestCloseContainer];
    }
}

-(void)openEvent:(id)sender {
    
}

@end
