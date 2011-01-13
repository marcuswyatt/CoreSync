//
//  CoreSyncMapper.m
//  vWork
//
//  Created by Marcus Wyatt on 11/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//
//
//  URL Schemes supported
//
//    Default Resoures
//    -----------------------
//    index   GET    /jobs.json
//    show    GET    /steps/:id.json
//    create  POST   /jobs.json
//    update  PUT    /steps/:id.json
//    destroy DELETE /steps/:id.json
//
//    Shallow Nested Resoures
//    -----------------------
//    index   GET    /jobs/:job_id/steps.json
//    show    GET    /steps/:id.json
//    create  POST   /jobs/:job_id/steps.json
//    update  PUT    /steps/:id.json
//    destroy DELETE /steps/:id.json
//
//    Normal Nested Resoures
//    ----------------------
//    index   GET    /workers/:worker_id/posts.json
//    show    GET    /workers/:worker_id/posts/:id.json
//    create  POST   /workers/:worker_id/posts.json
//    update  PUT    /workers/:worker_id/posts/:id.json
//    destroy DELETE /workers/:worker_id/posts/:id.json
//
// CoreSync User Info Key Descriptions
// -----------------------------------
//
//  EntityDescription
//  -----------------
//  *  ClassNameRemote      (optional): Name of the class on the remote api (if none specified infer from the entity description name)
//  *  CollectionRoute      (optional): The resource's url route. (For example in the url http://server/jobs/1.json the CollectionRoute is 'jobs')
//  *  ResourcePathPrefix   (optional): The resource's url route prefix. (For example in the url http://server/mobile/2.0/jobs/1.json the ResourcePathPrefix is 'mobile/2.0')
//  *  ResourceTypeRemote   (Required): Specify if the url generation should take into account the ManyAssociationType value of the Relationship (if present)
//                                      when generating the urls.
//     -  NormalResource: model is standard Restful resource.
//     -  NestedResource: model has parent resource. The nested resource can be one of the ManyAssociationTypes.
//
//  AttributeDescription
//  --------------------
//  *  AttributeRemote      (Required): On all the attributes of your entities you want to sync
//  *  DateFormat           (Optional): Can specify a Date Format to use to deserialize Date and Time values
//  *                       (Required):
//
//
//  RelationshipDescription
//  -----------------------
//  *  ManyAssociationType  (* Required): Use in the url generation for the entity
//                                       (* When the ResourceTypeRemote has the 'NestedResource' value you have to specify the ManyAssociationType on the ToMany relationship side).
//
//     -  NormalNestedResoure                   :
//     -  ShallowNestedResoure                  : When the nesting is shallow the url only contain the parent id
//     -  BothAttributesAndNormalNestedResoure  :
//     -  BothAttributesAndShallowNestedResoure :
//
//  *  BelongToAssociationClassRemote
//

#import "CoreSyncModelMapper.h"

@interface CoreSyncModelMapper (PrivateMethods)

- (void)addAttributePostValue:(NSString *)aPropertyKey
                   properties:(NSDictionary *)aProperties
                        model:(NSManagedObject *)aModel
              remoteClassName:(NSString *)aRemoteClassName
                      results:(NSMutableDictionary *)aPostValues;

- (void)addNestedAttributePostValues:(NSString *)aPropertyKey
                          properties:(NSDictionary *)aProperties
                               model:(NSManagedObject *)aModel
                     remoteClassName:(NSString *)aRemoteClassName
                             results:(NSMutableDictionary *)aPostValues;

