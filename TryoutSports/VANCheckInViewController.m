//
//  VANCheckInViewController.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/9/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANCheckInViewController.h"



static NSInteger kLabelHeightLarge = 50;
static NSInteger kButtonWidth = 100;

static NSInteger kImageStep1 = 500;
static NSInteger kImageStep2 = 200;
static NSInteger kImageOffsetH = 35;
static NSInteger kImageOffsetV = 100;

static NSInteger kClipboardWidth = 570;
static NSInteger kClipboardHeight = 640;
static NSInteger kClipboardMinTop = 60;

static NSInteger kKeyboardHeightLandscape = 392;
static NSInteger kKeyboardHeightPortrait = 304;

static NSInteger kStep2IDTop = 270;
static NSInteger kStep2IDWidth = 178;
static NSInteger kStep2TopTextLeft = 250;
static NSInteger kStep2NameTop = 185;
static NSInteger kStep2NameWidth = 280;
static NSInteger kStep2EmailTop = 310;
static NSInteger kStep2PhoneTop = 350;
static NSInteger kStep2BirthdayTop = 390;
static NSInteger kStep2LabelWidth = 360;
static NSInteger kStep2BottomTextLeft = 170;
static NSInteger kStep2DatePickerLeft = 20;
static NSInteger kStep2DatePickerWidth = 530;

static NSInteger kTextFieldHeight = 30;

static NSInteger kStep3IDTop = 120;
static NSInteger kStep3IDLeft = 210;
static NSInteger kStep3TextFieldLeft = 250;
static NSInteger kStep3TextFieldLeftB = 260;
static NSInteger kStep3NameTop = 160;
static NSInteger kStep3EmailTop = 220;
static NSInteger kStep3PhoneTop = 245;
static NSInteger kStep3BirthdayTop = 195;
static NSInteger kStep3LabelWidth = 280;
static NSInteger kNumberBackGroundx = 50;
static NSInteger kNumberBGTop = 110;
static NSInteger kNumberBGLeft = 200;

static NSInteger kTableViewHeight = 300;

static NSString *rAthleteImages = @"images";


static NSString *step1 = @"Step 1: Take a profile picture";
static NSString *step2 = @"Step 2: Fill out your contact information";
static NSString *step3 = @"Step 3: Confirm information and select your preferred position";

static NSString *defaultImagePic = @"headshot.png";

@interface VANCheckInViewController ()

@property (nonatomic, assign) NSInteger steps;

@property (strong, nonatomic) NSData *athleteImage;

@property (strong, nonatomic) UIView *accessoryView;

@property (strong, nonatomic) VANPictureTaker *pictureTaker;

@property (nonatomic, assign) BOOL isAlreadyEditingTextField;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSArray *positionArray;

@property (strong, nonatomic) UITableViewCell *selectedCell;
@property (strong, nonatomic) UIView *numberBackgroundView;

@end

@implementation VANCheckInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [_contentView removeConstraints:_contentView.constraints];

    _textFieldName.translatesAutoresizingMaskIntoConstraints = YES;
    _textFieldEmail.translatesAutoresizingMaskIntoConstraints = YES;
    _textFieldPhoneNumber.translatesAutoresizingMaskIntoConstraints = YES;
    _textFieldIDNumber.translatesAutoresizingMaskIntoConstraints = YES;
    _stepper.translatesAutoresizingMaskIntoConstraints = YES;
    _datePicker.translatesAutoresizingMaskIntoConstraints = YES;
    _birthdayLabel.translatesAutoresizingMaskIntoConstraints = YES;
    for (UILabel *label in self.labels) {
        label.translatesAutoresizingMaskIntoConstraints = YES;
        label.textAlignment = NSTextAlignmentLeft;
    }

    _steps = 1;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Athlete List" style:UIBarButtonItemStylePlain target:self action:@selector(backToAthletes)];
    self.navigationItem.leftBarButtonItem = back;
    
    
    //Setup For Athlete ID number methods
    self.textFieldName.text = self.athlete.name;
    self.textFieldIDNumber.text = [NSString stringWithFormat:@"%@", self.athlete.number];
    self.stepper.value = [self.athlete.number integerValue];
    
    //Setup for Athlete Date
    NSInteger interval = [self.event.athleteAge intValue]*365*24*60*60;
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-interval];
    self.datePicker.date = startDate;
    self.datePicker.maximumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(birthdayDatePickerValueDidChange) forControlEvents:UIControlEventValueChanged];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterLongStyle;
    self.birthdayLabel.text = [self.dateFormatter stringFromDate:startDate];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    [self.contentView insertSubview:backgroundImage atIndex:0];
    backgroundImage.image = [UIImage imageNamed:@"clipboard.png"];
    
    self.birthdayLabel.textAlignment = NSTextAlignmentLeft;
}

