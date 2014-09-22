//
//  VANTextFieldCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTextFieldCell.h"

@implementation VANTextFieldCell

-(void)initiate
{
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)resignAndSave
{
    [self.textField resignFirstResponder];
    self.value = self.textField.text;
    //NSLog(@"%@", self.textField.text);
    [self textFieldDidEndEditing:self.textField];
}

#pragma mark - UI Text Field Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(adjustContentInsetsForEditing:)]) {
        [self.delegate adjustContentInsetsForEditing:YES];
    }
    if ([self.delegate respondsToSelector:@selector(textFieldDidClaimFirstResponder:)]) {
        [self.delegate textFieldDidClaimFirstResponder:self];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.value = self.textField.text;
    if (self.test) {
        self.test.value = self.textField.text;
    } else {
        if ([self.delegate respondsToSelector:@selector(addTextFieldContent:forIndexpath:)]) {
            [self.delegate addTextFieldContent:self.textField.text forIndexpath:self.indexPath];
        }
    }
    [self.delegate adjustContentInsetsForEditing:NO];
}

@end