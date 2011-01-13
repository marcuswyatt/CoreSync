//
//  CoreDataModelUpdateOperation.h
//  vWork
//
//  Created by Marcus Wyatt on 11/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ThreadedCoreDataOperation.h"

@interface CoreDataModelUpdateOperation : ThreadedCoreDataOperation {

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
                    jsonResponseString:(NSString*)aJsonResponseString
              managedObjectIDUrlString:(NSString *)anObjectIdUrlString;
@end