-(void)viewDidLayoutSubviews
{
    if (_steps == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self progressToStepOneWithAnimation:NO];
        } else {
            [self progressToStepTwoFromState:VANStatestepStart];
        }
    } else if (_steps == 2) {
        [self progressToStepTwoFromState:VANStatestepTwo];
    } else if (_steps == 3) {
        [self progressToStepThree];
    }
}

#pragma mark - Step Progression Methods

-(void)progressToStepOneWithAnimation:(BOOL)animation
{
    _steps = 1;
    
    [self.nextButton setTitle:@"Skip" forState:UIControlStateNormal];
    
    _backButton.hidden = YES;
    _profileButton.hidden = NO;
    [self.nextButton removeTarget:self action:@selector(progressToStepThree) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton addTarget:self action:@selector(toStepTwoFromOne) forControlEvents:UIControlEventTouchUpInside];
    [_profileButton addTarget:self action:@selector(activateCamera) forControlEvents:UIControlEventTouchUpInside];

    _stepsLabel.text = step1;
    
    if (animation) {
        self.profileImage.hidden = NO;
        self.secondaryProfileImage.hidden = YES;

        [UIView animateWithDuration:0.4 animations:^{
            [self stepOneFrameAdjustments];
        }];
        self.nextButton.enabled = YES;
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    } else
        [self stepOneFrameAdjustments];
}

-(void)stepOneFrameAdjustments
{
    //ImageView will be front and center w/ Its Button
    CGRect image = CGRectMake((self.view.frame.size.width-kImageStep1)/2, (self.view.frame.size.height-kImageStep1)/2, kImageStep1, kImageStep1);
    [self.profileImage setFrame:image];
    //_profileImage.image = [UIImage imageNamed:defaultImagePic];
    
    CGRect button = CGRectMake(10,10,10,10);
    [self.profileButton setFrame:button];
    
    CGRect clipboard = CGRectMake((self.view.frame.size.width-kClipboardWidth)/2, self.view.frame.size.height, kClipboardWidth, kClipboardHeight);
    [self.clipboardView setFrame:clipboard];
    
    CGRect progressButton = CGRectMake(self.view.frame.size.width-kButtonWidth, self.view.frame.size.height-kLabelHeightLarge, kButtonWidth, kLabelHeightLarge);
    [self.nextButton setFrame:progressButton];
}