- (BOOL)isValidCoreSyncEntity:(NSEntityDescription *)entity;
- (BOOL)isNestedResourceRelationship:(NSRelationshipDescription *)relationship;
- (BOOL)isParentAssociationRelationship:(NSRelationshipDescription *)relationship;
- (BOOL)isNormalResource:(NSEntityDescription *)entity;
- (BOOL)isNestedResource:(NSEntityDescription *)entity;
- (BOOL)doesUserInfoContainAssociationTypeIn:(NSRelationshipDescription *)relationship;
- (BOOL)doesUserInfoContainParentAssociationIn:(NSRelationshipDescription *)relationship;
- (BOOL)isAttributeDescription:(NSString *)propertyKey properties:(NSDictionary *)properties;
- (BOOL)isRelationshipDescription:(NSString *)propertyKey properties:(NSDictionary *)properties;

- (NSString *)normalResourceURL:(NSManagedObject *)model;
- (NSString *)nestedResourceURLUsingParentModel:(NSManagedObject *)parentModel;
@end

@implementation CoreSyncModelMapper

#pragma mark -
#pragma mark Properties

@synthesize mainManagedObjectContext = mainManagedObjectContext_;
@synthesize remoteSiteURL = remoteSiteURL_;

#pragma mark -
#pragma mark Init

