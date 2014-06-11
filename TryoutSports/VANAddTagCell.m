//
//  VANAddTagCell.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-06.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAddTagCell.h"

@implementation VANAddTagCell

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveNewTag:textField];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _segmentButton.hidden = NO;
    _addNewButton.enabled = YES;
    _segmentButton.selectedSegmentIndex = 1;
    if ([_delegate respondsToSelector:@selector(VANAddTextViewDidBecomeFirstResponder)]) {
        [_delegate VANAddTextViewDidBecomeFirstResponder];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _addNewButton.enabled = NO;
    _segmentButton.hidden = YES;
    _segmentButton.selectedSegmentIndex = 1;
    self.textView.text = @"";
    if ([_delegate respondsToSelector:@selector(VANAddTextViewDidResignFirstResponder)]) {
        [_delegate VANAddTextViewDidResignFirstResponder];
    }
}

- (IBAction)saveNewTag:(id)sender
{
    if (![_textView.text isEqualToString:@""]) {
        if ([_delegate respondsToSelector:@selector(buildnewTagWithString:andType:)]) {
            [_delegate buildnewTagWithString:self.textView.text andType:self.segmentButton.selectedSegmentIndex];
        }
    } else {
        [self.textView resignFirstResponder];
    }
}

-(void)safeToCloseAddTagCell {
    [self.textView resignFirstResponder];
}

@end
