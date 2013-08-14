//
//  VANAddTagCell.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-06.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAddTagCell.h"

@implementation VANAddTagCell

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveNewTag:textField];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.segmentButton.hidden = NO;
    self.addNewButton.enabled = YES;
    self.segmentButton.selectedSegmentIndex = 1;
}

- (IBAction)saveNewTag:(id)sender {
    if ([self.textView.text isEqualToString:@""] || self.textView.text == nil) {
        [self.textView resignFirstResponder];
        self.addNewButton.enabled = NO;
        self.segmentButton.hidden = YES;
        NSLog(@"attemptiong to close Cell without adding Tag");
    } else {
        NSLog(@"Selected Index: %ld", (long)self.segmentButton.selectedSegmentIndex);
        
        [self.controller buildnewTagWithString:self.textView.text andType:self.segmentButton.selectedSegmentIndex];
        self.addNewButton.enabled = NO;
        self.segmentButton.hidden = YES;
        self.textView.text = @"";
        [self.textView resignFirstResponder];
    }
}

@end
