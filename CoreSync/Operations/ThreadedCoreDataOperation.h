//
//  ThreadedCoreDataOperation.h
//  vWork
//
//  Created by Marcus Wyatt on 9/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JSON.h"
#import "CoreSyncModelMapper.h"
#import "ThreadedCoreDataOperationDelegate.h"

@interface ThreadedCoreDataOperation : NSOperation {

    NSManagedObjectContext *mainContext_;

    NSManagedObjectContext *threadedContext_;

    /**
     The merge policy to use for this Core Data operation.
     */
    id mergePolicy_;

    NSString *remoteEntityName_;

    NSString *dateParserFormat_;

    id<ThreadedCoreDataOperationDelegate> delegate_;

    NSString *jsonResponseString_;

    CoreSyncModelMapper *modelMapper_;
}
/**
 This is the NSManagedObjectContext intended to be used by
 instances of this class for reading and writing to Core Data.
 */
@property (nonatomic, readonly, retain) NSManagedObjectContext *threadedContext;

/**
 Returns the NSManagedObjectContext from the main thread that any updates should be merged into.
 */
@property (nonatomic, readonly, retain) NSManagedObjectContext *mainContext;

@property (nonatomic, readonly, copy) NSString *remoteEntityName;

@property (nonatomic, copy) NSString *dateParserFormat;

@property (nonatomic, assign) id<ThreadedCoreDataOperationDelegate> delegate;

@property (nonatomic, copy) NSString *jsonResponseString;

@property (nonatomic, readonly, retain) CoreSyncModelMapper *modelMapper;

/**
 Saves the threaded context, merging the changes into the main context.
 */
- (void)saveThreadedContext;

#pragma mark -
#pragma mark Init

/**
 Returns a non-nil ThreadedCoreDataOperation Sub-Class instance which will merge any changes that this NSOperation makes into the specified
 main NSManagedObjectContext.

 @param aMainManagedObjectContext - non-nil NSManagedObjectContext into which any changes will be merged (One used in main run loop)
 @param anMergePolicy - non-nil merge policy that the NSManagedObjectContext for this NSOperation will use
 */
- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy;

/**
 Returns a non-nil ThreadedCoreDataOperation Sub-Class instance which will merge any changes that this NSOperation makes into the specified
 main NSManagedObjectContext.

 @param aMainManagedObjectContext - non-nil NSManagedObjectContext into which any changes will be merged (One used in main run loop)
 @param anMergePolicy - non-nil merge policy that the NSManagedObjectContext for this NSOperation will use
 @param aDelegate - A ThreadedCoreDataOperationDelegate
 */
- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy
                              delegate:(id<ThreadedCoreDataOperationDelegate>)aDelegate;

/**
 Returns a non-nil ThreadedCoreDataOperation Sub-Class instance which will merge any changes that this NSOperation makes into the specified
 main NSManagedObjectContext.

 @param aMainManagedObjectContext - non-nil NSManagedObjectContext into which any changes will be merged (One used in main run loop)
 @param anMergePolicy - non-nil merge policy that the NSManagedObjectContext for this NSOperation will use
 @param aDelegate - A ThreadedCoreDataOperationDelegate
 @param aJsonResponseString - The JSON string to process
 */
- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy
                              delegate:(id<ThreadedCoreDataOperationDelegate>)aDelegate
                    jsonResponseString:(NSString*)aJsonResponseString;

/**
 Returns a non-nil ThreadedCoreDataOperation Sub-Class instance which will merge any changes that this NSOperation makes into the specified
 main NSManagedObjectContext.

 @param aMainManagedObjectContext - non-nil NSManagedObjectContext into which any changes will be merged (One used in main run loop)
 @param anMergePolicy - non-nil merge policy that the NSManagedObjectContext for this NSOperation will use
 @param aDelegate - A ThreadedCoreDataOperationDelegate
 @param aJsonResponseString - The JSON string to process
 @param aDateParserFormat - The Date Format to set when parsing NSDate values
 */
- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy
                              delegate:(id<ThreadedCoreDataOperationDelegate>)aDelegate
                    jsonResponseString:(NSString*)aJsonResponseString
                      dateParserFormat:(NSString*)aDateParserFormat;

#pragma mark -
#pragma mark Helpers

- (void)updatePropertiesFor:(NSManagedObject *)model withParameters:(NSDictionary *)remoteModelAttributes;
- (NSString *)entityName;
- (NSEntityDescription *)entityDescription;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSDictionary *)entitiesByName;
- (NSArray *)entities;


#pragma mark -
#pragma mark Deserialization

- (id)deserializeJSONString;


@end
