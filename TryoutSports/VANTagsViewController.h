//
//  VANTagsPopoverViewController.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-08.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "Event.h"
#import "VANManagedObjectViewController.h"

@interface VANTagsViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) Athlete *athlete;
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) NSMutableArray *selectedTagsArray;
@property (strong, nonatomic) NSMutableArray *tagsArray;

-(void)buildnewTagWithString:(NSString *)string andType:(NSInteger)type;
-(void)closeNewTagCell;

@end
