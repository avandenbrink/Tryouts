//
//  VANAthleteSignInControllerViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/9/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteSignInController.h"


static NSInteger kSpacingMargin = 10;
static NSInteger kMiniSpacing = 2;

static NSInteger kTopBarHeight = 50;
static NSInteger kImageX = 200;
static NSInteger kImageXSmall = 46;
static NSInteger kLabelHeights = 30;
static NSInteger kLabelHeightLarge = 65;

static NSInteger kBarWidth = 500;
static NSInteger kButtonWidth = 50;

static NSInteger kTopHidden = -100;

static float xTitle = 0.09f;
static float xSignIn = 0.23f;
static float xBox = 0.28f; // 0.35f;
static float xImage = 0.575f;
static float xText = 0.36f; //0.55f;

static NSInteger kSuccessViewx = 500;

static NSString *kSuccessLabelText = @"Sign-In Complete";

static NSString *kTryoutSportsImage = @"icon60.png";



@interface VANAthleteSignInController ()

@property (nonatomic, assign) BOOL isInputing;

@property (strong, nonatomic) NSMutableArray *athleteArray;
@property (nonatomic, assign) NSInteger stringLength;

@property (strong, nonatomic) UIView *successView;

@end


@implementation VANAthleteSignInController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _isInputing = NO;
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _signInLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    _logoImage.translatesAutoresizingMaskIntoConstraints = NO;
    _welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.textField addTarget:self action:@selector(textFieldContentUpdate) forControlEvents:UIControlEventEditingChanged];
    _welcomeLabel.text = self.event.name;

    //Setup Image
    UIImage *image = [UIImage imageWithData:self.event.logo];
    if (!image) {
        image = [UIImage imageNamed:kTryoutSportsImage];
    }
    _logoImage.image = image;
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(_logoImage.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:_logoImage.bounds
                                cornerRadius:kImageX] addClip];
    // Draw your image
    [image drawInRect:_logoImage.bounds];
    
    // Get the image, here setting the UIImageView image
    _logoImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    //Temporary
}

-(void)viewDidLayoutSubviews
{
    [self readjustLayoutRules];
}

-(void)readjustLayoutRules
{
    if (!_isInputing) {
        //TableView is Hidden below screen's View
        CGRect table = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-kTopBarHeight);
        [self.tableView setFrame:table];
        
        //Image
        CGRect image = CGRectMake((self.view.frame.size.width-kImageX)/2, self.view.frame.size.height*xImage, kImageX, kImageX);
        [self.logoImage setFrame:image];
        
        //Event Name Text
        CGRect welcome = CGRectMake(0, self.view.frame.size.height*xTitle, self.view.frame.size.width, kLabelHeightLarge);
        [self.welcomeLabel setFrame:welcome];
        
        //Sign In Text
        CGRect signIn = CGRectMake(0, self.view.frame.size.height*xSignIn, self.view.frame.size.width, kLabelHeights);
        [self.signInLabel setFrame:signIn];
        
        //Text Field
        CGRect textField = CGRectMake((self.view.frame.size.width-kBarWidth)/2, self.view.frame.size.height*xBox, kBarWidth, kLabelHeights);
        [self.textField setFrame:textField];
        
        //Search Button
        CGRect button = CGRectMake(self.view.frame.size.width, kSpacingMargin, kButtonWidth, kLabelHeights);
        [self.searchButton setFrame:button];

        //Bottom Instructions text
        CGRect instruction = CGRectMake(0, self.view.frame.size.height*xText, self.view.frame.size.width, kLabelHeights);
        [self.instructionsLabel setFrame:instruction];
        
    } else {
        
        //TableView is Hidden below screen's View
        CGRect table = CGRectMake(0, kTopBarHeight, self.view.frame.size.width, self.view.frame.size.height-kTopBarHeight);
        [self.tableView setFrame:table];
        
        //Image
        CGRect image = CGRectMake(kMiniSpacing, kMiniSpacing, kImageXSmall, kImageXSmall);
        [self.logoImage setFrame:image];
        
        //Welcome Text
        CGRect welcome = CGRectMake(0, kTopHidden, self.view.frame.size.width, kLabelHeights);
        [self.welcomeLabel setFrame:welcome];
        
        CGRect signIn = CGRectMake(0, kTopHidden, self.view.frame.size.width, kLabelHeights);
        [self.signInLabel setFrame:signIn];
        
        CGRect instruction = CGRectMake(0, kTopHidden, self.view.frame.size.width, kLabelHeights);
        [self.instructionsLabel setFrame:instruction];
        
        CGRect textField = CGRectMake((kMiniSpacing*2)+kImageXSmall+kSpacingMargin, kSpacingMargin, self.view.frame.size.width-((kMiniSpacing*2)+kImageXSmall+(kSpacingMargin*3)+kButtonWidth), kLabelHeights);
        [self.textField setFrame:textField];
        
        CGRect button = CGRectMake(self.view.frame.size.width-(kButtonWidth+kSpacingMargin), kSpacingMargin, kButtonWidth, kLabelHeights);
        [self.searchButton setFrame:button];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAthleteSpecifics"]) {
        VANCheckInViewController *controller = segue.destinationViewController;
        controller.athlete = sender;
        controller.event = self.event;
        controller.delegate = self;
    }
}