-(void)progressToStepTwoFromState:(VANStatestep)state
{
    _steps = 2;
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    self.backButton.hidden = NO;
    [self.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.backButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.backButton addTarget:self action:@selector(toStepOneAnimated) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(progressToStepThree) forControlEvents:UIControlEventTouchUpInside];
    _stepsLabel.text = step2;
    
    [self checkIfContentIsRequired];
    
    if (state == VANStatestepOne || state == VANStatestepThree) {
        [UIView animateWithDuration:0.4 animations:^{
            [self stepTwoFrameAdjustments];
        } completion:^(BOOL success) {
            [self stepTwoPostFrameAdjustments];
        }];
    } else if (state == VANStatestepStart || state == VANStatestepTwo) {
        [self stepTwoFrameAdjustments];
        [self stepTwoPostFrameAdjustments];
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.backButton.hidden = YES;
    }
    
    self.clipboardView.contentSize = self.contentView.frame.size;
    [self.textFieldIDNumber addTarget:self action:@selector(checkIfContentIsRequired) forControlEvents:UIControlEventEditingChanged];
    [self.textFieldEmail addTarget:self action:@selector(checkIfContentIsRequired) forControlEvents:UIControlEventEditingChanged];
    [self.textFieldName addTarget:self action:@selector(checkIfContentIsRequired) forControlEvents:UIControlEventEditingChanged];
    [self.textFieldPhoneNumber addTarget:self action:@selector(checkIfContentIsRequired) forControlEvents:UIControlEventEditingChanged];
    self.textFieldName.inputAccessoryView = [self buildKeyboardAccessoryViewWithPrev:NO andNext:YES];
    self.textFieldIDNumber.inputAccessoryView = [self buildKeyboardAccessoryViewWithPrev:YES andNext:YES];
    self.textFieldEmail.inputAccessoryView = [self buildKeyboardAccessoryViewWithPrev:YES andNext:YES];
    self.textFieldPhoneNumber.inputAccessoryView = [self buildKeyboardAccessoryViewWithPrev:YES andNext:NO];
}

-(void)stepTwoFrameAdjustments
{
    NSInteger top = (self.view.frame.size.height-kClipboardHeight)/2;
    if (top < kClipboardMinTop) {
        top = kClipboardMinTop;
    }
    CGRect clipboard = CGRectMake((self.view.frame.size.width-kClipboardWidth)/2, top, kClipboardWidth, kClipboardHeight);
    [_clipboardView setFrame:clipboard];
    
    CGRect image = CGRectMake(clipboard.origin.x+kImageOffsetH, clipboard.origin.y+kImageOffsetV, kImageStep2, kImageStep2);
    [_profileImage setFrame:image];
    
    //Adjust Our Labels
    for (int i = 0; i < [self.labels count]; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        label.layer.opacity = 1;
    }
    
    self.textFieldIDNumber.placeholder = @"1";
    CGRect iDRect = CGRectMake(kStep2TopTextLeft, kStep2IDTop, kStep2IDWidth, kTextFieldHeight);
    [self.textFieldIDNumber setFrame:iDRect];
    self.textFieldIDNumber.textAlignment = NSTextAlignmentCenter;
    
    self.textFieldEmail.placeholder = @"yourEmail@TryoutSports.com";
    CGRect emailRect = CGRectMake(kStep2BottomTextLeft, kStep2EmailTop, kStep2LabelWidth, kTextFieldHeight);
    [self.textFieldEmail setFrame:emailRect];
    
    self.textFieldName.placeholder = @"Your Name";
    CGRect nameRect = CGRectMake(kStep2TopTextLeft, kStep2NameTop, kStep2NameWidth, kTextFieldHeight);
    [self.textFieldName setFrame:nameRect];
    
    self.textFieldPhoneNumber.placeholder = @"(123) 456-7890";
    CGRect phoneRect = CGRectMake(kStep2BottomTextLeft, kStep2PhoneTop, kStep2LabelWidth, kTextFieldHeight);
    [self.textFieldPhoneNumber setFrame:phoneRect];
    
    CGRect birthdayRect = CGRectMake(kStep2BottomTextLeft, kStep2BirthdayTop, kStep2LabelWidth, kTextFieldHeight);
    [self.birthdayLabel setFrame:birthdayRect];
    self.birthdayLabel.textAlignment = NSTextAlignmentLeft;
    
    //Hide the PickerView
    CGRect oldPickerFrame = self.datePicker.frame;
    [self.datePicker setFrame:CGRectMake(kStep2DatePickerLeft, self.contentView.frame.size.height-oldPickerFrame.size.height, kStep2DatePickerWidth, oldPickerFrame.size.height)];
    
    if (self.tableView) {
        CGRect tableRect = CGRectMake(kStep2DatePickerLeft, self.contentView.frame.size.height, kStep2DatePickerWidth, kTableViewHeight);
        [self.tableView setFrame:tableRect];
    }
    
    if (self.numberBackgroundView) {
        self.numberBackgroundView.layer.opacity = 0;
    }
}