/* - (id)initWith: */
//
- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext remoteSiteURL:(NSString*)aRemoteSiteURL {
    if ((self = [super init])) {
        self.mainManagedObjectContext = aMainManagedObjectContext;
        self.remoteSiteURL = aRemoteSiteURL;
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc

/* dealloc */
- (void)dealloc {
    [mainManagedObjectContext_ release], mainManagedObjectContext_ = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark CoreSync Mapping Setup

- (NSString *)localIdField {

    return @"remoteId";
}

- (NSString *)remoteIdField {

    return @"id";
}

- (NSString *)remoteCollectionName:(NSEntityDescription *)entity {

    return [[entity userInfo] objectForKey:@"remoteCollectionName"];
}

- (NSString *)remoteCollectionType:(NSEntityDescription *)entity {

    return [[entity userInfo] objectForKey:@"remoteCollectionType"];
}

- (NSString *)remoteClassName:(NSManagedObject *)model {

    return [[[model entity] userInfo] objectForKey:@"remoteClassName"];
}

- (BOOL)hasNestedResourceRelationshipsOnEntity:(NSEntityDescription *)entity {

    NSDictionary *properties = [entity propertiesByName];

    for (NSString *propertyKey in [properties allKeys]) {

        if ([self isRelationshipDescription:propertyKey properties:properties]) {

            NSRelationshipDescription *relationship = [properties objectForKey:propertyKey];

            // Check if the userInfo contains the key
            if ([self doesUserInfoContainAssociationTypeIn:relationship]) {

                NSString *associationTypeString = [[[relationship userInfo] valueForKey:@"associationType"] lowercaseString];
                return [associationTypeString isEqualToString:[@"NestedResource" lowercaseString]];
            }
        }
    }
    return NO;
}

#pragma mark -
#pragma mark CoreSync Field Mapping

- (NSString *)remoteNameForLocalField:(NSAttributeDescription *)attributeDescription {

    if ([[[attributeDescription userInfo] allKeys] containsObject:@"remoteAttribute"]) {
        return [[attributeDescription userInfo] valueForKey:@"remoteAttribute"];
    }
    return nil;
}


- (NSString *)localNameForRemoteField:(NSString*)name onModel:(NSManagedObject *)model {
    NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, name);

    NSDictionary *properties = [[model entity] propertiesByName];
    for (NSString *propertyKey in [properties allKeys]) {

        if ([self isAttributeDescription:propertyKey properties:properties]) {

            if ([[[[properties objectForKey:propertyKey] userInfo] valueForKey:@"remoteAttribute"] isEqual:name]) {
                return [[properties objectForKey:propertyKey] name];
            }

        } else if ([self isRelationshipDescription:propertyKey properties:properties]) {
            return [[properties objectForKey:propertyKey] name];
        }

    }
    return nil;
}

- (NSString *)remoteNameForLocalField:(NSString*)name onModel:(NSManagedObject *)model {

    NSDictionary *properties = [[model entity] propertiesByName];

    for (NSString *propertyKey in [properties allKeys]) {

        if ([self isAttributeDescription:propertyKey properties:properties]) {

            if ([[[properties objectForKey:propertyKey] name] isEqualToString:name]) {
                return [[[properties objectForKey:propertyKey] userInfo] valueForKey:@"remoteAttribute"];
            }
        }
    }
    return nil;
}

//- (NSAttributeDescription *)attributeDescriptionForField:(NSString *)field onModel:(NSManagedObject *)model {
//
//    NSDictionary *properties = [[model entity] propertiesByName];
//
//    for (NSString *propertyKey in [properties allKeys]) {
//
//        if ([self isAttributeDescription:propertyKey properties:properties]) {
//
//            if ([[[properties objectForKey:propertyKey] name] isEqual:field]) {
//                return [properties objectForKey:propertyKey];
//            }
//        }
//    }
//    return nil;
//}

- (NSPropertyDescription *)propertyDescriptionForField:(NSString *)field onModel:(NSManagedObject *)model {

    NSDictionary *properties = [[model entity] propertiesByName];

    for (NSString *propertyKey in [properties allKeys]) {

        if ([[[properties objectForKey:propertyKey] name] isEqual:field]) {
            return [properties objectForKey:propertyKey];
        }
    }
    return nil;
}

- (NSRelationshipDescription *)parentRelationshipDescription:(NSDictionary *)properties {

    for (NSString *propertyKey in [properties allKeys]) {

        if ([self isRelationshipDescription:propertyKey properties:properties]) {

            NSRelationshipDescription *relationship = [properties objectForKey:propertyKey];

            // Check if the userInfo contains the key
            if ([[[relationship userInfo] allKeys] containsObject:@"parentAssociation"]) {
                return relationship;
            }
        }
    }
    return nil;
}


#pragma mark -
#pragma mark URL Handling

- (NSString *)normalResourceURL:(NSManagedObject *)model {
    return [NSString stringWithFormat:@"%@/%@", [self remoteSiteURL], [self remoteCollectionName:[model entity]]];
}

//    Shallow Nested Resoures
//    -----------------------
//    index   GET    /jobs/:job_id/steps.json
//    show    GET    /steps/:id.json
//    create  POST   /jobs/:job_id/steps.json
//    update  PUT    /steps/:id.json
//    destroy DELETE /steps/:id.json
//
//    Normal Nested Resoures
//    ----------------------
//    index   GET    /workers/:worker_id/posts.json
//    show    GET    /workers/:worker_id/posts/:id.json
//    create  POST   /workers/:worker_id/posts.json
//    update  PUT    /workers/:worker_id/posts/:id.json
//    destroy DELETE /workers/:worker_id/posts/:id.json

- (NSString *)nestedResourceURLUsingChildModel:(NSManagedObject *)childModel {

    NSDictionary *properties = [[childModel entity] propertiesByName];

    for (NSString *propertyKey in [properties allKeys]) {

        if ([self isRelationshipDescription:propertyKey properties:properties]) {

            NSRelationshipDescription *relationship = [properties objectForKey:propertyKey];

            if ([self doesUserInfoContainParentAssociationIn:relationship]) {

                if ([self isParentAssociationRelationship:relationship]) {
                    NSString *parentCollectionPath = [self remoteCollectionName:[relationship destinationEntity]];
                    NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__,childModel);
                    NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__,[relationship name]);
                    NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__,[childModel valueForKey:[relationship name]]);
                    id parentRemoteId = [[childModel valueForKey:[relationship name]] valueForKey:[self localIdField]];
                    NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__,parentRemoteId);
                    NSString *childCollectionPath = [self remoteCollectionName:[childModel entity]];

                    // http://localhost:3000/jobs/1/steps
                    return [NSString stringWithFormat:@"%@/%@/%@/%@", [self remoteSiteURL],
                                                                       parentCollectionPath,
                                                                       parentRemoteId,
                                                                       childCollectionPath];
                }
            }
        }
    }
    return nil;
}

