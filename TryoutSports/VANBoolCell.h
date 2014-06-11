//
//  VANBoolCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMotherCell.h"

@protocol VANBoolCellDelegate <NSObject>

-(void)setBoolValue:(BOOL)value forPurpose:(NSString *)purpose;

@end

@interface VANBoolCell : VANMotherCell

@property (nonatomic, weak) id <VANBoolCellDelegate> delegate;
@property (weak,nonatomic) IBOutlet UISwitch *theSwitch;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *purpose;
@property (strong, nonatomic) id value;

@end
