//
//  VANCheckInViewController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 12/9/2013.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANManagedObjectViewController.h"
#import "VANPictureTaker.h"

typedef NS_ENUM(NSUInteger, VANStatestep) {
    VANStatestepStart = 0,
    VANStatestepOne,
    VANStatestepTwo,
    VANStatestepThree
};

@protocol VANCheckInDelegate <NSObject>

-(void)popViewControllerandReset;

@end

@interface VANCheckInViewController : VANManagedObjectViewController <UITableViewDataSource, UITableViewDelegate, VANPictureTakerDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <VANCheckInDelegate> delegate;

//Multiuse Elements
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

//Step One Elements
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

//Step Two Elements

@property (strong, nonatomic) UIImageView *secondaryProfileImage;
@property (weak, nonatomic) IBOutlet UIScrollView *clipboardView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldIDNumber;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

//Step Three Elements

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

-(IBAction)activateCamera;
-(IBAction)backToAthletes;
-(IBAction)changeStepperValue:(id)sender;

@end