#pragma mark - Table View Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.athleteArray count] == 0) {
        return 1;
    } else {
        return [self.athleteArray count]+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.athleteArray count] == 0 || indexPath.row == [self.athleteArray count]) {
        return [self tableView:tableView emptyTableCellForIndexPath:indexPath];
    }

    static NSString *cellID = @"name";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    Athlete *athlete = [self.athleteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = athlete.name;
    cell.detailTextLabel.text = @"";
    
    if ([athlete.checkedIn boolValue]) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = @"Checked In";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView emptyTableCellForIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"name";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.textLabel.text = @"Can't Find your Name?";
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = @"Sign Up Now";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table View Data Source Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.athleteArray count] == 0 || indexPath.row == [self.athleteArray count]) {
        Athlete *newAthelte = (Athlete *)[VANGlobalMethods addNewRelationship:@"athletes" toManagedObject:self.event andSave:NO];
        newAthelte.checkedIn = [NSNumber numberWithBool:NO];
        newAthelte.isSelfCheckedIn = [NSNumber numberWithBool:YES];
        newAthelte.number = [NSNumber numberWithInteger:[self.event.athletes count]];
        
        [self performSegueWithIdentifier:@"toAthleteSpecifics" sender:newAthelte];
    } else {
        Athlete *athlete = [self.athleteArray objectAtIndex:indexPath.row];
        if (![athlete.checkedIn boolValue]) {
            [self performSegueWithIdentifier:@"toAthleteSpecifics" sender:athlete];
        }
    }
    [self.textField resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Athlete Name";
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 //   [self readjustLayoutRules];
}

#pragma mark - TextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {

}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}

-(void)textFieldContentUpdate
{
    if (!_isInputing) {
        if ([_textField.text length] > 0) {
            _isInputing = YES;
            [UIView animateWithDuration:0.5 animations:^{
                [self readjustLayoutRules];
                self.navigationItem.title = _welcomeLabel.text;
                [self.view layoutSubviews];
            }];
            
            [self searchAthleteListsForTextFieldString];
        }
    } else {
        if ([_textField.text length] == 0) {
            _isInputing = NO;
            [UIView animateWithDuration:0.5 animations:^{
                [self readjustLayoutRules];
                self.navigationItem.title = @"";
                [self.view layoutSubviews];
            }];
        }
        [self searchAthleteListsForTextFieldString];
    }
}

-(void)searchAthleteListsForTextFieldString
{
    if (self.stringLength) {
        if ([_textField.text length] < self.stringLength) {
            NSArray *array = [self.event.athletes allObjects];
            self.athleteArray = [NSMutableArray arrayWithArray:array];
        }
    } else {
        NSArray *array = [self.event.athletes allObjects];
        self.athleteArray = [NSMutableArray arrayWithArray:array];
    }
    
            
    self.stringLength = [_textField.text length];
        
    NSMutableArray *temporaryRelease = [NSMutableArray array];
    for (int i = 0; i < [self.athleteArray count]; i++) {
        Athlete *athlete = [self.athleteArray objectAtIndex:i];
        if ([athlete.name rangeOfString:_textField.text options:NSCaseInsensitiveSearch].location == NSNotFound) {
            [temporaryRelease addObject:athlete];
        }
    }
    if ([temporaryRelease count] > 0) {
        [self.athleteArray removeObjectsInArray:temporaryRelease];
    }

    [self.tableView reloadData];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}


- (IBAction)cancelAthleteLookup {
    _isInputing = NO;
    _textField.text = @"";
    self.navigationItem.title = @"";
    [UIView animateWithDuration:0.5 animations:^{
        [self readjustLayoutRules];
    }];
    [_textField resignFirstResponder];
}

#pragma mark - Check In Delegate

-(void)popViewControllerandReset {
    [self.navigationController popViewControllerAnimated:YES];
    [self cancelAthleteLookup];
    [self.textField resignFirstResponder];
    
    if (!self.successView) {
        self.successView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-kSuccessViewx)/2, (self.view.frame.size.height-kSuccessViewx)/2, kSuccessViewx, kSuccessViewx)];
        self.successView.layer.cornerRadius = 30;
        [self.view addSubview:self.successView];
        self.successView.translatesAutoresizingMaskIntoConstraints = NO;
        self.successView.backgroundColor = [UIColor darkGrayColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.successView.frame];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = kSuccessLabelText;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor greenColor];
        [self.successView addSubview:label];
        
    }
    self.successView.layer.opacity = 0;
    self.successView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.successView.layer.opacity = 0.95;
    } completion:^(BOOL success){
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.successView.layer.opacity = 0;
        } completion:^(BOOL success){
            self.successView.hidden = YES;
        }];
    }];
    
}



@end
