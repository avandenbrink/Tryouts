//
//  VANSimpleTextEditCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-16.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANMotherCell.h"
#import "VANTeamColor.h"

@implementation VANMotherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)saveManagedObjectContext:(NSManagedObject *)managedObject {
    NSError *error = nil;
    if (![managedObject.managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting.", @"Eror was: %@, quitting."), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts") otherButtonTitles:nil];
        [alert show];
    }
}

-(void)configureWith:(NSManagedObject *)object {
}

-(IBAction)keyboardResign:(id)sender {
    [sender resignFirstResponder];
}

@end
