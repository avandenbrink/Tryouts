//
//  VANDateCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMotherCell.h"
#import "VANDefaultCell.h"
@class VANNewAthleteController;

@interface VANDateCell : VANMotherCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) VANDefaultCell *delegateCell;

@end
