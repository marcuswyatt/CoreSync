//
//  Project.h
//  Jobber
//
//  Created by Marcus Wyatt on 13/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Milestone;

@interface Project :  NSManagedObject
{
}

@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * templateName;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * remoteId;
@property (nonatomic, retain) NSDate * syncedAt;
@property (nonatomic, retain) NSDate * plannedStartAt;
@property (nonatomic, retain) NSNumber * publishedBy;
@property (nonatomic, retain) NSDate * alarmAt;
@property (nonatomic, retain) NSString * progressState;
@property (nonatomic, retain) NSDate * publishedAt;
@property (nonatomic, retain) NSDate * deletedAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * batchId;
@property (nonatomic, retain) NSDate * requestAt;
@property (nonatomic, retain) NSString * thirdPartyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * zoneName;
@property (nonatomic, retain) NSNumber * plannedDuration;
@property (nonatomic, retain) NSSet* milestones;

@end


@interface Project (CoreDataGeneratedAccessors)
- (void)addMilestonesObject:(Milestone *)value;
- (void)removeMilestonesObject:(Milestone *)value;
- (void)addMilestones:(NSSet *)value;
- (void)removeMilestones:(NSSet *)value;

@end

