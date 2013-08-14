//
//  VANTextFieldCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANTextFieldCell.h"

@implementation VANTextFieldCell

-(void)initiate {
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resignAndSave {
    
    [self.textField resignFirstResponder];
    self.value = self.textField.text;
    //NSLog(@"%@", self.textField.text);
    [self textFieldDidEndEditing:self.textField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.value = self.textField.text;
    NSLog(@"Setting Value: %@ to %@", self.textField.text, self.value);
    if (self.test) {
        self.test.value = self.textField.text;
    } else {
        [self.controller addTextFieldContent:self.textField.text ToContextForTitle:self.label.text];
    }
}


@end