-(void)stepTwoPostFrameAdjustments
{
    if (!self.secondaryProfileImage) {
        self.secondaryProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(kImageOffsetH, kImageOffsetV, kImageStep2, kImageStep2)];
        [self.contentView addSubview:self.secondaryProfileImage];
    }
    self.secondaryProfileImage.image = self.profileImage.image;
    self.secondaryProfileImage.hidden = NO;
    self.profileImage.hidden = YES;
    self.stepper.hidden = NO;
    
    _profileButton.hidden = YES;
    [_profileButton removeTarget:self action:@selector(activateCamera) forControlEvents:UIControlEventTouchUpInside];
    
    self.textFieldIDNumber.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldEmail.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldName.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldPhoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    
    self.textFieldIDNumber.textColor = [UIColor blackColor];
    self.textFieldEmail.textColor = [UIColor blackColor];
    self.textFieldName.textColor = [UIColor blackColor];
    self.textFieldPhoneNumber.textColor = [UIColor blackColor];
    self.birthdayLabel.textColor = [UIColor blackColor];
    
    self.textFieldIDNumber.userInteractionEnabled = YES;
    self.textFieldEmail.userInteractionEnabled = YES;
    self.textFieldName.userInteractionEnabled = YES;
    self.textFieldPhoneNumber.userInteractionEnabled = YES;

}

