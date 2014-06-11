//
//  VANIntroTest.m
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2013-08-26.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VANIntroViewController.h"

@interface VANIntroTest : XCTestCase

@property (nonatomic, strong) VANIntroViewController *intro;

@end

@implementation VANIntroTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.intro = [[VANIntroViewController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    self.intro = nil;
    
    [super tearDown];
}

- (void)testFetchedResultsController
{
    XCTAssertTrue([self.intro respondsToSelector:@selector(config)], @"expecte Intro to fetchControllers properlly");
}

- (void)contextExists {
    XCTAssertTrue([self.init respondsToSelector:@selector(managedObjectContext)], @"Context Exists");
}

@end
