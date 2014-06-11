//
//  VANSoloImageViewer.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-10-04.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"

@protocol VANSoloImageViewerDelegate <NSObject>

-(void)deleteImagefromSoloImageViewer:(Image *)image;
-(void)closeSoloImageViewer;
-(void)requiresUIUpdating;

@end

@interface VANSoloImageViewer : UIView <UIActionSheetDelegate>

@property (nonatomic, weak) id <VANSoloImageViewerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andImage:(Image *)selectedImage;
-(void)animateInImageViewerWithImage:(Image *)imageContainer andInitialPosition:(CGRect)position;

@end
