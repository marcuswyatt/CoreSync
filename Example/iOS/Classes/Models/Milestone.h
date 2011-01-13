//
//  Milestone.h
//  Jobber
//
//  Created by Marcus Wyatt on 13/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Project;

@interface Milestone :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * stepType;
@property (nonatomic, retain) NSDate * deletedAt;
@property (nonatomic, retain) NSNumber * remoteId;
@property (nonatomic, retain) NSNumber * sequenceOrder;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSDate * completedAt;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * syncedAt;
@property (nonatomic, retain) Project * project;

@end



