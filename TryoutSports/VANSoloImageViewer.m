//
//  VANSoloImageViewer.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-10-04.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANSoloImageViewer.h"
#import "Image.h"
#import "Athlete.h"

static float activeAlpha = 1.0f;
static float alpha = 0.0f;
static NSString *profilePic = @"TSsmall-04.png";

@interface VANSoloImageViewer ()

@property (strong, nonatomic) UIImageView *pictureImage;
@property (strong, nonatomic) Image *athleteImage;
@property (strong, nonatomic) UIButton *backgroundButton;

@property (nonatomic, assign) CGRect baseImagePosition;

@end

@implementation VANSoloImageViewer

- (id)initWithFrame:(CGRect)frame andImage:(Image *)imageContainer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        //Initial Setup for the View before moving through animation of viewing

        self.backgroundColor = [UIColor blackColor];
        self.alpha = alpha;
        
        _pictureImage = [[UIImageView alloc] init];
        _pictureImage.layer.masksToBounds = YES;
        
        [self addSubview:_pictureImage];
        
        _backgroundButton = [[UIButton alloc] initWithFrame:self.frame];
        [_backgroundButton addTarget:self action:@selector(doneViewingImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundButton];

        UIToolbar *bottomTools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44)];
        bottomTools.barStyle = UIBarStyleBlackOpaque;
        
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneViewingImage)];
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteImage)];
        UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreOptions)];
        UIImage *profile = [UIImage imageNamed:profilePic];
        UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:profile style:UIBarButtonItemStylePlain target:self action:@selector(makeProfileImage)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        NSArray *buttons = [NSArray arrayWithObjects:deleteButton, flexibleSpace, moreButton, flexibleSpace, profileButton, flexibleSpace, closeButton, nil];
        
        [bottomTools setItems:buttons];
        [self addSubview:bottomTools];
        
    }
    return self;
}


-(void)animateInImageViewerWithImage:(Image *)imageContainer andInitialPosition:(CGRect)position
{
    _baseImagePosition = position;
    _pictureImage.frame = position;

    _athleteImage = imageContainer;
    NSData *imageData = imageContainer.headShot;
    UIImage *image = [UIImage imageWithData:imageData];
    self.pictureImage.image = image;
    
    [UIView animateWithDuration:.4 animations:^{
        self.alpha = activeAlpha;
        self.pictureImage.frame = CGRectMake(0, (self.frame.size.height-self.frame.size.width)/2, self.frame.size.width, self.frame.size.width);
    } completion:^(BOOL success) {
        
    }];
}

-(void)deleteImage
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Delete this image?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    action.tag = 0;
    [action showInView:self];

}

-(void)doneViewingImage
{
    //We dont want do adjust anything with the image but want to animate it back to its origional position
    [self closeImageViewerToLocation:_baseImagePosition];
}

-(void)closeImageViewerToLocation:(CGRect )location {
    [UIView animateWithDuration:0.3 animations:^{
        self.pictureImage.frame = location;
    } completion:^(BOOL success) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        }];
        if ([_delegate respondsToSelector:@selector(closeSoloImageViewer)]) {
            [self.delegate closeSoloImageViewer];
        }
    }];
}

-(void)moreOptions {
#warning need to add Functionality to these two buttons still

}

-(void)makeProfileImage {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Use as Profile Picture?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    action.tag = 2;
    [action showInView:self];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) { //0 == Delete Button Pressed
        if (buttonIndex == 0) {
            // We want to delete the Image and animated its release off of the screen while removing the view.
            [self closeImageViewerToLocation:CGRectMake(0, self.frame.size.height-30, 30, 30)];
            NSManagedObjectContext *context = self.athleteImage.managedObjectContext;
            [context deleteObject:self.athleteImage];
            [self.delegate deleteImagefromSoloImageViewer:self.athleteImage];
            [_delegate requiresUIUpdating];
        }
    } else if (actionSheet.tag == 2) { // 2 == Make Profile Image Button Pressed
        if (buttonIndex == 0) {
            Athlete *athlete = _athleteImage.athlete;
            athlete.profileImage = _athleteImage;
            [_delegate requiresUIUpdating];
        }
    }
}

@end
