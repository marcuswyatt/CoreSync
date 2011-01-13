//
//  CoreSyncMapper.h
//  vWork
//
//  Created by Marcus Wyatt on 11/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreSyncConstants.h"

@interface CoreSyncModelMapper : NSObject {

@private
    NSManagedObjectContext *mainManagedObjectContext_;
    NSString *remoteSiteURL_;

}

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic, copy) NSString *remoteSiteURL;

#pragma mark -
#pragma mark Init

- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                         remoteSiteURL:(NSString*)aRemoteSiteURL;

#pragma mark -
#pragma mark CoreSync Mapping Setup

- (NSString *)localIdField;
- (NSString *)remoteIdField;
- (NSString *)remoteCollectionName:(NSEntityDescription *)entity;
- (NSString *)remoteClassName:(NSManagedObject *)model;
- (NSString *)remoteCollectionType:(NSEntityDescription *)entity;

- (BOOL)hasNestedResourceRelationshipsOnEntity:(NSEntityDescription *)entity;

#pragma mark -
#pragma mark CoreSync Field Mapping

- (NSString *)localNameForRemoteField:(NSString*)name onModel:(NSManagedObject *)model;
- (NSString *)remoteNameForLocalField:(NSString*)name onModel:(NSManagedObject *)model;
- (NSString *)remoteNameForLocalField:(NSAttributeDescription *)attributeDescription;

//- (NSAttributeDescription *)attributeDescriptionForField:(NSString *)field onModel:(NSManagedObject *)model;
- (NSPropertyDescription *)propertyDescriptionForField:(NSString *)field onModel:(NSManagedObject *)model;
- (NSRelationshipDescription *)parentRelationshipDescription:(NSDictionary *)properties;

#pragma mark -
#pragma mark URL Handling

- (NSString *)collectionURLUsingModel:(NSManagedObject *)model;
- (NSString *)collectionURLUsingEntity:(NSEntityDescription *)entity;
- (NSString *)itemURLUsingModel:(NSManagedObject *)model action:(Actions)action;

#pragma mark -
#pragma mark Helper Methods

- (NSDictionary *)postValuesForModel:(NSManagedObject *)model;

@end