- (NSString *)nestedResourceURLUsingParentModel:(NSManagedObject *)parentModel {

    NSDictionary *properties = [[parentModel entity] propertiesByName];

    for (NSString *propertyKey in [properties allKeys]) {

        if ([self isRelationshipDescription:propertyKey properties:properties]) {

            NSRelationshipDescription *relationship = [properties objectForKey:propertyKey];

            if ([self doesUserInfoContainAssociationTypeIn:relationship]) {

                if ([self isNestedResourceRelationship: relationship]) {

                    NSString *parentCollectionPath = [self remoteCollectionName:[parentModel entity]];
                    id parentRemoteId = [parentModel valueForKey:[self localIdField]];
                    NSString *childCollectionPath = [self remoteCollectionName:[relationship destinationEntity]];

                    // http://localhost:3000/jobs/1/steps
                    return [NSString stringWithFormat:@"%@/%@/%@/%@", [self remoteSiteURL],
                                                                       parentCollectionPath,
                                                                       parentRemoteId,
                                                                       childCollectionPath];
                }
            }
        }
    }

    return nil;
}

- (NSString *)collectionURLUsingModel:(NSManagedObject *)model {

    NSEntityDescription *entity = [model entity];

    if ([self isValidCoreSyncEntity:entity]) {

        if ([self hasNestedResourceRelationshipsOnEntity:entity]) {
            return [self nestedResourceURLUsingParentModel:model];
        } else {
            return [NSString stringWithFormat:@"%@/%@", [self remoteSiteURL], [self remoteCollectionName:entity]];
        }
    }

    NSString *message = [NSString stringWithFormat:@"CoreSync does not have the required userInfo key/values for the entity %@. to work correctly.", [entity name]];

    NSException *coreSyncMappingMissingException = [NSException exceptionWithName:@"CoreSyncMappingMissingException"
                                                                           reason:message
                                                                         userInfo:nil];
    @throw coreSyncMappingMissingException;
}

- (NSString *)collectionURLUsingEntity:(NSEntityDescription *)entity {

    if ([self isValidCoreSyncEntity:entity]) {
        return [NSString stringWithFormat:@"%@/%@", [self remoteSiteURL], [self remoteCollectionName:entity]];
    }

    NSString *message = [NSString stringWithFormat:@"CoreSync does not have the required userInfo key/values for the entity %@. to work correctly.", [entity name]];

    NSException *coreSyncMappingMissingException = [NSException exceptionWithName:@"CoreSyncMappingMissingException"
                                                                           reason:message
                                                                         userInfo:nil];
    @throw coreSyncMappingMissingException;
}

