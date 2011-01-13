//
//  CoreDataModelDestroyOperation.h
//  vWork
//
//  Created by Marcus Wyatt on 10/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ThreadedCoreDataOperation.h"

@interface CoreDataModelDestroyOperation : ThreadedCoreDataOperation {
@private
    NSManagedObjectID *objectID_;
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, copy) NSManagedObjectID *objectID;

#pragma mark -
#pragma mark Init

/**
 Creates a new ThreadedCoreDataOperation that will update the surname field of the specified Person entity.
*/
- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy
                              delegate:(id<ThreadedCoreDataOperationDelegate>)aDelegate
              managedObjectIDUrlString:(NSString *)anObjectIdUrlString;
@end
