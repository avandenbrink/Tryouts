//
//  VANAgePickerCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMotherCell.h"
#import "VANDefaultCell.h"

@interface VANPickerCell : VANMotherCell <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *values;
@property (weak, nonatomic)IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) VANDefaultCell *delegateCell;
@property (strong, nonatomic) NSString *purpose;


@end
