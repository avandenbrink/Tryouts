//
//  VANEventNameController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-23.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANEventNameController.h"

@interface VANEventNameController ()

@end

@implementation VANEventNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameText.delegate = self;
    [self.nameText addTarget:self action:@selector(textfieldDidChangeValue) forControlEvents:UIControlEventEditingChanged];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareToResignSpotlight
{
    [self setEditing:NO animated:YES];
    self.data.eventName = self.nameText.text;
}

#pragma mark - uitextField Delegate Methods 

-(void)textfieldDidChangeValue
{
    if (![self.nameText.text isEqualToString:@""] || !self.nameText.text ) {
        [self.delegate updateForwardButtonToTitle:@"Next" isActive:YES];
    } else {
        [self.delegate updateForwardButtonToTitle:@"Next" isActive:NO];
    }
}

-(BOOL)canPrepareToMoveForward {
    if (![self.nameText.text isEqualToString:@""] || !self.nameText.text) {
        return true;
    } else {
        return false;
    }
}



@end
