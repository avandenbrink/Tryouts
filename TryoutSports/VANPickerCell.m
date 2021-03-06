//
//  VANAgePickerCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANPickerCell.h"
#import "Positions.h"

@implementation VANPickerCell

-(void)configureWith:(NSManagedObject *)object {

}

#pragma mark - PickerViewDataSource Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.values) {
        return [self.values count];
    } else {
        NSLog(@"Error Loading Values becuase Values is Nil: VANPickerCell.m");
        return 0;
    }
}

#pragma mark - PickerViewDelegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([[self.values objectAtIndex:row] isKindOfClass:[Positions class]]) { 
        Positions *position = [self.values objectAtIndex:row];
        return position.position;
    } else if ([[self.values objectAtIndex:row] isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",[self.values objectAtIndex:row]];
    } else {
        return [self.values objectAtIndex:row];
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Delegate Cell: %@", self.delegateCell);
    if ([[self.values objectAtIndex:row] isKindOfClass:[Positions class]]) {
        Positions *position = [self.values objectAtIndex:row];
        self.delegateCell.detailLabel.text = position.position;
        self.athlete.position = position.position;
    } else {
        self.delegateCell.detailLabel.text = [NSString stringWithFormat:@"%@",[self.values objectAtIndex:row]];
        [self.event setValue:[self.values objectAtIndex:row] forKey:self.purpose];
    }
}

@end
