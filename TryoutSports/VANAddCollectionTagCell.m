//
//  VANAddCollectionTagCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-07-25.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAddCollectionTagCell.h"

@implementation VANAddCollectionTagCell

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveNewTag:textField];
    return YES;
}

- (IBAction)saveNewTag:(id)sender {
    if ([self.textField.text isEqualToString:@""] || self.textField.text == nil) {
        [self.controller closeNewTagCell];
        NSLog(@"attemptiong to close Cell without adding Tag");
    } else {
        NSLog(@"Selected Index: %ld", (long)self.segmentControl.selectedSegmentIndex);
        
        [self.controller buildnewTagWithString:self.textField.text andType:self.segmentControl.selectedSegmentIndex];
    }
}
@end
