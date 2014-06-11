//
//  VANDateCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANDateCell.h"
#import "VANAthleteEditController.h"

@interface VANDateCell ()

- (IBAction)datePickerChanged:(id)sender;

@end

@implementation VANDateCell

+ (void)initialize {
    __dateFormatter = [[NSDateFormatter alloc] init];
    [__dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

#pragma mark - (Private) Instance Methods

-(IBAction)datePickerChanged:(id)sender {
    
    NSDate *date = [self.datePicker date];
    self.delegateCell.detailTextLabel.text = [__dateFormatter stringFromDate:date];
    if ([self.delegateCell.textLabel.text isEqualToString:@"Birthday"]) {
        self.athlete.birthday = date;
    } else if ([self.delegateCell.textLabel.text isEqualToString:@"Event Date:"]) {
        self.event.startDate = date;
    } else {
        NSLog(@"Warning: Date Picker Changed is not Working Correctly: VANDateCell.m");
    }

}

@end
