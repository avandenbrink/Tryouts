//
//  VANTryoutDocument.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-11.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VANTryoutDocument : UIManagedDocument <UIActivityItemSource>

@property (strong, nonatomic) NSMutableArray *moveEventListeners;
@property (strong, nonatomic) NSString *documentName;
@property (strong, nonatomic) NSFileWrapper *wrapper;

@end
