//
//  VANNewSkillsAndTestsController.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-17.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANNewSkillsAndTestsController.h"
#import "VANMainMenuViewController.h"
#import "VANEditSkillController.h"


@interface VANNewSkillsAndTestsController ()

@property (strong, nonatomic) NSSet *sets;
@end

@implementation VANNewSkillsAndTestsController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSMutableSet *attributeSet = [self.event mutableSetValueForKey:@"positions"];
        return [attributeSet count] + 1;
    } else if (section == 1) {
        NSMutableSet *attributeSet = [self.event mutableSetValueForKey:@"skills"];
        return [attributeSet count] + 1;
    } else {
        NSMutableSet *attributeSet = [self.event mutableSetValueForKey:@"tests"];
        return [attributeSet count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([indexPath section] == 0) {
        static NSString *CellIdentifier = @"Add";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSMutableSet *relationshipSet = [self.event mutableSetValueForKey:@"positions"];
        NSArray *relationshipArray = [relationshipSet allObjects];
        if (indexPath.row < [relationshipArray count]) {
            Positions *position = [relationshipArray objectAtIndex:[indexPath row]];
            cell.textLabel.text = position.position;
            cell.textLabel.textColor = [UIColor darkGrayColor];
        } else {
            cell.textLabel.text = @"Add new Position...";
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        return cell;
    } else if ([indexPath section] == 1) {
        static NSString *CellIdentifier = @"Add";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSMutableSet *relationshipSet = [self.event mutableSetValueForKey:@"skills"];
        NSArray *relationshipArray = [relationshipSet allObjects];
        if (indexPath.row < [relationshipArray count]) {
            Skills *skill  = [relationshipArray objectAtIndex:[indexPath row]];
            cell.textLabel.text = skill.descriptor;
            cell.textLabel.textColor = [UIColor darkGrayColor];
        } else {
            cell.textLabel.text = @"Add new Skill...";
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        return cell;
            
    } else {
        static NSString *CellIdentifier = @"Add";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSMutableSet *relationshipSet = [self.event mutableSetValueForKey:@"tests"];
        NSArray *relationshipArray = [relationshipSet allObjects];
        
        if (indexPath.row < [relationshipArray count]) {
            Tests *test = [relationshipArray objectAtIndex:[indexPath row]];
            cell.textLabel.text = test.descriptor;
            cell.textLabel.textColor = [UIColor darkGrayColor];
        } else {
            cell.textLabel.text = @"Add new Test...";
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
         return cell;
    }
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([indexPath section] == 0) {
            [self removeRelationshipObjectInIndexPath:indexPath forKey:@"positions"];
        } else if ([indexPath section] == 1) {
            [self removeRelationshipObjectInIndexPath:indexPath forKey:@"skills"];
        } else {
            [self removeRelationshipObjectInIndexPath:indexPath forKey:@"tests"];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if ([indexPath section] == 0) {
            NSManagedObject *newPosition = [self addNewRelationship:@"positions"toManagedObject:self.event andSave:NO];
            [self performSegueWithIdentifier:@"editPosition" sender:newPosition];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else if ([indexPath section] == 1) {
            NSManagedObject *newSkill = [self addNewRelationship:@"skills" toManagedObject:self.event andSave:NO];
            [self performSegueWithIdentifier:@"editSkill" sender:newSkill];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        } else {
            NSManagedObject *newSkill = [self addNewRelationship:@"tests"toManagedObject:self.event andSave:NO];
            [self performSegueWithIdentifier:@"editTest" sender:newSkill];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        
    }
}

#pragma mark - Table view delegate

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle editStyle = UITableViewCellEditingStyleNone;
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:[indexPath section]];
    if ([indexPath row] == rowCount-1) {
        editStyle = UITableViewCellEditingStyleInsert;
    } else {
        editStyle = UITableViewCellEditingStyleDelete;
    }
    return editStyle;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:[indexPath section]];
    if ([indexPath row] == rowCount-1) {
        return 40;
    }
    return 45;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Team Positions";
    } else if (section == 1) {
        return @"Skills";
    } else {
        return @"Tests";
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"Add the positions for your team that your athletes will be trying out for.";
    } else if (section == 1) {
        return @"Add skills to rate athletes based on a 5 point scale.";
    } else {
        return @"Add tests to record an athletes skill based on a time, distance, or other numeric system.";
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:[indexPath section]];
    if ([indexPath section] == 0) {
        NSArray *array = [self.event.positions allObjects];
        if ([indexPath row] == rowCount-1) {
            NSManagedObject *newPosition = [self addNewRelationship:@"positions"toManagedObject:self.event andSave:NO];
            [self performSegueWithIdentifier:@"editPosition" sender:newPosition];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            NSManagedObject *position = [array objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"editPosition" sender:@[position,@YES]];
        }
    } else if ([indexPath section] == 1) {
        NSArray *array = [self.event.skills allObjects];
        if ([indexPath row] == rowCount-1) {
            NSManagedObject *newSkill = [self addNewRelationship:@"skills"toManagedObject:self.event andSave:NO];
            [self performSegueWithIdentifier:@"editSkill" sender:newSkill];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            NSManagedObject *skill = [array objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"editSkill" sender:@[skill,@YES]];
        }
    } else {
        NSArray *array = [self.event.tests allObjects];

        if ([indexPath row] == rowCount-1) {
            NSManagedObject *newSkill = [self addNewRelationship:@"tests"toManagedObject:self.event andSave:NO];
            [self performSegueWithIdentifier:@"editTest" sender:newSkill];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            NSManagedObject *test = [array objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"editTest" sender:@[test,@YES]];
        }
    }
}


#pragma mark - Custom Action Methods

- (IBAction)saveSkills:(id)sender {
    [self saveManagedObjectContext:self.event];
    [self performSegueWithIdentifier:@"saveToMain" sender:self.event];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"saveToMain"]) {
        VANMainMenuViewController *viewController = segue.destinationViewController;
        viewController.event = sender;
    } else if ([segue.identifier isEqualToString:@"editSkill"]) {
        VANEditSkillController *viewController = segue.destinationViewController;
        if ([sender isKindOfClass:[NSArray class]]) {
            viewController.skill = [sender objectAtIndex:0];
            viewController.editing = (BOOL)[sender objectAtIndex:1];
        } else {
            viewController.skill = sender;
            viewController.editing = NO;
        }
        viewController.event = self.event;
    } else if ([segue.identifier isEqualToString:@"editTest"]) {
        VANEditSkillController *viewController = segue.destinationViewController;
        if ([sender isKindOfClass:[NSArray class]]) {
            viewController.test = [sender objectAtIndex:0];
            viewController.editing = (BOOL)[sender objectAtIndex:1];
        } else {
            viewController.test = sender;
            viewController.editing = NO;
        }
        viewController.event = self.event;

    } else if ([segue.identifier isEqualToString:@"editPosition"]) {
        VANEditSkillController *viewController = segue.destinationViewController;
        if ([sender isKindOfClass:[NSArray class]]) {
            viewController.position = [sender objectAtIndex:0];
            viewController.editing = (BOOL)[sender objectAtIndex:1];
        } else {
            viewController.position = sender;
            viewController.editing = NO;
        }
        viewController.event = self.event;

    }
}

@end