-(void)progressToStepThree
{
    _steps = 3; // Set Step Counter to 3
    
    //Make Neccessary Changes to the progression buttons
    self.backButton.hidden = NO;
    [self.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.backButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.backButton addTarget:self action:@selector(toStepTwoFromThree) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setTitle:@"Complete" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(completeSignInAndSaveAthleteInformation) forControlEvents:UIControlEventTouchUpInside];
    
    //Change the Main Instruction Label
    _stepsLabel.text = step3;
    
    //Remove Style and User interation from TextFields to look like labels
    self.textFieldIDNumber.borderStyle = UITextBorderStyleNone;
    self.textFieldEmail.borderStyle = UITextBorderStyleNone;
    self.textFieldName.borderStyle = UITextBorderStyleNone;
    self.textFieldPhoneNumber.borderStyle = UITextBorderStyleNone;
    
    self.textFieldIDNumber.userInteractionEnabled = NO;
    self.textFieldEmail.userInteractionEnabled = NO;
    self.textFieldName.userInteractionEnabled = NO;
    self.textFieldPhoneNumber.userInteractionEnabled = NO;
    
    self.textFieldIDNumber.textColor = [UIColor lightGrayColor];
    self.textFieldEmail.textColor = [UIColor lightGrayColor];
    self.textFieldName.textColor = [UIColor lightGrayColor];
    self.textFieldPhoneNumber.textColor = [UIColor lightGrayColor];
    self.birthdayLabel.textColor = [UIColor lightGrayColor];
    
    //Ensure that the TableView is loaded and built
    if (!self.tableView) {
        CGRect tableFrame = CGRectMake(30, self.contentView.frame.size.height, self.contentView.frame.size.width-60, kTableViewHeight);
        _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        
        self.positionArray = [self.event.positions allObjects];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
        self.positionArray = [_positionArray sortedArrayUsingDescriptors:@[sort]];
        
        [self.contentView addSubview:_tableView];
    }
    
    //Build small View around Number
    if (!self.numberBackgroundView) {
        self.numberBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(kNumberBGLeft, kNumberBGTop, kNumberBackGroundx, kNumberBackGroundx)];
        self.numberBackgroundView.backgroundColor = [UIColor blackColor];
        self.numberBackgroundView.layer.cornerRadius = kNumberBackGroundx/2;
        [self.contentView insertSubview:self.numberBackgroundView belowSubview:self.textFieldIDNumber];
        self.numberBackgroundView.layer.opacity = 0;
    }

    [UIView animateWithDuration:0.4 animations:^{
        
        //Adjust the clipboard view frame based on Space;
        NSInteger top = (self.view.frame.size.height-kClipboardHeight)/2;
        if (top < kClipboardMinTop) {
            top = kClipboardMinTop;
        }
        CGRect clipboard = CGRectMake((self.view.frame.size.width-kClipboardWidth)/2, top, kClipboardWidth, kClipboardHeight);
        [_clipboardView setFrame:clipboard];
        
        //Hide all of our labels
        for (int i = 0; i < [self.labels count]; i++) {
            UILabel *label = [self.labels objectAtIndex:i];
            label.layer.opacity = 0;
        }
        
        //Readjust our TextFieldViews to make room for TableView
        self.textFieldIDNumber.placeholder = @"";
        CGRect iDRect = CGRectMake(kStep3IDLeft, kStep3IDTop, 30, kTextFieldHeight);
        [self.textFieldIDNumber setFrame:iDRect];
        self.textFieldIDNumber.textAlignment = NSTextAlignmentCenter;
        
        self.textFieldEmail.placeholder = @"";
        CGRect emailRect = CGRectMake(kStep3TextFieldLeftB, kStep3EmailTop, kStep3LabelWidth, kTextFieldHeight);
        [self.textFieldEmail setFrame:emailRect];

        self.textFieldName.placeholder = @"";
        CGRect nameRect = CGRectMake(kStep3TextFieldLeft-2, kStep3NameTop, kStep3LabelWidth, kTextFieldHeight);
        [self.textFieldName setFrame:nameRect];

        self.textFieldPhoneNumber.placeholder = @"";
        CGRect phoneRect = CGRectMake(kStep3TextFieldLeftB-4, kStep3PhoneTop, kStep3LabelWidth, kTextFieldHeight);
        [self.textFieldPhoneNumber setFrame:phoneRect];

        CGRect birthdayRect = CGRectMake(kStep3TextFieldLeftB, kStep3BirthdayTop, kStep3LabelWidth, kTextFieldHeight);
        [self.birthdayLabel setFrame:birthdayRect];

        //Hide the PickerView and the Stepper
        CGRect oldPickerFrame = self.datePicker.frame;
        [self.datePicker setFrame:CGRectMake(oldPickerFrame.origin.x, self.view.frame.size.height, oldPickerFrame.size.width, oldPickerFrame.size.height)];
        self.stepper.hidden = YES;
        
        CGRect tableRect = CGRectMake(kStep2DatePickerLeft, self.contentView.frame.size.height-(kTableViewHeight+kStep2DatePickerLeft), kStep2DatePickerWidth, kTableViewHeight);
        [self.tableView setFrame:tableRect];
        [self.tableView reloadData];
        
        self.numberBackgroundView.layer.opacity = 1;

    }];
}

-(void)toStepTwoFromThree {
    [self progressToStepTwoFromState:VANStatestepThree];
}

-(void)toStepTwoFromOne {
    [self progressToStepTwoFromState:VANStatestepOne];
}

-(void)toStepOneAnimated {
    [self progressToStepOneWithAnimation:YES];
}

#pragma mark - ButtonPressedMethdods

-(IBAction)activateCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (!self.pictureTaker) {
            self.pictureTaker = [[VANPictureTaker alloc] init];
        }
        self.pictureTaker.delegate = self;
        [self presentViewController:self.pictureTaker.imagePicker animated:YES completion:nil];
    }
}

