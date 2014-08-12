//
//  VANCollectionCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tags.h"
#import "VANTagsViewController.h"
#import "VANLeftAlignedFlowLayout.h"
#import "VANAthleteDetailController.h"

@interface VANCollectionCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet VANLeftAlignedFlowLayout *layoutView;
@property (weak, nonatomic) VANAthleteDetailController *delegateController;
@property (strong, nonatomic) Athlete *athlete;
@property (strong, nonatomic) NSMutableArray *tagsArray;
@property (strong, nonatomic) UILabel *label;

- (void)initiate;

@end
