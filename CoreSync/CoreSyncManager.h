//
//  CoreSyncManager.h
//  vWork
//
//  Created by Marcus Wyatt on 9/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ThreadedCoreDataOperationDelegate.h"
#import "CoreSyncModelMapper.h"

@interface CoreSyncManager : NSObject<ASIHTTPRequestDelegate, ThreadedCoreDataOperationDelegate> {
    id mainMergePolicy_;
    id threadedMergePolicy_;

    NSString *remoteSiteURL_;
    NSDateFormatter *defaultDateParser_;

    BOOL useBundleRequests_;
    float bundleRequestDelay_;
    int logLevel_;

@private
    NSManagedObjectContext *mainManagedObjectContext_;

    NSOperationQueue *syncronizationQueue_;
    NSOperationQueue *requestQueue_;
    NSOperationQueue *deserialzationQueue_;

    NSNumber *syncFrequency_;
    NSTimer *syncTimer_;
    BOOL *syncTimerRunning_;

    NSString *defaultDateParserFormat_;

    CoreSyncModelMapper *modelMapper_;
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, copy) NSNumber *syncFrequency;

/*
 * The main NSManagedObjectContext merge policy.
 */
@property (nonatomic, retain) id mainMergePolicy;
/**
 * The threaded NSManagedObjectContext merge policy.
*/
@property (nonatomic, retain) id threadedMergePolicy;

@property (nonatomic, readonly, copy) NSDateFormatter *defaultDateParser;

@property (nonatomic, copy) NSString *remoteSiteURL;
@property (nonatomic, assign) BOOL useBundleRequests;
@property (nonatomic) float bundleRequestDelay;
@property (nonatomic) int logLevel;
@property (nonatomic, copy) NSString *defaultDateParserFormat;

@property (nonatomic, readonly, retain) CoreSyncModelMapper *modelMapper;

/**
 The main NSManagedObjectContext running on the event loop.
*/
@property (nonatomic, retain) NSManagedObjectContext *mainManagedObjectContext;

/**
 The operation queue to manage the syncing of data on CoreData.
*/
@property (nonatomic, retain) NSOperationQueue *syncronizationQueue;
/**
 The operation queue to manage the requests to the restful service.
*/
@property (nonatomic, retain) NSOperationQueue *requestQueue;
/**
 The operation queue to manage the deserialization of response into ManagedObjects.
*/
@property (nonatomic, retain) NSOperationQueue *deserialzationQueue;

@property (nonatomic, assign, getter=isRunning) BOOL *syncTimerRunning;

#pragma mark -
#pragma mark Init

- (id)initWithMainObjectContext:(NSManagedObjectContext *)aManagedObjectContext usingOptions:(NSDictionary*)aOptions;

#pragma mark -
#pragma mark Networking

- (void)enqueueRequest:(ASIHTTPRequest*)request;

#pragma mark -
#pragma mark Singleton

+ (CoreSyncManager *)sharedInstance;
+ (void)setSharedInstance:(CoreSyncManager *)aSharedInstance;


#pragma mark -
#pragma mark Management

- (void)start;
- (void)stop;
- (void)syncronize;

@end
