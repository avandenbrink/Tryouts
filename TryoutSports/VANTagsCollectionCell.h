//
//  VANTagsCollectionCell.h
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-06-01.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"

@interface VANTagsCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@end
