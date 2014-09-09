//
//  Athlete.h
//  TryoutSports
//
//  Created by Aaron VandenBrink on 2014-08-20.
//  Copyright (c) 2014 Aaron VandenBrink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AthleteSkills, AthleteTags, AthleteTest, Event, Image;

@interface Athlete : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * checkedIn;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * flagged;
@property (nonatomic, retain) NSNumber * isSelfCheckedIn;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * seen;
@property (nonatomic, retain) NSNumber * valueScore;
@property (nonatomic, retain) id skillsname;
@property (nonatomic, retain) id skillsvalue;
@property (nonatomic, retain) id tags;
@property (nonatomic, retain) NSNumber * teamSelected;
@property (nonatomic, retain) id testname;
@property (nonatomic, retain) id testvalue;
@property (nonatomic, retain) NSString * coach;
@property (nonatomic, retain) NSSet *aTags;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) Image *profileImage;
@property (nonatomic, retain) NSSet *skills;
@property (nonatomic, retain) NSSet *tests;
@end

@interface Athlete (CoreDataGeneratedAccessors)

- (void)addATagsObject:(AthleteTags *)value;
- (void)removeATagsObject:(AthleteTags *)value;
- (void)addATags:(NSSet *)values;
- (void)removeATags:(NSSet *)values;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addSkillsObject:(AthleteSkills *)value;
- (void)removeSkillsObject:(AthleteSkills *)value;
- (void)addSkills:(NSSet *)values;
- (void)removeSkills:(NSSet *)values;

- (void)addTestsObject:(AthleteTest *)value;
- (void)removeTestsObject:(AthleteTest *)value;
- (void)addTests:(NSSet *)values;
- (void)removeTests:(NSSet *)values;

@end