-(IBAction)backToAthletes
{
    if (self.athlete.isSelfCheckedIn) {
        NSManagedObjectContext *context = self.event.managedObjectContext;
        [context deleteObject:self.athlete];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)completeSignInAndSaveAthleteInformation
{
    //A. Save the Athletes personal Information to the account.
    if ([_textFieldName.text length] > 0) {
        self.athlete.name = _textFieldName.text;
    }
    self.athlete.number = [NSNumber numberWithInt:[_textFieldIDNumber.text intValue]];
    self.athlete.birthday = _datePicker.date;
    self.athlete.email = _textFieldEmail.text;
    self.athlete.phoneNumber = _textFieldPhoneNumber.text;
    // Position is set in TableView Delegate Methods
    
    //Image still...
    VANGlobalMethods *methods = [[VANGlobalMethods alloc] initwithEvent:self.event];
    Image *image = (Image *)[methods addNewRelationship:rAthleteImages toManagedObject:self.athlete andSave:NO];
    image.headShot = _athleteImage;
    
    self.athlete.checkedIn = [NSNumber numberWithBool:YES];
    
    [methods saveManagedObject:self.athlete];
    
    
    //B. Display a note saying successful sign-in
    [UIView animateWithDuration:0.5 animations:^{
        
        
        
        
        
    } completion:^(BOOL success) {
        //C. Pop back to Sign In Page with clean slate;
        if ([_delegate respondsToSelector:@selector(popViewControllerandReset)]) {
            [_delegate popViewControllerandReset];
        }
    }];
    

}

-(void)checkIfContentIsRequired
{
    if ([self.event.manageInfo isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        if ([self.textFieldName.text length] > 0 && [self.textFieldEmail.text length] > 0 && [self.textFieldIDNumber.text length] > 0 && [self.textFieldPhoneNumber.text length] > 0) {
            self.nextButton.enabled = YES;
        } else {
            self.nextButton.enabled = NO;
        }
    } else {
        if ([self.textFieldName.text length] > 0 && [self.textFieldIDNumber.text length] > 0) {
            self.nextButton.enabled = YES;
        } else {
            self.nextButton.enabled = NO;
        }
    }
    // If textFieldID is currently being edited
    [self adjustTextFieldIDNumber];
}

#pragma mark - UITextField DelegateMethods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.textFieldPhoneNumber isFirstResponder] || [self.textFieldName isFirstResponder] || [self.textFieldIDNumber isFirstResponder] || [self.textFieldEmail isFirstResponder]) {
        _isAlreadyEditingTextField = YES;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    float bottom = 0;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        bottom = kKeyboardHeightLandscape-(self.view.frame.size.height-(self.clipboardView.frame.size.height+self.clipboardView.frame.origin.y));
    } else {
        bottom = kKeyboardHeightPortrait-(self.view.frame.size.height-(self.clipboardView.frame.size.height+self.clipboardView.frame.origin.y));
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, bottom, 0);
    self.clipboardView.contentInset = insets;
    self.backButton.enabled = NO;
    
    //Set Editing Bool to No again for possible future release of firstResponder
    _isAlreadyEditingTextField = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //If we are moving from one text field to the next we prevent contentInset from changing and showing ugly jumping
    if (!_isAlreadyEditingTextField) {
        self.clipboardView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.backButton.enabled = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self moveForwardFromOneTextFieldToNext];
    return YES;
}

-(void)moveForwardFromOneTextFieldToNext
{
    if ([self.textFieldName isFirstResponder] || [self.textFieldIDNumber isFirstResponder]) {
        _isAlreadyEditingTextField = YES; //Set Already editing to stop changes in edgeinsets
        [self.textFieldName resignFirstResponder];
        [self.textFieldEmail becomeFirstResponder];
    } else if ([self.textFieldEmail isFirstResponder]) {
        _isAlreadyEditingTextField = YES;
        [self.textFieldEmail resignFirstResponder];
        [self.textFieldPhoneNumber becomeFirstResponder];
    } else {
        [self.textFieldPhoneNumber resignFirstResponder];
    }
}

-(void)moveBackwardFromOneTextFieldToNext
{
    if ([self.textFieldEmail isFirstResponder] || [self.textFieldIDNumber isFirstResponder]) {
        _isAlreadyEditingTextField = YES; //Set Already editing to stop changes in edgeinsets
        [self.textFieldName becomeFirstResponder];
    } else if ([self.textFieldPhoneNumber isFirstResponder]) {
        _isAlreadyEditingTextField = YES;
        [self.textFieldEmail becomeFirstResponder];
    } else {
        [self.textFieldName resignFirstResponder];
    }
}

