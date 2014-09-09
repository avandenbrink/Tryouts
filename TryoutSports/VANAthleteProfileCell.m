//
//  VANAthleteProfileCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-20.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANAthleteProfileCell.h"
#import "VANTeamColor.h"
#import "VANPictureTaker.h"
#import "Image.h"
#import "VANProfileView.h"

//Static Image File Names:
static NSString *profile = @"TSsmall-01.png";
static NSString *camera = @"cameraButton.png";


@interface VANAthleteProfileCell ()

@property (strong, nonatomic) VANPictureTaker *pictureTaker;

@property (strong, nonatomic) UIView *prev;

@end

@implementation VANAthleteProfileCell

-(void)setup
{
    if (!_content) {
        _content = [[UIView alloc] init];
        [_imageScrollView addSubview:self.content];
            _content.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *dic = @{@"content": self.content};
        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:0 views:dic];
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[content]|" options:0 metrics:0 views:dic];
        
        [_imageScrollView addConstraints:h];
        [_imageScrollView addConstraints:v];
    }
}


-(void)addOrSubtrackViews {
    
    NSArray *imageArray = [self.athlete.images allObjects]; //Get array of athlete images
    NSInteger total = [imageArray count]+1; //Count images +1 for the "Take a Picture image"
    NSInteger views = [self.content.subviews count]; //Count how many views currently exist
    //Determine whether we need to Add to or subtrack from the current Views in the Area.
    if (total > views) {
        
        //If we need to add Views, calculate how many.
        NSInteger newViews = total-views;
    
        for (NSInteger i = 0; i < newViews; i++) {
            
            VANProfileView *view = [[VANProfileView alloc] init]; //Create new image viewer instance
            view.delegate = self;
            [self.content addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            //Add Constraints
            NSDictionary *dic = NSDictionaryOfVariableBindings(view,self.content);
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageScrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
            [self.imageScrollView addConstraint:width];
            [self.imageScrollView addConstraint:height];
            
            NSArray *vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:dic];
            [self.content addConstraints:vert];
            
            //If this is not the first view created, then its leading constraint will be to its nearest partner instead of the superview;
            if (self.prev) {
                NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.prev attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
                [self.content addConstraint:left];
            } else {
                NSArray *left = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]" options:0 metrics:0 views:dic];
                [self.content addConstraints:left];
            }
            self.prev = view; //Reset the Previous View to current view for the next iteration through this code
            
            //If this will be the last view that is created
            if (i == newViews-1) {
                NSArray *right = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]|" options:0 metrics:0 views:dic];
                [self.content addConstraints:right]; //Constraint tying training edge of view to training edge of superview.  This is key for the scrolling feature to work to register the ContentView of the scrollview to be larger than its frame.
                
                
                // Also if this is the last image it will represent the take new picture and we should add the proper target to be set in motion when its button is pressed.
                
                [view.button addTarget:self action:@selector(activateCameraPressed) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [view.button addTarget:self action:@selector(viewImageInFullScreen) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

        //self.addPicView = [[UIImageView alloc] initWithFrame:CGRectMake(([imageArray count]*self.imageScrollView.frame.size.width)+((self.imageScrollView.frame.size.width-140)/2),(self.imageScrollView.frame.size.height-100)/2,140,100)];

        //[self.addImageButton addTarget:self action:@selector(addPicture:) forControlEvents:UIControlEventTouchUpInside];

-(void)attachImages
{
    //Here we separately take the images off the headshot and correlate them with the ProfileView's previously created.
    NSArray *imageArray = [self.athlete.images allObjects];
    NSInteger total = [imageArray count];
    NSArray *views = self.content.subviews;

    for (int i = 0; i <= total; i++) {
        VANProfileView *view = [views objectAtIndex:i];
        UIImage *image;
        if (i != total) {
            Image *imageMO = [imageArray objectAtIndex:i];
            image = [UIImage imageWithData:imageMO.headShot];
            
            
            if (self.athlete.profileImage == imageMO) {
                if (!view.profileView) {
                    view.profileView = [[UIImageView alloc] initWithFrame:CGRectMake(135, 15, 35, 35)];
                    [view addSubview:view.profileView];

                }
                UIImage *image = [UIImage imageNamed:profile];
                
                view.profileView.image = image;
            } else {
                view.profileView = nil;
            }
        } else {
            image = [UIImage imageNamed:camera];
        }
        view.imageView.image = image;
        
    }
                //    [selectImage addTarget:self action:@selector(buildFullScreenImageViewWithImage) forControlEvents:UIControlEventTouchUpInside];

}

-(void)addNewImageFromData:(NSData *)imageData {
    //Right now this isn't needed becuase table reloadData does the trick
    
    /*
    NSArray *subviews = self.content.subviews;
    NSInteger count = [subviews count];
    
    //Get pointer to New Image ImageView
    VANProfileView *view = [subviews objectAtIndex:[self.content.subviews count]-1];
    
    //Create a New View
    VANProfileView *newView = [[VANProfileView alloc] init];
    newView.delegate = self;
    newView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.content insertSubview:newView belowSubview:view];
    newView.imageView.image = [UIImage imageWithData:imageData];
    NSDictionary *dic = @{@"new": newView, @"view": view};
    [self layoutSubviews];
    [UIView animateWithDuration:0.5f animations:^{
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageScrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageScrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        [self.imageScrollView addConstraint:width];
        [self.imageScrollView addConstraint:height];
        
        NSArray
    
        if (count == 1) {
            //If Previously there was no other Images attached to this Athlete:
            
            //A. Give New View Constraints to Front of Content
            NSArray *front = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[new]" options:0 metrics:0 views:dic];
            [self.content addConstraints:front];
            
            //B. Remove constraint from view to the front of Content
            NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]|" options:0 metrics:0 views:dic];
            [self.content removeConstraints:constraint];
            
            //C. AddConstraint from newViewTrailing, to view's leading
            NSLayoutConstraint *connect = [NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
            [self.content addConstraint:connect];
            
        } else {
            VANProfileView *prevView = [subviews objectAtIndex:[self.content.subviews count]-2];
            
        }
        
        [self layoutSubviews];
    }];*/
}

-(void)activateCameraPressed {
    if ([_delegate respondsToSelector:@selector(VANTableViewCellrequestsActivateCameraForAthlete:fromCell:)]) {
        [_delegate VANTableViewCellrequestsActivateCameraForAthlete:self.athlete fromCell:self];
    }}

-(void)viewImageInFullScreen {
    if ([_delegate respondsToSelector:@selector(VANTableViewCellrequestsImageforAthete:fromCell:)]) {
        [_delegate VANTableViewCellrequestsImageforAthete:self.athlete fromCell:self];
    }
}
        
@end
