//
//  VANBoolCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMotherCell.h"

@interface VANBoolCell : VANMotherCell

@property (weak,nonatomic) IBOutlet UISwitch *theSwitch;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) id value;

@end