- (NSString *)itemURLUsingModel:(NSManagedObject *)model action:(Actions)action {

    if (![model respondsToSelector:@selector(remoteId)]) {

        NSString *message = @"You have to define a remoteId property representing the Restful Model unique identifier.\n The attribute should be named 'remoteId' and should have a userInfo dictionary entry\n keyed 'remoteAttribute' specifying the remote Model unique identifier name.";

        NSException *remoteIDMappingMissingException = [NSException exceptionWithName:@"CoreSyncRemoteIDMappingMissingException"
                                                                               reason:message
                                                                             userInfo:nil];
        @throw remoteIDMappingMissingException;
    }

    NSEntityDescription *entity = [model entity];

    if ([self isValidCoreSyncEntity:entity]) {

        // ParentModel
        // -----------
        // Read     ->  /jobs/id (GET)
        // Create   ->  /jobs    (POST)
        // Update   ->  /jobs/id (PUT)
        // Delete   ->  /jobs/id (DELETE)

        // ChildModel
        // -----------
        //
        // - Nested ie. RemoteCollectionType -> NestedResource
        // Read     ->  /jobs/job_id/steps/id (GET)
        // Create   ->  /jobs/job_id/steps    (POST)
        // Update   ->  /jobs/job_id/steps/id (PUT)
        // Delete   ->  /jobs/job_id/steps/id (DELETE)
        //
        // - Normal ie. RemoteCollectionType -> NormalResource
        // Read     ->  /steps/id (GET)
        // Create   ->  /steps    (POST)
        // Update   ->  /steps/id (PUT)
        // Delete   ->  /steps/id (DELETE)


//        if ([self isNestedResource:entity]) {
//
//            switch (action) {
//                case Create:
//                    return [self nestedResourceURLUsingChildModel:model];
//                default:
//                    return [NSString stringWithFormat:@"%@/%@", [self nestedResourceURLUsingChildModel:model], [model valueForKey:[self localIdField]]];
//            }
//
//        } else {

            switch (action) {
                case Create:
                    return [self collectionURLUsingEntity:[model entity]];
                default:
                    return [NSString stringWithFormat:@"%@/%@", [self collectionURLUsingEntity:[model entity]], [model valueForKey:[self localIdField]]];
            }
//        }
    }
    return nil;
}

#pragma mark -
#pragma mark Helper Methods

- (NSDictionary *)postValuesForModel:(NSManagedObject *)model {

    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:10];

    NSString *remoteClassName = [[self remoteClassName:model] lowercaseString];

    NSDictionary *properties = [[model entity] propertiesByName];

    for (NSString *propertyKey in [properties allKeys]) {

        if ([self isAttributeDescription:propertyKey properties:properties]) {

            [self addAttributePostValue:propertyKey properties:properties model:model remoteClassName:remoteClassName results:results];

        } else if ([self isRelationshipDescription:propertyKey properties:properties]) {

            [self addNestedAttributePostValues:propertyKey properties:properties model:model remoteClassName:remoteClassName results:results];

        }
    }

    return results;
}


#pragma mark -
#pragma mark Private Methods

- (BOOL)isNormalResource:(NSEntityDescription *)entity {
    return [[[self remoteCollectionType:entity] lowercaseString] isEqualToString:[@"NormalResource" lowercaseString]];
}

- (BOOL)isNestedResource:(NSEntityDescription *)entity {
    return [[[self remoteCollectionType:entity] lowercaseString] isEqualToString:[@"NestedResource" lowercaseString]];
}

- (BOOL)doesUserInfoContainParentAssociationIn:(NSRelationshipDescription *)relationship {
    return [[[relationship userInfo] allKeys] containsObject:@"parentAssociation"];
}

- (BOOL)doesUserInfoContainAssociationTypeIn:(NSRelationshipDescription *)relationship {
    return [[[relationship userInfo] allKeys] containsObject:@"associationType"];
}

- (BOOL)isNestedResourceRelationship:(NSRelationshipDescription *)relationship {
    return [[[[relationship userInfo] valueForKey:@"associationType"] lowercaseString] isEqualToString:[@"NestedResource" lowercaseString]];
}

- (BOOL)isParentAssociationRelationship:(NSRelationshipDescription *)relationship {
    return [[[relationship userInfo] allKeys] containsObject:@"parentAssociation"];
}

- (BOOL)isAttributeDescription:(NSString *)propertyKey properties:(NSDictionary *)properties {
    return [[properties objectForKey:propertyKey] isKindOfClass:[NSAttributeDescription class]];
}

- (BOOL)isRelationshipDescription:(NSString *)propertyKey properties:(NSDictionary *)properties {
    return [[properties objectForKey:propertyKey] isKindOfClass:[NSRelationshipDescription class]];
}

