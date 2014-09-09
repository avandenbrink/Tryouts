//
//  UIImage+resize.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-22.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (resize)

+ (UIImage *)imageWithImage:(UIImage *)image
         scaledToFitToSize:(CGSize)newSize;

@end
