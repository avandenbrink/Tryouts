//
//  VANBoolCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-09.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANBoolCell.h"
#import "VANIntroViewController.h"
#import "VANTeamColor.h"

#define  kLabelTextColor [UIColor colorWithRed:0.321569f green:0.4f blue:0.568627f alpha:1.0f]

@interface VANBoolCell ()

-(IBAction)switchflip:(id)sender;

@end


@implementation VANBoolCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.theSwitch.backgroundColor = [UIColor clearColor];
        self.theSwitch.enabled = YES;
        self.theSwitch.on = YES;
        VANTeamColor *teamColor = [[VANTeamColor alloc] init];
        self.theSwitch.onTintColor = [teamColor findTeamColor];
        //self.theSwitch.tintColor = [UIColor darkGrayColor];
        [self.theSwitch addTarget:self action:@selector(switchflip:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.theSwitch];
    }
    return self;
}

-(void)configureWith:(NSManagedObject *)object {
    self.label.text = @"Suck It";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)switchflip:(id)sender {
    if (self.theSwitch.on == YES) {
        [self resignFirstResponder];
    } else {
    }
}

/*
-(id)value {
    return self.theSwitch.text;
}

-(void)setValue:(id)value {
    self.textField.text = value;
}*/

#pragma mark - Instance Methods

-(void)validate {
   /* id val = self.value;
    NSError *error;
    if ([self.myNewEvent validateValue:&val forKey:self.key error:&error]) {
        NSString *message = nil;
        if ([[error domain] isEqualToString:@"NSCocoaErrorDomain"]) {
            NSDictionary *userInfo = [error userInfo];
            message = [NSString stringWithFormat:NSLocalizedString(@"Validation error on: %@/rFailureReason: %@", @"Validation error on: %@/rFailureReason: %@"), [userInfo valueForKey:@"NSValidationErrorKey"], [error localizedFailureReason]];
        } else {
            message = [error localizedDescription];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error", @"Validation Error") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Fix", @"Fix"), nil];
        [alert show];
    }*/
}


#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self setValue:[self.event valueForKey:self.key]];
    } else {
        [self.theSwitch becomeFirstResponder];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self validate];
}




@end