- (void)addNestedAttributePostValues:(NSString *)aPropertyKey
                          properties:(NSDictionary *)aProperties
                               model:(NSManagedObject *)aModel
                     remoteClassName:(NSString *)aRemoteClassName
                             results:(NSMutableDictionary *)aPostValues {

    NSRelationshipDescription *relationship = [aProperties objectForKey:aPropertyKey];

    if ([relationship isToMany] && [self doesUserInfoContainAssociationTypeIn:relationship]) {

        NSString *associationType = [[[relationship userInfo] valueForKey:@"associationType"] lowercaseString];

        if ([associationType isEqualToString:[@"NestedAttributes" lowercaseString]] ||
            [associationType isEqualToString:[@"BothNestedResourceAndAttributes"lowercaseString]]) {

            NSEntityDescription *entity = [relationship destinationEntity];

            NSDictionary *properties = [entity propertiesByName];

            if (![[[entity userInfo] allKeys] containsObject:@"remoteClassName"]) return;

            NSString *remoteClassName = [[[entity userInfo] objectForKey:@"remoteClassName"] lowercaseString];

            int counter = 0;

            for (NSManagedObject *model in [aModel valueForKey:aPropertyKey]) {

                for (NSString *propertyKey in [properties allKeys]) {

                    if ([self isAttributeDescription:propertyKey properties:properties]) {

                        NSAttributeDescription *attribute = [properties objectForKey:propertyKey];

                        if ([[[attribute userInfo] allKeys] containsObject:@"remoteAttribute"]) {

                            NSString *remoteField = [[attribute userInfo] valueForKey:@"remoteAttribute"];

                            if (remoteField != nil) {

                                // job[steps_attributes][0][id]
                                NSString *postValueKey = [NSString stringWithFormat:@"%@[%@_attributes][%i][%@]", aRemoteClassName, remoteClassName, counter, remoteField];

                                [aPostValues setValue:[model valueForKey:[attribute name]] forKey:postValueKey];
                                counter++;
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)addAttributePostValue:(NSString *)aPropertyKey
                   properties:(NSDictionary *)aProperties
                        model:(NSManagedObject *)aModel
              remoteClassName:(NSString *)aRemoteClassName
                      results:(NSMutableDictionary *)aPostValues {

    NSAttributeDescription *attribute = [aProperties objectForKey:aPropertyKey];

    if ([[[attribute userInfo] allKeys] containsObject:@"remoteAttribute"]) {

        NSString *remoteField = [[attribute userInfo] valueForKey:@"remoteAttribute"];

        if (remoteField != nil) {
            NSString *postValueKey = [NSString stringWithFormat:@"%@[%@]", aRemoteClassName, remoteField];

            [aPostValues setValue:[aModel valueForKey:[attribute name]] forKey:postValueKey];
        }
    }
}

- (BOOL)isValidCoreSyncEntity:(NSEntityDescription *)entity {



    if (![[[entity userInfo] allKeys] containsObject:@"remoteCollectionType"]) {

        NSString *message = @"You have to define a Remote Collection Type property for the entity to indicate if the entity is a nested resource or a default resource.\n The attribute should be named 'remoteCollectionType' and should have a userInfo dictionary entry keyed 'remoteCollectionType'\n specifying either 'NestedResource' or 'NormalResource'.";

        NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, message);

        return NO;
    }

    if (![[[entity userInfo] allKeys] containsObject:@"remoteCollectionName"]) {

        NSString *message = @"You have to define a Remote Collection Name property.\n The attribute should be named 'remoteCollectionName' and should have a userInfo dictionary entry keyed 'remoteCollectionType'\n specifying the collection name for the resource i.e. A Project model would have a collection name of jobs.";

        NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, message);

        return NO;
    }

    if (![[[entity userInfo] allKeys] containsObject:@"remoteClassName"]) {

        NSString *message = @"You have to define a Remote Class Name property.\n The attribute should be named 'remoteClassName' and should have a userInfo dictionary entry keyed 'remoteClassName'\n specifying the class name for the resource on the remote server.";

        NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, message);

        return NO;
    }
    return YES;
}

@end
