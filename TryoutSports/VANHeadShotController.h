//
//  VANHeadShotController.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-10-03.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import "VANManagedObjectViewController.h"

@interface VANHeadShotController : VANManagedObjectViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