-(void)releaseAllFirstResponders
{
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldName resignFirstResponder];
    [self.textFieldIDNumber resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
}

#pragma mark - Table View Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.positionArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Positions *position = [self.positionArray objectAtIndex:indexPath.row];
    cell.textLabel.text = position.position;
    
    if ([position.position isEqualToString:self.athlete.position]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        VANTeamColor *teamColor = [[VANTeamColor alloc] init];
        cell.textLabel.textColor = [teamColor findTeamColor];
        self.selectedCell = cell;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table View Data Source Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        VANTeamColor *teamColor = [[VANTeamColor alloc] init];
        cell.textLabel.textColor = [teamColor findTeamColor];
        self.selectedCell.accessoryType = UITableViewCellAccessoryNone;
        self.selectedCell.textLabel.textColor = [UIColor blackColor];
    }
    Positions *position = [self.positionArray objectAtIndex:indexPath.row];
    self.athlete.position = position.position;
    
    self.selectedCell = cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    [view addSubview:label];
    label.text = @"Select your preferred position";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


#pragma mark - Van Picture Taker Delegate Methods

-(void)passBackSelectedImageData:(NSData *)imageData
{
    self.athleteImage = imageData;
    
    //Setup Image
    UIImage *image = [UIImage imageWithData:imageData];
    if (image) {
        self.profileImage.image = nil;
        self.profileImage.image = image;
    }
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(_profileImage.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:_profileImage.bounds
                                cornerRadius:kImageStep1] addClip];
    // Draw your image
    [image drawInRect:_profileImage.bounds];
    
    // Get the image, here setting the UIImageView image
    _profileImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();

    _profileImage.backgroundColor = [UIColor clearColor];
}

-(void)pictureTaker:(VANPictureTaker *)object isReadyToDismissWithAnimation:(BOOL)animation {
    [self dismissViewControllerAnimated:YES completion:^{
        [self progressToStepTwoFromState:VANStatestepOne];
    }];
}

#pragma mark - Stepper Change Methods

//Also some code Implementation placed in
-(void)adjustTextFieldIDNumber
{
    if ([self.textFieldIDNumber isFirstResponder]) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        NSNumber *value = [formatter numberFromString:self.textFieldIDNumber.text];
        if ([self.textFieldIDNumber.text isEqualToString:@""]) {
            value = @0;
        }
        if (value) {
            self.stepper.value = [value integerValue];
        } else {
            self.textFieldIDNumber.text = [NSString stringWithFormat:@"%.0f", self.stepper.value];
        }
    }
}

-(void)changeStepperValue:(id)sender
{
    self.textFieldIDNumber.text = [NSString stringWithFormat:@"%.0f", self.stepper.value];
}

#pragma mark - Date Picker Change Methods

-(void)birthdayDatePickerValueDidChange
{
    self.birthdayLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
    
}

#pragma mark - Other Methods

-(UIView *)buildKeyboardAccessoryViewWithPrev:(BOOL)previous andNext:(BOOL)nextup
{
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    accessoryView.backgroundColor = [UIColor lightGrayColor];
    UIButton *next = [[UIButton alloc] initWithFrame:CGRectMake(120, 0, 60, 40)];
    UIButton *prev = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, 40)];
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 60, 40)];
    [next setTitle:@"next" forState:UIControlStateNormal];
    [prev setTitle:@"prev" forState:UIControlStateNormal];
    [done setTitle:@"done" forState:UIControlStateNormal];
    [next addTarget:self action:@selector(moveForwardFromOneTextFieldToNext) forControlEvents:UIControlEventTouchUpInside];
    [prev addTarget:self action:@selector(moveBackwardFromOneTextFieldToNext) forControlEvents:UIControlEventTouchUpInside];
    [done addTarget:self action:@selector(releaseAllFirstResponders) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:next];
    [accessoryView addSubview:prev];
    [accessoryView addSubview:done];
    if (!previous) {
        prev.hidden = YES;
    }
    if (!nextup) {
        next.hidden = YES;
    }
    return accessoryView;
}



@end
