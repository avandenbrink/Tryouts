    //
//  VANInterviewTableDelegate.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-10-24.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import "VANInterviewTableDelegate.h"


@implementation VANInterviewTableDelegate

- (void)collectValuesFromTable {}


-(BOOL)canPrepareToMoveForward {
    for (NSString *value in self.values) {
        if ([value isEqualToString:@""] || !value) {
            return false;
        }
    }
    return true;
}

//This SubClass should only manage the Table View Data and Delegate Methods that are custom to this view

#pragma mark - Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.values count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.values count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
        }
        cell.textLabel.text = @"Add Another";
        return cell;
    } else {
        VANTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        if (!cell) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"VANTextEditSimpleCell" owner:self options:nil];
            cell = (VANTextFieldCell *)[cells objectAtIndex:0];
            [cell initiate];
            cell.indexPath = indexPath;
            cell.textField.placeholder = @"No Value";
            cell.delegate = self;
        }
        cell.textField.text = [self.values objectAtIndex:indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43;
}

#pragma mark - Delegate Methods


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.values count]) {
        NSString *newValue = @"";
        
        if (!self.values) {
            self.values = [NSMutableArray arrayWithObject:newValue];
        } else {
            [self.values addObject:newValue];
        }
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        VANTextFieldCell *cell = (VANTextFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.textField.text = @"";
        [cell.textField becomeFirstResponder];
    }
    if ([self.delegate respondsToSelector:@selector(hasInteractedWithTableView)]) {
        [self.delegate hasInteractedWithTableView];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != [self.values count]) {
        [self.values removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.values count]) {
        return UITableViewCellEditingStyleNone;
    } else return UITableViewCellEditingStyleDelete;
}

#pragma mark - TextFieldCell Delegate Methods

-(void)addTextFieldContent:(NSString *)content forIndexpath:(NSIndexPath *)index {
    if ([self.values count] > index.row) {
        [self.values replaceObjectAtIndex:index.row withObject:content];
    }

}


@end
